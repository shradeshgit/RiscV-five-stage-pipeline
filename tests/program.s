.text

addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sw   x3, 0(x0)
lw   x4, 0(x0)
beq  x3, x4, PASS
addi x5, x0, 111
PASS:

addi x6, x0, 999