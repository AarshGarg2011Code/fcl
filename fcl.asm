; The Faltu Command Line v1
; Made by Aarsh Garg in 2026
; Commands:
;     "helloworld": Prints "Hello World!"
;     "info":       Displays info
;     "exit":       Exits
; Very faltu, only 3 commands...
DEFAULT REL
section .bss
    ; cmd input buffer
    cmd resb 16
section .data
    ; predefined strings
    greeting db "Welcome to FCL v1", 0x0a, "(Faltu Command Line)", 0x0a
    greetLen equ $ - greeting
    authcredit db "Made in 2026 by Aarsh Garg, with NASM for Linux", 0x0a
    acreditLen equ $ - authcredit
    prompt db 0x0a, "[faltu@fcl] $ "
    promptLen equ $ - prompt
    hworld db "Hello World!", 0x0a
    hworldLen equ $ - hworld
    exitline db "Bye bye", 0x0a
    xlineLen equ $ - exitline
    badcmdmsg db "Bad Command", 0x0a
    badcmdLen equ $ - badcmdmsg
    infoline db "This is the Faltu Command Line.", 0x0a, "It is so faltu, you can only make it say Hello World!, display this info or exit. (as of v1)", 0x0a, "The FCL was coded in x64 Assembly with Linux Syscalls, assembled using NASM.", 0x0a, "Go to https://github.com/AarshGarg2011Code/fcl for more.", 0x0a, "Made by Aarsh Garg in 2026.", 0x0a
    infoLen equ $ - infoline
    ; commands
    cmd_hw db "helloworld"
    cmd_hwLen equ $ - cmd_hw
    cmdx db "exit"
    cmdxLen equ $ - cmdx
    cmdinfo db "info"
    cmdinfoLen equ $ - cmdinfo
section .text
    global _start
_start:
    call greet
    call acredit
    jmp cmdline
; greeting
greet:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel greeting]
    mov rdx, greetLen
    syscall
    ret
; credits
acredit:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel authcredit]
    mov rdx, acreditLen
    syscall
    ret
; cmd loop
cmdline:
    ; display prompt
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel prompt]
    mov rdx, promptLen
    syscall
    ; clear cmd input buffer
    mov byte [rel cmd], 0
    ; read user input
    mov rax, 0
    mov rdi, 0
    lea rsi, [rel cmd]
    mov rdx, 16
    syscall
    ; check if input is empty
    cmp rax, 0
    jle exit
    ; remove newline if present
    mov rbx, rax
    dec rbx
    cmp byte [rel cmd + rbx], 10
    jne parse
    mov byte [rel cmd + rbx], 0
parse:
    ; check helloworld
    lea rsi, [rel cmd]
    lea rdi, [rel cmd_hw]
    mov rcx, cmd_hwLen
    repe cmpsb
    je helloworld
    ; check exit
    lea rsi, [rel cmd]
    lea rdi, [rel cmdx]
    mov rcx, cmdxLen
    repe cmpsb
    je exit
    ; check info
    lea rsi, [rel cmd]
    lea rdi, [rel cmdinfo]
    mov rcx, cmdinfoLen
    repe cmpsb
    je info
    jmp badcmd
; hello world
helloworld:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel hworld]
    mov rdx, hworldLen
    syscall
    jmp cmdline
; exit
exit:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel exitline]
    mov rdx, xlineLen
    syscall
    mov rax, 60
    mov rdi, 0
    syscall
info:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel infoline]
    mov rdx, infoLen
    syscall
    jmp cmdline
; bad command
badcmd:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel badcmdmsg]
    mov rdx, badcmdLen
    syscall
    jmp cmdline
