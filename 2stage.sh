#----------

preparebuild $LINUX_PKG
make mrproper
make headers_check
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
finishbuild $LINUX_PKG

#----------

preparebuild $MAN-PAGE_PKG
make install $JCPU
finishbuild $MAN-PAGE_PKG

#----------

preparebuild $GLIBC_PKG
DL=$(readelf -l /bin/sh | sed -n 's@.*interpret.*/tools\(.*\)]$@\1@p')
sed -i "s|libs -o|libs -L/usr/lib -Wl,-dynamic-linker=$DL -o|" \
        scripts/test-installation.pl
unset DL
sed -i 's|@BASH@|/bin/bash|' elf/ldd.bash.in
patch -Np1 -i ../glibc-2.12.1-gcc_fix-1.patch
patch -Np1 -i ../glibc-2.12.1-makefile_fix-1.patch
mkdir -v ../glibc-build
cd ../glibc-build
case `uname -m` in
  i?86) echo "CFLAGS += -march=i486 -mtune=native -O3 -pipe" > configparms ;;
esac
../glibc-2.12.1/configure --prefix=/usr \
    --disable-profile --enable-add-ons \
    --enable-kernel=2.6.22.5 --libexecdir=/usr/lib/glibc
make $JCPU
cp -v ../glibc-2.12.1/iconvdata/gconv-modules iconvdata
make -k check 2>&1 | tee glibc-check-log
grep Error glibc-check-log
touch /etc/ld.so.conf
make install

mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

make localedata/install-locales
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tzselect


#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
#----------
