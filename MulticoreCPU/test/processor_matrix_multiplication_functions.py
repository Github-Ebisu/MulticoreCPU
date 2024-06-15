import math
import random
import struct
import time

import serial


def create_random_matrices(a, b, c, core_count):
    writeFile = open("../MulticoreCPU/test/1_matrix_in.txt", "w")

    writeFile.write(
        str(a)
        + "\n"
        + str(b)
        + "\n"
        + str(c)
        + "\n"
        + str(core_count)
        + " //number of cores"
        + "\n"
    )

    writeFile.write("\n//matrix A\n")
    out = ""
    for x in range(a):
        temp = ""
        for y in range(b):
            temp += str(random.randint(-5, 5)) + " "
        out += temp + "\n"

    print(out)
    writeFile.write(out)

    writeFile.write("\n//matrix B\n")

    out = ""
    for x in range(b):
        temp = ""
        for y in range(c):
            temp += str(random.randint(-5, 5)) + " "
        out += temp + "\n"

    print(out)
    writeFile.write(out)
    writeFile.close()

    return


def decode(instruction):
    isa = {
        "NOP": "00000000",
        "ENDOP": "00000001",
        "CLAC": "00000010",
        "LDIAC": "00000011",
        "LDAC": "00000100",
        "STR": "00000101",
        "STIR": "00000110",
        "JUMP": "00000111",
        "JMPNZ": "00001000",
        "JMPZ": "00001001",
        "MUL": "00001010",
        "ADD": "00001011",
        "SUB": "00001100",
        "INCAC": "00001101",
        "MV_RL_AC": "00011111",
        "MV_RP_AC": "00101111",
        "MV_RQ_AC": "00111111",
        "MV_RC_AC": "01001111",
        "MV_R_AC": "01011111",
        "MV_R1_AC": "01101111",
        "MV_AC_RP": "01111111",
        "MV_AC_RQ": "10001111",
        "MV_AC_RL": "10011111",
    }
    if instruction in isa:
        return isa[instruction]
    else:
        return instruction


def read_assembly_code():
    code = open("../MulticoreCPU/test/2_assembly_code.txt", "r")
    txt_code = code.read().strip().split("\n")
    machine_code = open("../MulticoreCPU/test/5_ins_mem_tb.txt", "w")

    decoded_code = []
    i = 0
    while i < len(txt_code):
        if txt_code[i][0] == "/":
            i += 1
            continue
        codewithoutcomments = ""
        for j in txt_code[i]:
            if j != "/":
                codewithoutcomments += j
            else:
                break
        assert codewithoutcomments[-1] == ";", "Error! missing ; at the end of the line"
        temp = codewithoutcomments[:-1]
        decoded_int = decode(temp)
        if (
            temp == "LDIAC"
            or temp == "STIR"
            or temp == "JMPNZ"
            or temp == "JUMP"
            or temp == "JMPZ"
        ):
            decoded_code.append(decoded_int)
            address = txt_code[i + 1]
            addresswithoutcomments = ""
            for j in address:
                if j != "/":
                    addresswithoutcomments += j
                else:
                    break
            assert (
                addresswithoutcomments[-1] == ";"
            ), "Error! missing ; at the end of the line"
            decoded_code.append("{0:08b}".format(int(addresswithoutcomments[:-1])))
            i += 1
        else:
            decoded_code.append(decoded_int)
        i += 1

    for i in range(0, 256, 1):
        if i < len(decoded_code):
            # print (decoded_code[i])
            machine_code.write(decoded_code[i] + "\n")
        else:
            # print ("XXXXXXXX")
            machine_code.write("00000000" + "\n")

    machine_code.close()


def arrange_and_send_data_memory(a, b, c, d, core_count):
    data = open("../MultiCoreCPU/test/1_matrix_in.txt", "r")
    txt_code = data.read().strip().split("\n")
    machine_code = open("../MulticoreCPU/test/3_data_mem_tb.txt", "w")

    out = []

    a = int(txt_code[0])
    b = int(txt_code[1])
    c = int(txt_code[2])

    cores = int(txt_code[3][0])
    memory_depth = 2048

    d = math.ceil(a / cores)  # (number of raws reduces)

    start_addr_P = 14
    start_addr_Q = start_addr_P + d * b
    start_addr_R = start_addr_Q + b * c + 1  # with extra space
    end_addr_P = start_addr_P + d * b - 1
    end_addr_Q = start_addr_Q + b * c - 1
    end_addr_R = start_addr_R + d * c - 1

    out.append("{0:012b}".format(a) * cores)
    out.append("{0:012b}".format(b) * cores)
    out.append("{0:012b}".format(c) * cores)

    out.append("{0:012b}".format(start_addr_P) * cores)
    out.append("{0:012b}".format(start_addr_Q) * cores)
    out.append("{0:012b}".format(start_addr_R) * cores)
    out.append("{0:012b}".format(end_addr_P) * cores)
    out.append("{0:012b}".format(end_addr_Q) * cores)
    out.append("{0:012b}".format(end_addr_R) * cores)

    out.append("{0:012b}".format(0) * cores)
    out.append("{0:012b}".format(0) * cores)
    out.append("{0:012b}".format(0) * cores)
    out.append("{0:012b}".format(0) * cores)
    out.append("{0:012b}".format(0) * cores)

    i = 4
    while txt_code[i] == "" or txt_code[i][0] == "/":  # to find the start of matrix A
        i = i + 1

    A = []
    for x in range(i, i + a):
        temp2 = []
        temp = txt_code[x].strip().split(" ")
        for j in temp:
            if int(j) >= 0:
                temp2.append("{0:012b}".format(int(j)))
            else:
                temp2.append(
                    bin((int("1" * 12, 2) ^ abs(int(j))) + 1)[2:]
                )  ## 2's complement
        A.append(temp2)

    if len(A) % core_count != 0:
        for k in range(core_count - len(A) % core_count):
            temp = ["{0:012b}".format(int(0)) for i in range(len(A[0]))]
            A.append(temp)

    for x in range(0, len(A), core_count):
        for y in range(len(A[0])):
            temporary_bin = ""
            for k in range(core_count):
                temporary_bin += A[x + k][y]
            out.append(temporary_bin)
    i = i + a
    while txt_code[i] == "" or txt_code[i][0] == "/":  # to find the start of matrix B
        i = i + 1

    matrix_B = []
    for x in range(i, i + b):
        temp = txt_code[x].strip().split(" ")
        matrix_B.append(temp)

    for y in range(c):
        for x in range(b):
            temporary_bin = ""
            for k in range(core_count):
                if int(matrix_B[x][y]) < 0:
                    temporary_bin += bin(
                        (int("1" * 12, 2) ^ abs(int(matrix_B[x][y]))) + 1
                    )[
                        2:
                    ]  ## 2's complement
                else:
                    temporary_bin += "{0:012b}".format(int(matrix_B[x][y]))
            out.append(temporary_bin)

    for i in range(0, memory_depth, 1):
        if i < len(out):
            machine_code.write(out[i] + "\n")
        else:
            no_xx = "000000000000" * cores
            machine_code.write(no_xx + "\n")
    machine_code.close()


def calculate_answer_matrix():
    data = open("../MultiCoreCPU/test/1_matrix_in.txt", "r")
    txt_code = data.read().strip().split("\n")
    writeFile = open("../MulticoreCPU/test/4_answer_matrix_PC.txt", "w")
    out = []

    a = int(txt_code[0])
    b = int(txt_code[1])
    c = int(txt_code[2])

    # matrix A - a x b
    # matrix B - b x c
    i = 4
    while txt_code[i] == "" or txt_code[i][0] == "/":  # to find the start of matrix A
        i = i + 1

    A = []
    for x in range(i, i + a):
        temp = txt_code[x].strip().split(" ")
        A.append(temp)
    i = i + a
    while txt_code[i] == "" or txt_code[i][0] == "/":  # to find the start of matrix B
        i = i + 1

    matrix_B = []
    for x in range(i, i + b):
        temp = txt_code[x].strip().split(" ")
        matrix_B.append(temp)

    mul = []

    # begin_time = time.time()

    for i in range(int(a)):
        temp_list = []
        for k in range(int(c)):
            temp_ans = 0
            for j in range(int(b)):
                temp_ans += int(A[i][j]) * int(matrix_B[j][k])
                if temp_ans < 0:
                    val = "-" + hex(temp_ans)[3:]
                else:
                    val = hex(temp_ans)[2:]
            temp_list.append(" " * (5 - len(val)) + val)
        mul.append(temp_list)
    out = " "
    for i in mul:
        temp = ""
        for j in i:
            temp += str(j) + " "
        out += temp + "\n "
    # print(out)
    writeFile.write(out)
    writeFile.close()
