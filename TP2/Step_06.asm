			org 	$4			; Starts at vector001's address

Vector_001 	dc.l 	Main		; Defines constant 'Main' to the address of vector001

			org 	$500		; Starts Main program from the address $500

Main 		movea.l #STRING,a0	; A0 points to the string.

LowerCount	clr.l	d0
loop		tst.b 	(a0)+		; Checks for the end of the string
			beq		quit		; Exit if end of string reached
			cmpi.b	#'a',(a0)	; Compares the current character ASCII with the one of 'a'
			blo 	loop		; If it doesn't fit inside the interval, keep looping
			bhs		inc			; Increases the counter if the current character is a lower character
			cmpi.b	#'z',(a0)	; Compares the current character ASCII with the one of 'z'
			bhi 	loop		; If it doesn't fit inside the interval, keep looping
			bls		inc			; Increases the counter if the current character is a lower character

inc			addq.l	#1,d0		; D0.L + 1 -> D0.L
			bra loop			; Keep looping

quit		illegal				; Stops the program execution

			org 	$550
			
STRING 		dc.b 	"This string contains 29 small letters.",0
