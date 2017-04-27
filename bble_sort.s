.data
    .align 0
    str_tam : 
        .asciiz "Digite o tamanho do vetor: "
    str_res :
         .asciiz "O vetor ordenado eh : "
    str_space :
         .asciiz " "
    
.globl main
.text
    .align 2
    
    main:
        addi $v0, $zero, 4 
        la $a0, str_tam
        syscall
        
        addi $v0, $zero, 5
        syscall
        
        or $t1, $zero, $v0 #guarda o tamanho do vetor em $t1
        
        addi $t0, $zero, 0 #incializa $t0  em 0
        addi $t2, $zero, 4 #incializa $t2  em 4
        
        addi $v0, $zero, 9 # dá malloc de sizeof n * 4
        add $a0, $zero, $t1 #$a0 = n;
        mult $a0, $t2 # $a0 *= 4;
        mflo $a0 # $a0 = $a0 * 4

        syscall
        
        or $t3, $zero, $v0 # guarda o endereco d0 vetor em $t3
        or $s0, $zero, $t3 # usa $s0 como auxiliar para andar na memoria
        addi $s3, $zero, 4

       loop1:
            beq $t0, $t1 fim_loop1
            # else
            addi $v0, $zero, 5
            syscall
            sw $v0, 0($s0) 
            add $s0, $t3, $s3
            addi $s3, $s3, 4
            addi $t0, $t0, 1 #incrementa $t0
        j loop1

        fim_loop1:

        or $a0, $zero, $t3
        or $a1, $zero, $t1
        jal bble_sort
        or $t3, $zero, $a0
        or $t1, $zero, $a1

        addi $t0, $zero, 0 #incializa $t0  em 1
        or $s0, $zero, $t3 # usa $s0 como auxiliar para andar na memoria
        addi $s3, $zero, 4

        addi $v0, $zero, 4 
        la $a0, str_res
        syscall

        loop2:
            beq $t0, $t1 fim_loop2
            # else
            addi $v0, $zero, 1
            lw $a0, 0($s0) 
            syscall
            addi $v0, $zero, 4
            la $a0, str_space
            syscall
            add $s0, $t3, $s3
            addi $s3, $s3, 4
            addi $t0, $t0, 1 #incrementa $t0
        j loop2

        fim_loop2:
            addi $v0, $zero, 10 #sai do programa
            syscall    
        
    bble_sort:
        addi $sp, $sp, -12
        sw $a0, 0($sp) # $a0 = v*;
        sw $a1, 4($sp) # $a1 = n;
        sw $ra, 8($sp)
        
        addi $t4, $zero, 1 #incializa $t4  em 1

        loop3:
            beq $t4, $a1, fim_loop3 # while ($t4 < $a1)
            or $s0, $zero, $a0 # usa $s0 como auxiliar para andar na memoria
            addi $t6, $zero, 0 # j = 0;
            addi $s3, $zero, 4
            sub $t5, $a1, $t4 # $t5 = n-i;
            loop4:
                beq $t6, $t5 fim_loop4 # while $t6 < $t5!
                lw $t7, 0($s0) # $t7 = $a0[j];
                add $s0, $a0, $s3
                addi $s3, $s3, 4
                lw $s1, 0($s0) # $t8 = $a0[j+1];
                blt $s1, $t7 swap # if v[j+1] < v[j];
                    #else
                    addi $t6, $t6, 1 #j++
                j loop4
            fim_loop4:
                addi $t4, $t4, 1 # i++;
            j loop3
            
        swap:
        addi $s3, $s3, -8
        add $s0, $a0, $s3
        sw $s1, 0($s0)
        addi $s3, $s3, 4
        add $s0, $a0, $s3
        sw $t7, 0($s0)
        addi $s3, $s3, 4
        addi $t6, $t6, 1 #j++
        j loop4
        
        fim_loop3:
            lw $ra, 8($sp)
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            addi $sp, $sp, 12
            jr $ra