VALUE 		equ 	96			; Defines a constant VALUE
			
			org 	$4			; Starts at vector001's address

Vector_001 	dc.l 	Main		; Defines constant 'Main' to the address of vector001

			org 	$500		; Starts Main program from the address $500

Main 		move.l 	#VALUE,d0	; D0.L -> VALUE

Abs			tst.l	d0			; Updates the Z & N flags according to D0's value
			bpl 	quit		; Branches to the 'quit' label <=> stops the program
			neg.l	d0			; Substracts D0 to 0 <=> 0-D0 = -D0 > 0 since D0 < 0  
			bra quit			; Branches to the 'quit' label <=> stops the program

quit		illegal				; Stops the program execution
