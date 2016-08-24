;; setup the stack
section .bss
align 4096
level_four_page_map_table:
    resb 4096
page_directory_pointer_table:
    resb 4096
page_directory:
    resb 4096
page_table:
    resb 4096
stack_bottom:
    resb 64
stack_top:
