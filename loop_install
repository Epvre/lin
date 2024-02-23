#!/bin/bash
#serveroid.com/ru/kb/os-iso.html
echo "Installer of your Linux start"

#1 UNIVERSAL FILE LIST SEARCHER
#IN
FOLDER="./"  
FILE_LIST=()
USB=()
IMAGE=()
DEV_ISO=/dev/sdb1

#BODY
ARR=( $(find "./" -type f -name "*.iso" -printf "%f\n" | sed 's/^.\///') )  
#ARR=( $(ls | grep ".iso"))	
for ((i=0; i<${#ARR[@]}; i++)); do
	echo "$((i+1)): ${ARR[i]}"
done

#OUT
FILE_LIST=${ARR[@]}
	
	
#2 UNIVERSAL NUM SELECTOR IN LIST ARRAY
#IN 	


#BODY
while true; do 
echo "Select number of ISO image in range 1 - ${#ARR[@]}" 
read N	
	if [[ ! $N =~ ^[0-9]+$S || ! $N -le ${#ARR[@]} ]]; then 
	continue 
	fi
	 
OUT=${ARR[N-1]} 
echo "Selected ISO image: $OUT. 
Press Enter to continue"
read TMP
	break
done 

#OUT
IMAGE=$OUT
#END


mount -v --mkdir $DEV_ISO /mnt/tmp
cp $IMAGE /mnt/tmp/image.iso
mkdir /mnt/iso_image && mount -o loop /mnt/tmp/image.iso /mnt/iso_image

find /mnt/iso_image/ -iname "*vmlinuz*"
VMLINUZ=/mnt/iso_image/boot/x86_64/vmlinuz-xen

find /mnt/iso_image/ -iname "*initrd*"
INITRD=/mnt/iso_image/boot/x86_64/initrd-xen

echo /etc/grub.d/40_custom<<EOF
menuentry "Open Suse" {
set root=(hd1,0)
loopback loop /image.iso
linux (loop)$VMLINUZ iso-scan/filename=/image.iso console=ttyS0,9600n8 noeject nopromt
--
initrd (loop)$INITRD
}
EOF

update-grub
