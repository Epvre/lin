#!/bin/bash
#https://rus-linux.net/nlib.php?name=/MyLDP/BOOKS/LFS-BOOK-6.8-ru/lfs-6.8-ru-chapter02-02.html

DEV=/dev/sda2
DEV_BOOT=/dev/sda1n
USER=kali

export LFS=/mnt/lfs
echo $LFS

#Ch 2.4
#mkfs.vfat $DEV_BOOT
#mkfs.ext3 $DEV
#mkdir -pv $LFS
#mount -v -t ext3 $DEV $LFS

#Ch 3.1
#mkdir $LFS/sources
#chmod -v a+wt $LFS/sources
#cd $LFS/sources
#wget -i wget-list -P $LFS/sources
#pushd $LFS/sources
#  md5sum -c md5sums
#popd

#Ch 4.2
#mkdir -v $LFS/tools
#ln -sv $LFS/tools /

#Ch 4.3
#groupadd $USER
#useradd -s /bin/bash -g $USER -m -k /dev/null $USER
#passwd $USER
#chown -Rv $USER $LFS/tools
#chown -Rv\ $USER $LFS/sources


#Ch 4.4 lfs user only
cd /home/$USER
sudo rm -vR /home/$USER/.bash_profile
cat > /home/$USER/.bash_profile<<EOF
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cd 
sudo rm -vR /home/$USER/.bashrc;
cat > /home/$USER/.bashrc<<EOF
set +h
umask 022
USER=$USER
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export USER LFS LC_ALL LFS_TGT PATH
EOF
echo "LFS=$LFS"
su $USER

#NEW TERMINAL 
source /home/kali/.bash_profile
source /home/kali/.bashrc
echo $LC_ALL


#Packeges
#sudo chown -Rv $USER $LFS/tools/*
#sudo chown -Rv $USER $LFS/sources/*


#UNIVERSAL UNARCHIVE
cd $LFS/sources
#ARCHIVES=$(ls)


for ARCHIVE in $ARCHIVES; do
    if [[ $ARCHIVE == *.tar ]]; then
        tar -xf "$ARCHIVE"
    elif [[ $ARCHIVE == *.tar.gz ]]; then
        tar -xzf "$ARCHIVE"
    elif [[ $ARCHIVE == *.tar.bz2 ]]; then
        tar -xjf "$ARCHIVE"
    elif [[ $ARCHIVE == *.tar.xz ]]; then
        tar -xJf "$ARCHIVE"
    elif [[ $ARCHIVE == *.zip ]]; then
        unzip "$ARCHIVE"
    elif [[ $ARCHIVE == *.rar ]]; then
        unrar x "$ARCHIVE"
    fi
done


cd "$LFS/sources"
#DIRS=$(echo */)
for DIR in $DIRS; do
	NEW_NAME=$(echo "$DIR" | sed 's/\(.*\)-.*$/\1/')
	mv $DIR $NEW_NAME
	echo $DIR
done 


#Ch 5.4. Binutils 1
#cd $LFS/sources/binutils
#./configure \
#    --target=$LFS_TGT --prefix=/tools \
#    --disable-nls --disable-werror
#case $(uname -m) in
#  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
#esac
#make install


#Ch 5.5 GCC 
cd $LFS/sources
sudo mv -fv mpfr gmp mpc $LFS/sources/gcc

cd $LFS/sources/gcc
mkdir -v build
cd build 

$LFS/sources/gcc/configure \
    --target=$LFS_TGT --prefix=/tools \
    --disable-nls --disable-shared --disable-multilib \
    --disable-decimal-float --disable-threads \
    --disable-libmudflap --disable-libssp \
    --disable-libgomp --enable-languages=c \
    --with-gmp-include=$(pwd)/gmp --with-gmp-lib=$(pwd)/gmp/.libs \
    --without-ppl --without-cloog

make -i
make install 
ln -vs libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | \
    sed 's/libgcc/&_eh/'`
exit 
#Ch 6.25 Bison
#cd $LFS/sources/bison
#./configure \
#	--prefix=/usr
#echo '#define YYENABLE_NLS 1' >> $LFS/sources/bison/lib/config.h
#make
#make check
#make install

#Skip some pakages Start 5.6 RETRY
#make mrproper
#make headers_check
#make INSTALL_HDR_PATH=dest headers_install
#cp -rv dest/include/* /tools/include
#sudo emerge -av sys-libs/readline dev-libs/libconfig dev-libs/openssl dev-lang/lua dev-libs/libevent dev-libs/jansson dev-lang/python
