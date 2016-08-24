global start
extern long_mode_boot

section .text
bits 32
start:
    mov esp, stack_top

    ;; verify platform
    call verify_multiboot
    call verify_cpuid
    call verify_long_mode

    call init_page_tables
    call enable_paging

    ;; load the 64-bit GDT
    lgdt [gdt64.pointer]

    ;; update selectors
    mov ax, gdt64.data
    mov ss, ax                  ; stack selector
    mov ds, ax                  ; data selector
    mov es, ax                  ; extra selector

    jmp gdt64.code:long_mode_boot

    mov dword [0xb8000], 0x2f4b2f4f
    hlt

%include "boot/arch/x86_64/src/paging.S"
%include "boot/arch/x86_64/src/error.S"
%include "boot/arch/x86_64/src/tests.S"
%include "boot/arch/x86_64/src/stack.S"
%include "boot/arch/x86_64/src/gdt.S"
