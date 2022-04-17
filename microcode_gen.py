# helper script for generating microcode states with
# branch type == '0' (not using the mapping function for next addr)
# and conditional bits == "00" (unconditional ucode jump)
# NOTE MUST HAVE LESS THAN OR EQUAL TO 4 STATES

# get info from the user so we can build the VHDL code
instr = input("Type the name of the instruction: ")
num_states = int(input('How many states does it have? '))
original_num = num_states # used for if we overwrite num_states to 4
start_loc = int(input('What is this instruction\'s starting location in memory? '))
print('Generating VHDL code...')
print('')

# calculate instr's opcode from its mem loc
opcode = int(start_loc/4) # inverse of the mapping function
opcode = bin(opcode) # to binary
opcode = opcode[2:] # cut off '0b'
opcode = (8-len(opcode))*'0' + opcode # force 8bits

# make instr all caps
instr = instr.upper()

# warn that it will only generate four states
if (num_states > 4):
    print('WARNING! This script only generates 4 contiguous states.')
    print('You will have to manually handle all states after the fourth.')
    print('The testbench code will be okay, though.')
    input('Press enter to continue...')
    print('')
    num_states = 4

# generate the code to paste into the initialization list for ucode mem
for i in range(num_states):
    # resolve ucode mem location
    loc = start_loc + i

    # get jump address in binary
    if i < original_num-1:
        # addr should be next mem loc
        jump_addr = bin(loc+1)
        jump_addr = jump_addr[2:] # cut off '0b'
        jump_addr = '0'*(6-len(jump_addr)) + jump_addr # append leading zeros to have 6 bits total
    else:
        # addr needs to be set to FETCH1 (000001)
        jump_addr = '000001'

    # print the line of microcode memory
    line = ('\t{} => x"0000000" & "000000000000000000000000000" & \'0\' & "00" & "{}", -- {}{}'
        .format(
            loc,
            jump_addr,
            instr,
            i+1
        )
    )
    print(line)

# aesthetic spacing
print('')
print('')

# generate corresponding code to place in the testbench
code = """\
\tfakeIR <= "{}"; -- {} ({} states)
\twait for {} ns;
""".format(
    opcode,
    instr,
    original_num,
    str((3+original_num)*20)

)
print(code)