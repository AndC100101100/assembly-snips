# on compiling
there are two steps to compiling an assembly program, which is the assmbling and the linking process.
The following examples assume a few things (linux, x86), and we are going to be using the NASM assembler(32bit programs). 

the command we would be using for assembling would be 
```bash
nasm -f elf file.asm
```
this will take our file.asm with our assembly code and produce and object file called `file.o`.

From here, to create an executable file, we need to linke it with, a linker :000. that command to link our object file would be:
```bash
ld -m elf_i386 file.o -o file
```

here, `elf_i386` is the format we want the exec file to be in, `file.o` the path to the object file and `file` the name of the executable we wish to create
