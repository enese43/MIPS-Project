	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

test_neighbor_header: .asciiz "\nPos\toben\tlinks\tunten\trechts\n---\t----\t-----\t-----\t------\n"

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:   
	li $v0, SYS_PUTSTR
	la $a0, test_neighbor_header
	syscall
	
	move $s0, $zero

test_neighbor_loop_position:

	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	move $s1, $zero

test_neighbor_loop_direction:
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	jal neighbor
	
	move $a0, $v0   
	li $v0, SYS_PUTINT
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	addi $s1, $s1, 1
	blt $s1, 4, test_neighbor_loop_direction

	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	addi $s0, $s0, 1
	blt $s0, 64, test_neighbor_loop_position

	li $v0, SYS_EXIT
	syscall

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname: Enes Erdem
	# Nachname: Erdogan
	# Matrikelnummer: 414685
	
	#+ Loesungsabschnitt
	#+ -----------------

neighbor:
        beq $a1, 0, oben           # if statement for every case of direction. if true jumps to that directions function
        beq $a1, 1, links
        beq $a1, 2, unten
        beq $a1, 3, rechts

	jr $ra

links:
        add $t1, $zero, $a0        # stores position is t1
        sll $t1, $t1, 29      
        srl $t1, $t1, 29           # byte shifting so that t1 keeps only the last 3 bytes which show x coordinate
        
        beq $t1, 0, links2 
                 
        subi $v0, $a0, 1
        jr $ra
        
links2:
        addi $v0, $zero, -1        # for the case where x=0, left is empty so write -1      
        jr $ra
        
rechts:
        add $t1, $zero, $a0
        sll $t1, $t1, 29           # byte shifting so that t1 keeps only the last 3 bytes which show x coordinate
        srl $t1, $t1, 29
        
        beq $t1, 7, links2    
          
            
        addi $v0, $a0, 1
        jr $ra
        
rechts2:
        addi $v0, $zero, -1       # for the case where x=7, left is empty so write -1 
        
        jr $ra
        
oben:
        ble $a0, 7, oben2         # check if the first row. If so goes to oben2 to write -1
        
        subi $v0, $a0, 8          # upper neighbor is current posiiton - 8
        jr $ra

oben2: 
        addi $v0, $zero, -1       # -1 case where upper neighbor doesnt exist
        
        jr $ra
        
unten:
        bge $a0, 56, unten2       # check if the last row. If so goes to unten2 to write -1
        
        addi $v0, $a0, 8    
        jr $ra

unten2: 
        addi $v0, $zero, -1       # -1 case where below neighbor doesnt exist
        
        jr $ra