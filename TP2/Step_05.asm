			org 	$4			; Starts at vector001's address

Vector_001 	dc.l 	Main		; Defines constant 'Main' to the address of vector001

			org 	$500		; Starts Main program from the address $500

Main 		movea.l #STRING,a0	; A0 points to the string.

SpaceCount	clr.l	d0
loop		cmpi.b	#' ',(a0)+	; Compares the current ASCII with the one of a space character
			beq 	inc			; Increases the counter if a space character is detected
			tst.b 	(a0)		; Checks for the end of the string
			beq		quit		; Exit if reached
			bne 	loop		; Otherwise keep looping and counting
			
inc			addq.l	#1,d0		; D0.L + 1 -> D0.L
			bra 	loop		; Keep looping

quit		illegal				; Stops the program execution

			org 	$550
			
STRING 		dc.b 	"This string contains 4 spaces.",0
