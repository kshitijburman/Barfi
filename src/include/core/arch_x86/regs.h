#ifndef __REGS_H_
#define __REGS_H_

#define ASSERT(b) ((b) ? (void)0 : panic_assert(__FILE__, __LINE__, #b))

/* This defines what the stack looks like after an ISR was running */
struct regs
{
    unsigned int gs, fs, es, ds;
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;
    unsigned int int_no, err_code;
    unsigned int eip, cs, eflags, useresp, ss;    
};

typedef struct registers
{
   unsigned int ds;                  // Data segment selector
   unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax; // Pushed by pusha.
   unsigned int int_no, err_code;    // Interrupt number and error code (if applicable)
   unsigned int eip, cs, eflags, useresp, ss; // Pushed by the processor automatically.
} __attribute__ ((packed)) registers_t;

typedef registers_t* registers_ptr_t;

#endif
