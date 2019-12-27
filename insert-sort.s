.data
	input: .skip 100 /* make enough space for 100 words */
	arr: .skip 50

	initial: .asciz "##Insertion Sort##\n\n"
	prompt1: .asciz "Enter a sequence of characters to be sorted(,):\n"
	prompt2: .asciz "Numbers in ascending order:\n"
	spattern1: .asciz "%u"
	spattern2: .asciz "%s"
	spattern3: .asciz ","
	newline: .asciz "\n\n"

.text
	@ r0 = Array address
	@ r1 = Input string
	@ r2 = ...
	extract_string:

		@ r3 = Array address
		@ r4 = Integer creation buffer
		@ r5 = Current input byte
		@ r6 = Array index	
		@ r7 = #10

		mov r3, r0
		mov r4, #0
		mov r6, #0
		mov r7, #10

		extract_loop:
			ldrb r5, [r1], #1

			cmp r5, #','
			beq extract_next
			cmp r5, #0
			beq extract_end

			mul r4, r7, r4
			add r4, r4, r5
			sub r4, r4, #'0'
			b extract_loop
			
		extract_next:	
			str r4, [r3, +r6, LSL #2]
			mov r4, #0
			add r6, r6, #1				
			b extract_loop
	
		extract_end:
			str r4, [r3, +r6, LSL #2]
			add r0, r6, #1				
			bx lr


	@ r0 = Array address
	@ r1 = Array length
	@ r2 = ...
	print_array:

		@ r4 = Array start address
		@ r5 = Array length
		@ r6 = Array index

		push {lr}

		mov r4, r0
		mov r5, r1
		mov r6, #0

		ldr r0, =prompt2
		bl printf

		print_loop:
			ldr r1, [r4, +r6, LSL #2]
			ldr r0, =spattern1
			bl printf

			add r6, r6, #1
			cmp r6, r5
			beq print_end
			ldr r0, =spattern3
			bl printf
			b print_loop

		print_end:
			ldr r0, =newline
			bl printf

			pop {lr}
			bx lr


	@ r0 = Array address
	@ r1 = Array length
	@ r2 = ...
	insertion_sort:

		@ r4 = Array starting address
		@ r5 = Array length
		@ r6 = J
		@ r7 = Key
		@ r8 = I
		@ r9 = A[i]
		@ r10 = i + 1

		mov r4, r0
		mov r5, r1
		mov r6, #1

		insert_loop:
			cmp r5, r6
			beq insert_end
			ldr r7, [r4, +r6, LSL #2]			
			sub r8, r6, #1

			insert_inner_loop:
				cmp r8, #0
				blt insert_inner_end
				ldr r9, [r4, +r8, LSL #2]	
				cmp r9, r7
				ble insert_inner_end
				add r10, r8, #1
				str r9, [r4, +r10, LSL #2]
				sub r8, r8, #1
				b insert_inner_loop

			insert_inner_end:
				add r10, r8, #1
				str r7, [r4, +r10, LSL #2]
				add r6, r6, #1
				b insert_loop
		
		insert_end:
			bx lr


.global main
	main:

		push {lr}
		ldr r0, =initial
		bl printf

		ldr r0, =prompt1
		bl printf

		ldr r0,	=spattern2
		ldr r1, =input
		bl scanf

		ldr r0, =arr
		ldr r1, =input
		bl extract_string
		
		mov r12, r0		/* Need to keep length somewhere */

		ldr r0, =arr
		mov r1, r12
		bl insertion_sort

		ldr r0, =arr
		mov r1, r12
		bl print_array

		pop {lr}
		bx lr

.global printf
.global scanf
