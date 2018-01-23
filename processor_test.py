import multiprocessing
import re

count = multiprocessing.cpu_count()
cpuset = 0
""" Number of available virtual or physical CPUs on this system, i.e.
   user/real as output by time(1) when called with an optimally scaling
   userspace-only program"""
# cpuset
# cpuset may restrict the number of *available* processors
m = re.search(r'(?m)^Cpus_allowed:\s*(.*)$',
              open('/proc/self/status').read())
if m:
    cpuset = bin(int(m.group(1).replace(',', ''), 16)).count('1')
    print(cpuset)


print(count)
with open('processor_count.txt') as outfile:
    outfile.write('Raw: %i\nCPU set:%i\n' % (count, cpuset))
