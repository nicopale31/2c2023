section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm

global split_pagos_usuario_asm

extern malloc
extern free
extern strcmp


;########### SECCION DE TEXTO (PROGRAMA)

; uint8_t contar_pagos_aprobados_asm(list_t* pList, char* usuario);
contar_pagos_aprobados_asm:

    push rbp
    mov rbp, rsp

    ; rdi = puntero a lista
    ; rsi puntero a usuario

    push r13 
    push r14 ; alineo pila
    push r15 ; info pago
    push rbx

    xor r13, r13 
    xor r14, r14
    xor r15, r15   
    xor rbx, rbx
    xor rcx, rcx ; rcx lo uso para guardar el valor de ret



    mov r13, rdi ; guardo valor rdi
    mov rbx, rsi ; guardo valor rsi
 
    cmp rdi, 0 ; me fijo si la lista q vino x parametro es vacia
    je final1
    

loop1:

    cmp r13, 0 
    je final1

    mov r14, [r13] ; r14 = actual.data 

    mov r15, [r14] ; r15 = pago actual
    mov r13b, BYTE [r15 + 1] ; 1 es el ofset de aprobado
    
    cmp r13b, 1
    je pagoaprobado

    mov r13, [r13 + 8]
    jmp loop1


pagoaprobado:

    mov rdi, [r15 + 8] ; 8 es el offset de pagador
    mov rsi, rbx ; en rbx esta el pagador del parametro

    push rcx
    sub rsp, 8  ; me aseguro q la pila este alineada antes del call
    call strcmp
    add rsp, 8
    pop rcx

    cmp eax, 0 ; strcmp trabaja con la parte baja de rax
    je incrementar1

    mov r13, [r13 + 8] ; actual = actual.next
    jmp loop1

incrementar1:
    
    inc rcx
    mov r13, [r13 + 8] ; actual = actual.next
    jmp loop1


final1:
    

    mov rax, rcx

    pop rbx
    pop r15
    pop r14
    pop r13

    pop rbp
    ret

; uint8_t contar_pagos_rechazados_asm(list_t* pList, char* usuario);
contar_pagos_rechazados_asm:

    push rbp
    mov rbp, rsp

    ; rdi = puntero a lista
    ; rsi puntero a usuario

    push r13 
    push r14 ; alineo pila
    push r15 ; info pago
    push rbx

    xor r13, r13 
    xor r14, r14
    xor r15, r15   
    xor rbx, rbx
    xor rcx, rcx ; rcx lo uso para guardar el valor de ret


    mov r13, rdi ; guardo valor rdi
    mov rbx, rsi ; guardo valor rsi
 
    cmp rdi, 0 ; me fijo si la lista q vino x parametro es vacia
    je final2
    

loop2:

    cmp r13, 0 
    je final2
    mov r14, [r13] ; r14 = actual.data 
    

    mov r15, [r14] ; r15 = pago actual
    mov r13b, BYTE [r15 + 1] ; 1 es el ofset de aprobado
    
    cmp r13b, 0 ; pagonoaprobado
    je pagonoaprobado

    mov r13, [r13 + 8]
    jmp loop2


pagonoaprobado:

    mov rdi, [r15 + 8] ; 8 es el offset de pagador
    mov rsi, rbx ; en rbx esta el pagador del parametro

    push rcx
    sub rsp, 8
    call strcmp
    add rsp, 8
    pop rcx

    cmp eax, 0 ; strcmp trabaja con la parte baja de rax
    je incrementar1puntob

    mov r13, [r13 + 8] ; actual = actual.next
    jmp loop2

incrementar1puntob:
    
    inc rcx
    mov r13, [r13 + 8] ; actual = actual.next
    jmp loop2


final2:
    

    mov rax, rcx

    pop rbx
    pop r15
    pop r14
    pop r13

    pop rbp
    ret

; pagoSplitted_t* split_pagos_usuario_asm(list_t* pList, char* usuario);
split_pagos_usuario_asm:

