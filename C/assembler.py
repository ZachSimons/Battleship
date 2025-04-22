import sys
import struct

# Register constants
REGISTER_DICT = {
    "zero": 0,
    "ra":   1,
    "sp":   2,
    "gp":   3,
    "tp":   4,
    "t0":   5,
    "t1":   6,
    "t2":   7,
    "s0":   8,
    "s1":   9,
    "a0":   10,
    "a1":   11,
    "a2":   12,
    "a3":   13,
    "a4":   14,
    "a5":   15,
    "a6":   16,
    "a7":   17,
    "s2":   18,
    "s3":   19,
    "s4":   20,
    "s5":   21,
    "s6":   22,
    "s7":   23,
    "s8":   24,
    "s9":   25,
    "s10":  26,
    "s11":  27,
    "t3":   28,
    "t4":   29,
    "t5":   30,
    "t6":   31,
    "x0":   0,
    "x1":   1,
    "x2":   2,
    "x3":   3,
    "x4":   4,
    "x5":   5,
    "x6":   6,
    "x7":   7,
    "x8":   8,
    "x9":   9,
    "x10":  10,
    "x11":  11,
    "x12":  12,
    "x13":  13,
    "x14":  14,
    "x15":  15,
    "x16":  16,
    "x17":  17,
    "x18":  18,
    "x19":  19,
    "x20":  20,
    "x21":  21,
    "x22":  22,
    "x23":  23,
    "x24":  24,
    "x25":  25,
    "x26":  26,
    "x27":  27,
    "x28":  28,
    "x29":  29,
    "x30":  30,
    "x31":  31,
}

# OPCODES
OP_IMM_CODE = 0b0010011
LUI_CODE    = 0b0110111
AUIPC_CODE  = 0b0010111
OP_CODE     = 0b0110011
JAL_CODE    = 0b1101111
JALR_CODE   = 0b1100111
BRANCH_CODE = 0b1100011
LOAD_CODE   = 0b0000011
STORE_CODE  = 0b0100011
RTI_CODE    = 0b0001000
RSI_CODE    = 0b0001001
UGS_CODE    = 0b0101000
UAD_CODE    = 0b0101011
SAC_CODE    = 0b0101001
RDI_CODE    = 0b0001010
LDR_CODE    = 0b0101010
SND_CODE    = 0b0001011

# funct3
TOGGLE_BIT  = 2**30
ADD         = 0b000 << 12
SLL         = 0b001 << 12
SLT         = 0b010 << 12
SLTU        = 0b011 << 12
XOR         = 0b100 << 12
SRL         = 0b101 << 12
OR          = 0b110 << 12
AND         = 0b111 << 12

BEQ         = 0b000 << 12
BNE         = 0b001 << 12
BLT         = 0b100 << 12
BGE         = 0b101 << 12
BLTU        = 0b110 << 12
BGEU        = 0b111 << 12

LB          = 0b000 << 12
LH          = 0b001 << 12
LW          = 0b010 << 12
LBU         = 0b100 << 12
LHU         = 0b101 << 12
SB          = 0b000 << 12
SH          = 0b001 << 12
SW          = 0b010 << 12

def negative(value: int, size: int):
    return (2**size-1)&(~(value*-1)) + 1

def rd_reg(reg: int):
    return reg << 7

def rs1_reg(reg: int):
    return reg << 15

def rs2_reg(reg: int):
    return reg << 20

def iTypeImm(value: int):
    if value >= 0:
        return value << 20
    else:
        complement = negative(value, 12)
        return complement << 20

def sTypeImm(value: int):
    if value >= 0:
        return ((value%32)<<7) | ((value-(value%32))<<20)
    else:
        complement = negative(value, 12)
        return ((complement%32)<<7) | ((complement-(complement%32))<<20)

def bTypeImm(value: int):
    if value >= 0:
        return ((value&(2**12))<<19) | (((value%(2**11)) & ~(2**5-1))<<20) | ((value%(2**5))<<7) | ((value&(2**11))>>4)
    else:
        complement = negative(value, 13)
        return ((complement&(2**12))<<19) | (((complement%(2**11)) & ~(2**5-1))<<20) | ((complement%(2**5))<<7) | ((complement&(2**11))>>4)

def uTypeImm(value: int):
    if value >= 0:
        return (value & (2**20-1)) << 12
    else:
        complement = negative(value, 20)
        return (complement & (2**20-1)) << 12

def jTypeImm(value: int):
    if value >= 0:
        return ((value & (2**20))<<11) | ((value % (2**11))<<20) | ((value & (2**11))<<9) | (((value%(2**20)) & ((2**20-1) - (2**12-1))))
    else:
        complement = negative(value, 21)
        return ((complement & (2**20))<<11) | ((complement % (2**11))<<20) | ((complement & (2**11))<<9) | (((complement%(2**20)) & ((2**20-1) - (2**12-1))))
    
def calculateOffset(current: int, target: int):
    if (target - current) % 4:
        print("ERROR: unaligned branch attempted " + str(target) + " <- " + str(current))
        sys.exit(1)
    return target - current

def parseAddress(address: str):
    if address.find('%') != -1:
        result = address.split('(')
        return [result[2][:-1], label_addresses[result[1][:-1]]]
    else:
        result = address.split('(')
        return [result[1][:-1], int(result[0])]

def parseSingleHiLo(param: str):
    if(param.find('%') == -1):
        return param
    else:
        if param.find('%hi'):
            return str(label_addresses[param.split('(')[1][:-1]] & ~(2**12-1))
        else:
            return str(label_addresses[param.split('(')[1][:-1]] % 2**12)

label_addresses = {}
data_sizes = {}

if __name__ == '__main__':
    if(len(sys.argv) != 2):
        print("ERROR: usage python assembler.py <filename>")
        sys.exit(1)
    with open(sys.argv[1], "r") as inputFile:
        with open("output.hex", "w") as outputFile:
            currentAddress = 0
            linesList = [line.split('#')[0].strip() for line in inputFile.readlines() if (not line.strip().startswith('#')) and line.strip()]

            # Get all address labels
            for line in linesList:
                if line.find('.globl') != -1:
                    data_sizes[line.split()[1]] = 0
                elif line.find('.type') != -1 and line.find('@function') != -1:
                    del data_sizes[line.split()[1][:-1]]
                elif line.find('.size') != -1 and not line.split()[1][:-1] in label_addresses.keys():
                    data_sizes[line.split()[1][:-1]] = int(line.split()[2])
                elif line.endswith(':'):
                    if not line[:-1] in data_sizes.keys():
                        label_addresses[line[:-1]] = currentAddress
                elif line[0] != '.':
                    if line.strip().split(' ')[0] == 'la':
                        currentAddress += 8
                    elif line.strip().split(' ')[0] == 'li':
                        currentAddress += 8
                    elif line.strip().split(' ')[0] == 'call':
                        currentAddress += 8
                    elif line.strip().split(' ')[0] == 'tail':
                        currentAddress += 8
                    else:
                        currentAddress += 4

            data_address = 0
            for key, size in data_sizes.items():
                label_addresses[key] = data_address
                data_address += size

            # Convert assembly to binary
            error_cnt = 0
            currentAddress = 0
            for line in linesList:
                if line.endswith(':') or line[0] == '.':
                    continue
                else:
                    instruction = line.split()
                    instruction[0] = instruction[0].lower()
                    if len(instruction) > 1:
                        parameters = instruction[1].split(',')
                    if(instruction[0] == 'lui'):
                        outputFile.write(format(LUI_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(int(parseSingleHiLo(parameters[1]))), '08x') + '\n')
                    elif(instruction[0] == 'auipc'):
                        outputFile.write(format(AUIPC_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(int(parameters[1])), '08x') + '\n')
                    elif(instruction[0] == 'jal'):
                        outputFile.write(format(JAL_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + jTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'jalr'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(JALR_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'beq'):
                        outputFile.write(format(BRANCH_CODE + BEQ + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bne'):
                        outputFile.write(format(BRANCH_CODE + BNE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'blt'):
                        outputFile.write(format(BRANCH_CODE + BLT + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bge'):
                        outputFile.write(format(BRANCH_CODE + BGE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bltu'):
                        outputFile.write(format(BRANCH_CODE + BLTU + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bgeu'):
                        outputFile.write(format(BRANCH_CODE + BGEU + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'lb'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(LOAD_CODE + LB + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'lh'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(LOAD_CODE + LH + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'lw'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(LOAD_CODE + LW + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'lbu'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(LOAD_CODE + LBU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'lhu'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(LOAD_CODE + LHU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'sb'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(STORE_CODE + SB + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + sTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'sh'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(STORE_CODE + SH + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + sTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'sw'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(format(STORE_CODE + SW + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + sTypeImm(addressCalc[1]), '08x') + '\n')
                    elif(instruction[0] == 'addi'):
                        outputFile.write(format(OP_IMM_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parseSingleHiLo(parameters[2]))), '08x') + '\n')
                    elif(instruction[0] == 'slti'):
                        outputFile.write(format(OP_IMM_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'sltiu'):
                        outputFile.write(format(OP_IMM_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'xori'):
                        outputFile.write(format(OP_IMM_CODE + XOR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'ori'):
                        outputFile.write(format(OP_IMM_CODE + OR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'andi'):
                        outputFile.write(format(OP_IMM_CODE + AND + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'slli'):
                        outputFile.write(format(OP_IMM_CODE + SLL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'srli'):
                        outputFile.write(format(OP_IMM_CODE + SRL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'srai'):
                        outputFile.write(format(OP_IMM_CODE + SRL + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2])), '08x') + '\n')
                    elif(instruction[0] == 'add'):
                        outputFile.write(format(OP_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'sub'):
                        outputFile.write(format(OP_CODE + ADD + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'sll'):
                        outputFile.write(format(OP_CODE + SLL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'slt'):
                        outputFile.write(format(OP_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'sltu'):
                        outputFile.write(format(OP_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'xor'):
                        outputFile.write(format(OP_CODE + XOR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'srl'):
                        outputFile.write(format(OP_CODE + SRL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'sra'):
                        outputFile.write(format(OP_CODE + SRL + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'or'):
                        outputFile.write(format(OP_CODE + OR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'and'):
                        outputFile.write(format(OP_CODE + AND + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]]), '08x') + '\n')
                    elif(instruction[0] == 'rti'):
                        outputFile.write(format(RTI_CODE, '08x') + '\n')
                    elif(instruction[0] == 'rsi'):
                        outputFile.write(format(RSI_CODE + rs1_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'rdi'):
                        outputFile.write(format(RDI_CODE + rd_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'ldr'):
                        outputFile.write(format(LDR_CODE + rd_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'sac'):
                        outputFile.write(format(SAC_CODE + rd_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'ugs'):
                        outputFile.write(format(UGS_CODE + rs1_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'uad'):
                        outputFile.write(format(UAD_CODE + rs1_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'snd'):
                        outputFile.write(format(SND_CODE + rs1_reg(REGISTER_DICT[parameters[0]]), '08x') + '\n')
                    elif(instruction[0] == 'la'):
                        currentAddress += 4
                        outputFile.write(format(AUIPC_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(0 if label_addresses[parameters[1]] < 0 and label_addresses[parameters[1]] & 2**11 == 1 else label_addresses[parameters[1]] >> 12), '08x') + '\n')
                        outputFile.write(format(OP_IMM_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[0]]) + iTypeImm(label_addresses[parameters[1]] % 2**12), '08x') + '\n')
                    elif(instruction[0] == 'nop'):
                        outputFile.write(format(OP_IMM_CODE + ADD + rd_reg(0) + rs1_reg(0) + iTypeImm(0), '08x') + '\n')
                    elif(instruction[0] == 'li'):
                        currentAddress += 4
                        outputFile.write(format(LUI_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(0 if int(parameters[1]) < 0 and int(parameters[1]) & 2**11 == 1 else int(parameters[1]) >> 12), '08x') + '\n')
                        outputFile.write(format(OP_IMM_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[0]]) + iTypeImm(int(parameters[1]) % 2**12), '08x') + '\n')
                    elif(instruction[0] == 'mv'):
                        outputFile.write(format(OP_IMM_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(0), '08x') + '\n')
                    elif(instruction[0] == 'not'):
                        outputFile.write(format(OP_IMM_CODE + XOR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(-1), '08x') + '\n')
                    elif(instruction[0] == 'neg'):
                        outputFile.write(format(OP_CODE + ADD + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(0) + rs2_reg(REGISTER_DICT[parameters[1]]), '08x') + '\n')
                    elif(instruction[0] == 'seqz'):
                        outputFile.write(format(OP_IMM_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(1), '08x') + '\n')
                    elif(instruction[0] == 'snez'):
                        outputFile.write(format(OP_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(0) + rs2_reg(REGISTER_DICT[parameters[1]]), '08x') + '\n')
                    elif(instruction[0] == 'sltz'):
                        outputFile.write(format(OP_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(0), '08x') + '\n')
                    elif(instruction[0] == 'sgtz'):
                        outputFile.write(format(OP_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(0) + rs2_reg(REGISTER_DICT[parameters[1]]), '08x') + '\n')
                    elif(instruction[0] == 'beqz'):
                        outputFile.write(format(BRANCH_CODE + BEQ + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(0) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'bnez'):
                        outputFile.write(format(BRANCH_CODE + BNE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(0) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'blez'):
                        outputFile.write(format(BRANCH_CODE + BGE + rs1_reg(0) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'bgez'):
                        outputFile.write(format(BRANCH_CODE + BGE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(0) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'bltz'):
                        outputFile.write(format(BRANCH_CODE + BLT + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(0) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'bgtz'):
                        outputFile.write(format(BRANCH_CODE + BLT + rs1_reg(0) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[1]]))), '08x') + '\n')
                    elif(instruction[0] == 'bgt'):
                        outputFile.write(format(BRANCH_CODE + BLT + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'ble'):
                        outputFile.write(format(BRANCH_CODE + BGE + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bgtu'):
                        outputFile.write(format(BRANCH_CODE + BLTU + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'bleu'):
                        outputFile.write(format(BRANCH_CODE + BGEU + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[0]]) + bTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[2]]))), '08x') + '\n')
                    elif(instruction[0] == 'j'):
                        outputFile.write(format(JAL_CODE + rd_reg(0) + jTypeImm(calculateOffset(currentAddress, int(label_addresses[parameters[0]]))), '08x') + '\n')
                    elif(instruction[0] == 'jr'):
                        outputFile.write(format(JALR_CODE + rd_reg(0) + rs1_reg(REGISTER_DICT[parameters[0]]) + iTypeImm(0), '08x') + '\n')
                    elif(instruction[0] == 'ret'):
                        outputFile.write(format(JALR_CODE + rd_reg(0) + rs1_reg(1) + iTypeImm(0), '08x') + '\n')
                    elif(instruction[0] == 'call'):
                        offset = calculateOffset(currentAddress, label_addresses[parameters[0]])
                        currentAddress += 4
                        outputFile.write(format(AUIPC_CODE + rd_reg(6) + uTypeImm(0 if offset < 0 else offset >> 12), '08x') + '\n')
                        outputFile.write(format(JALR_CODE + rd_reg(1) + rs1_reg(6) + iTypeImm(offset % 2**12), '08x') + '\n')
                    elif(instruction[0] == 'tail'):
                        offset = calculateOffset(currentAddress, label_addresses[parameters[0]])
                        currentAddress += 4
                        outputFile.write(format(AUIPC_CODE + rd_reg(6) + uTypeImm(0 if offset < 0 else offset >> 12), '08x') + '\n')
                        outputFile.write(format(JALR_CODE + rd_reg(0) + rs1_reg(6) + iTypeImm(offset % 2**12), '08x') + '\n')
                    elif(instruction[0] == 'ecall'):
                        outputFile.write(format(0x73, '08x') + '\n')
                    else:
                        print("ERROR: Unrecognized instruction " + str(instruction))
                        outputFile.write("error")
                        error_cnt += 1
                    currentAddress += 4
    print("ERROR COUNT: " + str(error_cnt))
    # UNSUPPORTED COMMANDS
    # l{b|h|w} rd, symbol
    # s{b|h|w} rd, symbol, rt
    # jal offset
    # jalr rs
    sys.exit(0)