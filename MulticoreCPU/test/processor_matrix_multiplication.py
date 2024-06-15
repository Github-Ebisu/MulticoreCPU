import math
import time

from processor_matrix_multiplication_functions import *

# matrix A - a x b
# matrix B - b x c
a = int(input("give a: "))
b = int(input("give b: "))
c = int(input("give c: "))
core_count = int(input("give number of cores: "))
d = math.ceil(a / core_count)  # (number of raws per one core)

create_random_matrices(a, b, c, core_count)

read_assembly_code()

time.sleep(1)  ## time gap between insMem, dataMem transmission

arrange_and_send_data_memory(a, b, c, d, core_count)

calculate_answer_matrix()
