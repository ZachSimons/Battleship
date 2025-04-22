.globl toSnd
toSnd:
j main
.globl send_value
.type send_value, @function
send_value:
lui a0,%hi(toSnd)
lw a0,%lo(toSnd)(a0)
ugs a0
nop
ret
main:
lui a1,%hi(toSnd)
addi a1,a1,%lo(toSnd)
lui a0,629760
sw a0,0(a1)
call send_value
lui a0,633888
sw a0,0(a1)
call send_value
lui a0,637968
sw a0,0(a1)
call send_value
lui a0,678960
sw a0,0(a1)
call send_value
nop
nop
