; ==============================================
; Calculator Program
; This program performs basic arithmetic operations
; (+, -, *, /) on two 16-bit numbers
; ==============================================

; ========== MEMORY MODEL & STACK ==========
.model small      ; Small memory model (code+data <= 64KB)
.stack 100h       ; Define stack size (256 bytes)

; ========== DATA SECTION ==========
.data
    ; Prompt messages
    msg1 db 'Enter first number: $'
    msg2 db 0Dh, 0Ah, 'Enter second number: $'
    msg3 db 0Dh, 0Ah, 'Choose operation (+ - * /): $'
    msg4 db 0Dh, 0Ah, 'Result: $'
    
    ; Error messages
    msg_div0 db 0Dh, 0Ah, 'Error: Division by zero!$'
    msg_invalid db 0Dh, 0Ah, 'Error: Invalid operation!$'
    
    ; Variables for numbers and result
    num1 dw ?        ; First number storage
    num2 dw ?        ; Second number storage
    result dw ?      ; Calculation result storage
    
    ; Input buffer (max 5 digits + null terminator)
    buffer db 6 dup('$') 

; ========== CODE SECTION ==========
.code
main proc
    ; Initialize data segment
    mov ax, @data    ; Load data segment address
    mov ds, ax       ; Set DS to point to data segment

    ; ===== FIRST NUMBER INPUT =====
    ; Display prompt for first number
    lea dx, msg1     ; Load address of msg1
    call print_msg    ; Display the message
    
    ; Read first number
    lea di, buffer   ; Point DI to input buffer
    call read_number  ; Read number string from user
    call string_to_int ; Convert string to integer
    mov num1, ax     ; Store first number

    ; ===== SECOND NUMBER INPUT =====
    ; Display prompt for second number
    lea dx, msg2     ; Load address of msg2
    call print_msg    ; Display the message
    
    ; Read second number
    lea di, buffer   ; Point DI to input buffer
    call read_number  ; Read number string from user
    call string_to_int ; Convert string to integer
    mov num2, ax     ; Store second number

    ; ===== OPERATION SELECTION =====
    ; Display operation prompt
    lea dx, msg3     ; Load address of msg3
    call print_msg    ; Display the message
    
    ; Read operation character
    call read_char    ; Read single character
    mov cl, al       ; Store operation in CL

    ; ===== PERFORM CALCULATION =====
    ; Prepare numbers for calculation
    mov ax, num1     ; Load first number
    mov bx, num2     ; Load second number

    ; Determine which operation to perform
    cmp cl, '+'      ; Check for addition
    je do_add
    cmp cl, '-'      ; Check for subtraction
    je do_sub
    cmp cl, '*'      ; Check for multiplication
    je do_mul
    cmp cl, '/'      ; Check for division
    je do_div
    
    ; Invalid operation handler
    lea dx, msg_invalid ; Load invalid operation message
    call print_msg      ; Display error
    jmp exit           ; Exit program

; ===== ARITHMETIC OPERATIONS =====
do_add:
    add ax, bx        ; Add the two numbers
    jmp store_result  ; Store and display result

do_sub:
    sub ax, bx        ; Subtract BX from AX
    jmp store_result  ; Store and display result

do_mul:
    imul bx           ; Signed multiply AX by BX (result in DX:AX)
    jmp store_result  ; Store and display result

do_div:
    cmp bx, 0         ; Check for division by zero
    je div_error      ; Handle division by zero
    cwd               ; Convert word to doubleword (sign extend AX into DX)
    idiv bx           ; Signed divide DX:AX by BX (quotient in AX)
    jmp store_result  ; Store and display result

div_error:
    lea dx, msg_div0  ; Load division by zero message
    call print_msg    ; Display error
    jmp exit          ; Exit program

; ===== RESULT HANDLING =====
store_result:
    mov result, ax    ; Store calculation result
    call show_result  ; Display the result
    jmp exit          ; Exit program

; ========== SUBROUTINES ==========

; === PRINT MESSAGE ===
; Input: DX = address of message to print
print_msg proc
    mov ah, 09h      ; DOS function for string output
    int 21h          ; Call DOS interrupt
    ret              ; Return to caller
print_msg endp

; === READ NUMBER STRING ===
; Input: DI = address of input buffer
; Output: Buffer filled with user input
read_number proc
    xor cx, cx       ; Clear character counter
    
    .next_digit:
        call read_char    ; Read a character
        cmp al, 0Dh      ; Check for Enter key
        je .done_read    ; If Enter, finish reading
        cmp al, '0'      ; Validate digit is 0-9
        jb .next_digit
        cmp al, '9'
        ja .next_digit
        mov [di], al     ; Store digit in buffer
        inc di           ; Move to next buffer position
        inc cx           ; Increment character count
        cmp cx, 5        ; Check if we've reached max digits
        jb .next_digit   ; If not, read next digit
        
    .done_read:
        mov [di], '$'    ; Null-terminate the string
        ret              ; Return to caller
read_number endp

; === CONVERT STRING TO INTEGER ===
; Input: Buffer contains number string
; Output: AX = converted number
string_to_int proc
    lea si, buffer   ; Point to start of buffer
    xor ax, ax       ; Clear result register
    xor bx, bx       ; Clear temporary register
    mov bx, 10       ; Set base 10 for conversion
    
    .next_char:
        mov cl, [si]     ; Get next character
        cmp cl, '$'      ; Check for string terminator
        je .done_conv    ; If terminator, finish conversion
        sub cl, '0'      ; Convert ASCII to digit value
        imul bx          ; Multiply current result by 10
        add ax, cx       ; Add new digit
        inc si           ; Move to next character
        jmp .next_char   ; Process next character
        
    .done_conv:
        ret              ; Return with result in AX
string_to_int endp

; === READ SINGLE CHARACTER ===
; Output: AL = ASCII character read
read_char proc
    mov ah, 01h      ; DOS function for character input
    int 21h          ; Call DOS interrupt
    ret              ; Return with character in AL
read_char endp

; === DISPLAY RESULT ===
show_result proc
    ; Print newline before result
    mov ah, 02h      ; DOS function for character output
    mov dl, 0Dh      ; Carriage return
    int 21h
    mov dl, 0Ah      ; Line feed
    int 21h
    
    ; Display result message
    lea dx, msg4     ; Load result message
    call print_msg    ; Display it
    
    ; Print the actual number
    mov ax, result   ; Load result value
    call print_number ; Display the number
    ret              ; Return to caller
show_result endp

; === PRINT NUMBER ===
; Input: AX = number to print
print_number proc
    ; Check if number is negative
    test ax, ax      ; Test sign bit
    jns .positive    ; If positive, skip negation
    
    ; Handle negative number
    push ax          ; Save number
    mov dl, '-'      ; Load minus sign
    mov ah, 02h      ; DOS character output
    int 21h          ; Display minus sign
    pop ax           ; Restore number
    neg ax           ; Convert to positive
    
    .positive:
    ; Convert number to string and print
    mov cx, 0        ; Initialize digit counter
    mov bx, 10       ; Set base 10 for conversion
    
    .reverse:
        xor dx, dx    ; Clear DX for division
        div bx        ; Divide AX by 10 (remainder in DX)
        push dx       ; Save digit
        inc cx        ; Increment digit count
        cmp ax, 0     ; Check if quotient is zero
        jne .reverse  ; If not, continue
    
    .print_loop:
        pop dx         ; Get digit from stack
        add dl, '0'    ; Convert to ASCII
        mov ah, 02h    ; DOS character output
        int 21h        ; Display digit
        loop .print_loop ; Repeat for all digits
    ret               ; Return to caller
print_number endp

; === PROGRAM EXIT ===
exit:
    mov ah, 4ch      ; DOS function for program termination
    int 21h          ; Return to DOS

end main             ; End of program with entry point