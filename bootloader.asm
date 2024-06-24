; --- Combined Bootloader and Kernel ---

section .text

global _start

_start:
    ; --- Bootloader Setup ---
    mov ax, 07C0h       ; Set up 4K stack space after this bootloader
    add ax, 288         ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax         ; ss = stack segment
    mov sp, 4096        ; sp = stack pointer

    mov ax, 07C0h       ; Set data segment 
    mov ds, ax         ; ds = data segment

    ; --- Initialize video mode ---
    mov ah, 00h         ; AH = 0
    mov al, 03h         ; AL = 3 (80x25 text mode)
    int 10h             ; Call BIOS video interrupt

    ; --- Print Welcome Message ---
    mov si, text_string
    call print_string
    call print_nl

    ; --- Print ASCII Cat Art ---
    call print_cat
    call print_nl

    ; --- Print "Hit Enter to Load Kernel" ---
    mov si, enter_msg
    call print_string
    call print_nl

    ; --- Wait for Enter Key ---
    mov ah, 01h         ; BIOS function to read keyboard input
.wait_for_enter:
    int 16h             ; Call BIOS keyboard interrupt
    cmp al, 0x0D       ; Check if the key pressed was Enter (ASCII 0x0D)
    jne .wait_for_enter  ; If not Enter, loop back

    ; --- Kernel Logic (After Enter) ---
    mov ah, 0x0E    ; Set function to print character
    mov al, 'K'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'e'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'r'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'n'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'e'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'l'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, ' '     ; Character to print (space)
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'L'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'o'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'a'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    mov al, 'd'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character
    
    mov al, 'e'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character
    
    mov al, 'd'     ; Character to print
    int 0x10        ; Call BIOS interrupt to print character

    jmp $           ; Infinite loop

; --- Subroutines ---

print_string:
    ; Routine: output string in SI to screen
    mov ah, 0Eh     ; 0Eh = print the character in AL to the screen
.repeat:
    lodsb           ; Load string byte into AL, increment SI
    cmp al, 0       ; Check if end of string
    je .done        ; If null terminator, done
    mov bl, 00h     ; Background color (black)
    int 10h         ; Call BIOS interrupt to print character
    jmp .repeat
.done:
    ret             ; Return from subroutine

print_cat:
    ; Routine: output ASCII art of a cat
    mov si, cat_art    ; Load address of cat art into SI
    call print_nl      ; Print a new line
.loop:
    lodsb           ; Load byte from SI into AL
    test al, al     ; Check if it's null terminator
    jz .done        ; If null, we're done
    mov ah, 0Eh     ; Set attribute (black background, light grey foreground)
    mov bl, 00h     ; Background color (black)
    int 10h         ; Print character
    jmp .loop       ; Repeat until null terminator
.done:
    ret             ; Return from subroutine

print_nl:
    ; Routine: print new line
    mov al, 0x0D       ; Carriage return character
    mov ah, 0x0E       ; Print character function
    int 10h         ; Call BIOS interrupt
    mov al, 0x0A       ; Line feed character
    int 10h         ; Call BIOS interrupt
    ret             ; Return from subroutine

print_num:
    ; Routine: print a number in AL 
    ; This routine only prints single-digit numbers
    add al, '0'     ; Convert number to ASCII character
    mov ah, 0Eh     ; Set attribute for printing
    mov bl, 00h     ; Background color (black)
    int 10h         ; Call BIOS interrupt to print character
    ret             ; Return from subroutine

; --- Data ---
cat_art db '  /\\_/\\', 0x0D, 0x0A ; ASCII art for a cat
         db ' ( o.o )', 0x0D, 0x0A
         db '  > ^ <', 0x0D, 0x0A
         db ' /     \ ', 0x0D, 0x0A
         db 'V__)~(__V', 0x00

text_string db 'Welcome to Bootloader! This bootloader initializes essential system components and prepares the system for loading the operating system.', 0

enter_msg db 'Hit Enter to Load Kernel', 0

times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
dw 0xAA55              ; Boot signature
