;; Initialize the first instance of each table
init_page_tables:
    mov eax, page_directory_pointer_table
    or eax, 0b11                ;present + writable
    mov [level_four_page_map_table], eax

    mov eax, page_directory
    or eax, 0b11                ;present + writable
    mov [page_directory_pointer_table], eax

.map_page_directory:
    mov ecx, 0x200000           ;2MiB
    mul eax
    or eax, 0b10000011          ;present + writable + large
    mov [page_directory + ecx * 8], eax

    inc ecx
    cmp ecx, 512
    jne .map_page_directory

    ret

enable_paging:
    ;; load the level 4 page table into cr3
    mov eax, level_four_page_map_table
    mov cr3, eax

    ;; enable PAE in cr4
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ;; set long mode in EFER MSR
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ;; enable paging in cr0
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret
