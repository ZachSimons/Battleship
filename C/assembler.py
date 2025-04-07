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
ADD         = 0b000
SLL         = 0b001
SLT         = 0b010
SLTU        = 0b011
XOR         = 0b100
SRL         = 0b101
OR          = 0b110
AND         = 0b111

BEQ         = 0b000
BNE         = 0b001
BLT         = 0b100
BGE         = 0b101
BLTU        = 0b110
BGEU        = 0b111

LB          = 0b000
LH          = 0b001
LW          = 0b010
LBU         = 0b100
LHU         = 0b101
SB          = 0b000
SH          = 0b001
SW          = 0b010

def negative(value: int):
    return (2**12-1)&(~(value*-1)) + 1

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
        complement = negative(value)
        return complement << 20

def sTypeImm(value: int):
    if value >= 0:
        return ((value%32)<<7) | ((value-(value%32))<<20)
    else:
        complement = negative(value)
        return ((complement%32)<<7) | ((complement-(complement%32))<<20)

def bTypeImm(value: int):
    if value >= 0:
        return ((value&(2**12))<<19) | (((value%(2**11)) & ~(2**5-1))<<20) | ((value%(2**5))<<7) | ((value&(2**11))>>4)
    else:
        complement = negative(value)
        return ((complement&(2**12))<<19) | (((complement%(2**11)) & ~(2**5-1))<<20) | ((complement%(2**5))<<7) | ((complement&(2**11))>>4)

def uTypeImm(value: int):
    if value >= 0:
        return value & ~(2**12-1)
    else:
        complement = negative(value)
        return complement & ~(2**12-1)

def jTypeImm(value: int):
    if value >= 0:
        return ((value & (2**20))<<11) | ((value % (2**11))<<20) | ((value & (2**11))<<9) | (((value%(2**20)) & ~(2**12-1)))
    else:
        complement = negative(value)
        return ((complement & (2**20))<<11) | ((complement % (2**11))<<20) | ((complement & (2**11))<<9) | (((complement%(2**20)) & ~(2**12-1)))
    
def calculateOffset(current: int, target: int):
    if target - current % 4:
        print("ERROR: unaligned branch attempted " + str(current))
        sys.exit(1)
    return target - current

def parseAddress(address: str):
    result = address.split('(')
    return [result[1][:-1], int(result[0])]

label_addresses = {}

if __name__ == '__main__':
    if(len(sys.argv) != 2):
        print("ERROR: usage python assembler.py <filename>")
        sys.exit(1)
    with open(sys.argv[1], "r") as inputFile:
        with open("output.hex", "wb") as outputFile:
            currentAddress = 0
            linesList = [line.strip() for line in inputFile.readlines()]

            # Get all address labels
            for line in linesList:
                if line.endswith(':'):
                    label_addresses[line[:-1]] = currentAddress
                elif line[0] != '.':
                    currentAddress += 4

            # Convert assembly to binary
            currentAddress = 0
            for line in linesList:
                if line.endswith(':') or line[0] == '.':
                    continue
                else:
                    instruction = line.split()
                    if len(instruction) > 1:
                        parameters = instruction[1].split(',')
                    if(instruction[0] == 'lui'):
                        outputFile.write(struct.pack('I', LUI_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(int(parameters[1]))))
                    elif(instruction[0] == 'auipc'):
                        outputFile.write(struct.pack('I', AUIPC_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + uTypeImm(int(parameters[1]))))
                    elif(instruction[0] == 'jal'):
                        outputFile.write(struct.pack('I', JAL_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + jTypeImm(calculateOffset(currentAddress, int(parameters[1])))))
                    elif(instruction[0] == 'jalr'):
                        outputFile.write(struct.pack('I', JALR_CODE + rd_reg(REGISTER_DICT[parameters[0]]) + jTypeImm(calculateOffset(currentAddress, int(parameters[1])))))
                    elif(instruction[0] == 'beq'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BEQ + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'bne'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BNE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'blt'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BLT + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'bge'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BGE + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'bltu'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BLTU + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'bgeu'):
                        outputFile.write(struct.pack('I', BRANCH_CODE + BGEU + rs1_reg(REGISTER_DICT[parameters[0]]) + rs2_reg(REGISTER_DICT[parameters[1]]) + bTypeImm(calculateOffset(currentAddress, int(parameters[2])))))
                    elif(instruction[0] == 'lb'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', LOAD_CODE + LB + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'lh'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', LOAD_CODE + LH + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'lw'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', LOAD_CODE + LW + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'lbu'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', LOAD_CODE + LBU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'lhu'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', LOAD_CODE + LHU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'sb'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', STORE_CODE + SB + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'sh'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', STORE_CODE + SH + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'sw'):
                        addressCalc = parseAddress(parameters[1])
                        outputFile.write(struct.pack('I', STORE_CODE + SW + rs2_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[addressCalc[0]]) + iTypeImm(addressCalc[1])))
                    elif(instruction[0] == 'addi'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'slti'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'sltiu'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'xori'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + XOR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'ori'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + OR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'andi'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + AND + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'slli'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + SLL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'srli'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + SRL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'srai'):
                        outputFile.write(struct.pack('I', OP_IMM_CODE + SRL + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + iTypeImm(int(parameters[2]))))
                    elif(instruction[0] == 'add'):
                        outputFile.write(struct.pack('I', OP_CODE + ADD + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'sub'):
                        outputFile.write(struct.pack('I', OP_CODE + ADD + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'sll'):
                        outputFile.write(struct.pack('I', OP_CODE + SLL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'slt'):
                        outputFile.write(struct.pack('I', OP_CODE + SLT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'sltu'):
                        outputFile.write(struct.pack('I', OP_CODE + SLTU + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'xor'):
                        outputFile.write(struct.pack('I', OP_CODE + XOR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'srl'):
                        outputFile.write(struct.pack('I', OP_CODE + SRL + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'sra'):
                        outputFile.write(struct.pack('I', OP_CODE + SRL + TOGGLE_BIT + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'or'):
                        outputFile.write(struct.pack('I', OP_CODE + OR + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    elif(instruction[0] == 'and'):
                        outputFile.write(struct.pack('I', OP_CODE + AND + rd_reg(REGISTER_DICT[parameters[0]]) + rs1_reg(REGISTER_DICT[parameters[1]]) + rs2_reg(REGISTER_DICT[parameters[2]])))
                    else:
                        print("ERROR: Unrecognized instruction " + str(instruction))
                        sys.exit(1)
    sys.exit(0)