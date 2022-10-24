			org 	$4

Vector_001 	dc.l 	Main

			org 	$500
			
Main 		move.l	#$000000001,d0
			move.l	#$000000002,d1
			move.l	#$000000003,d2
			move.l	#$000000004,d3
			move.l	#$000000005,d4
			move.l	#$000000006,d5
			move.l	#$000000007,d6
			move.l	#$000000008,d7
			
			add.l 	d4,d0
			addx.l 	d5,d1
			addx.l 	d6,d2
			addx.l 	d7,d3

			illegal
