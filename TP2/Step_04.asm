			org 	$4			; Starts at vector001's address

Vector_001 	dc.l 	Main		; Defines constant 'Main' to the address of vector001

			org 	$500		; Starts Main program from the address $500

Main 		movea.l #STRING,a0	; A0 points to the string.

StrLen		clr.l	d0
loop		add.l	#1,d0		; D0.L + 1 -> D0.L
			tst.b	(a0)+		; Checks for the end of the string
			bne 	loop		; Exit if reached
			dbra	d0,quit		; Otherwise keep looping and counting

quit		illegal				; Stops the program execution

			org 	$550
			
STRING 		dc.b 	"This string is made up of 40 characters.",0
