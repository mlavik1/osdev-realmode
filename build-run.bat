nasm -f bin boot.asm -o boot.bin
nasm -f bin os.asm -o os.bin
copy boot.bin + os.bin mingos.bin
qemu-system-i386 mingos.bin
