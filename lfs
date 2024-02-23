#!/bin/bash
#https://www.linuxfromscratch.org/~thomas/multilib/index.html
#https://www-linuxfromscratch-org.translate.goog/lfs/view/stable/chapter04/creatingminlayout.html?_x_tr_sl=auto&_x_tr_tl=ru&_x_tr_hl=ru

CONFIG_IA32_EMULATION=y
CONFIG_X86_X32=y
#echo 'int main(){}' > dummy.c
#gcc -m32 dummy.c
#./a.out


apt update
apt install yacc
apt install bison
apt install bash 
apt install texi*
apt install bash*

#SHELL=/bin/bash
#chsh -s /bin/bash
#chsh -s /bin/bash root

 

#Check Reqerments
#bash version-check.sh
#END have a problom with sh not a bash

#Create $LFS
export LFS=/mnt/lfs
echo "LFS=$LFS"
#mkfs -v -t ext4 /dev/sda2

mkdir -pv $LFS
mount /dev/sda2 $LFS

#Create Packet List and download all of them
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
#wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
#cp ./md5sums $LFS/sources 
#pushd $LFS/sources
#  md5sum -c md5sums
#popd
chown root:root $LFS/sources/*

#Create enviroment 
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools
mkdir -v $LFS/sources/build

#Group and user creation
#groupadd lfs
#useradd -s /bin/bash -g lfs -m -k /dev/sdb1 lfs
#passwd lfs
#chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools,sources,/sources/*,/sources/build}
#case $(uname -m) in
#  x86_64) chown -v lfs $LFS/lib64 ;;
#esac

[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
#usermod -a -G sudo lfs
#cd /
#chgrp -R lfs:/usr

#Change user
#su 	- lfs


cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF


cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

source ~/.bashrc

#Mount virtual core 7.3
mkdir -pv $LFS/{dev,proc,sys,run}
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
else
  mount -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi
 

#Chroot
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login
    
mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

ln -sv /proc/self/mounts /etc/mtab

cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF


cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester

exec /usr/bin/bash --login

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

#Gettix 
cd $LFS/sources
tar -xvf $LFS/sources/gettext-0.22.tar.xz 	-C ./build
cd $LFS/sources/build/gettext-0.22
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

#Bison
cd $LFS/sources
tar -xvf $LFS/sources/bison-3.8.2.tar.xz	-C ./build
cd $LFS/sources/build/bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install

#Perl
cd $LFS/sources
tar -xvf $LFS/sources/perl-5.38.0.tar.xz	-C ./build
cd $LFS/sources/build/perl-5.38.0
sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Duseshrplib                                \
             -Dprivlib=/usr/lib/perl5/5.38/core_perl     \
             -Darchlib=/usr/lib/perl5/5.38/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.38/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.38/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.38/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.38/vendor_perl
make
make install

#Python
cd $LFS/sources
tar -xvf $LFS/sources/Python-3.11.4.tar.xz	-C ./build
cd $LFS/sources/build/Python-3.11.4 
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
make
make install
#!/bin/bash
#https://www.linuxfromscratch.org/~thomas/multilib/index.html
#https://www-linuxfromscratch-org.translate.goog/lfs/view/stable/chapter04/creatingminlayout.html?_x_tr_sl=auto&_x_tr_tl=ru&_x_tr_hl=ru

 
#1 Binutils
source ~/.bashrc

#cd $LFS/sources
#tar xvf $LFS/sources/binutils-2.41.tar.xz -C ./build
#cd $LFS/sources/build/binutils-2.41

#./configure --prefix=$LFS/tools \
#             --with-sysroot=$LFS \
#             --target=$LFS_TGT   \
#             --disable-nls       \
#             --enable-gprofng=no \
#             --disable-werror            
#make
#make install

#2 Cross GCC
cd $LFS/sources
tar -xvf $LFS/sources/gcc-13.2.0.tar.xz 	-C ./build
tar -xvf $LFS/sources/mpfr-4.2.0.tar.xz 	-C ./build/mpfr
tar -xvf $LFS/sources/gmp-6.3.0.tar.xz 		-C ./build/gmp
tar -xvf $LFS/sources/mpc-1.3.1.tar.gz 		-C ./build/mpc

cd $LFS/sources/build/gcc-13.2.0

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

./configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.38 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++
    
make
make install

