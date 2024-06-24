Docs


//compile
nasm -f bin bootloader.asm -o bootloader.bin

//compile to img
mkisofs -o bootloader.img -boot-load-size 4 -eltorito-boot -boot-info-table bootloader.bin

//Create a blank floppy image
dd if=/dev/zero of=bootloader.img bs=1440k count=1

// Copy your bootloader code to the first sector
dd if=bootloader.bin of=bootloader.img bs=512 count=1 conv=notrunc

//Boot img file
qemu-system-x86_64 -drive file=bootloader.img,index=0 -boot d


