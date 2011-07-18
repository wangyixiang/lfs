. functions.sh
JCPU=-j2
#----------

preparebuild $TCL_PKG
cd tcl8.5.8
cd unix
./configure --prefix=/tools
make $JCPU
TZ=UTC make test
make install
chmod -v u+w /tools/lib/libtcl8.5.so
make install-private-headers
ln -sv tclsh8.5 /tools/bin/tclsh
cd $SOURCEROOT
mv tcl8.5.8 $BUILDDIRS1

#----------

preparebuild $EXPECT_PKG
patch -Np1 -i ../expect-5.44.1.15-no_tk-1.patch
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools --with-tcl=/tools/lib \
  --with-tclinclude=/tools/include --with-tk=no
make $JCPU
make test
make SCRIPTS="" install
cd $SOURCEROOT
finishbuild $EXPECT_PKG

#----------

preparebuild $DEJAGNU_PKG
patch -Np1 -i ../dejagnu-1.4.4-consolidated-1.patch
./configure --prefix=/tools
make install $JCPU
make check
cd $SOURCEROOT
finishbuild $DEJAGNU_PKG

#----------

preparebuild $NCURSES_PKG
./configure --prefix=/tools --with-shared \
    --without-debug --without-ada --enable-overwrite
make $JCPU
make install
cd $SOURCEROOT
finishbuild $NCURSES_PKG

#----------

preparebuild $BASH_PKG
patch -Np1 -i ../bash-4.1-fixes-2.patch
./configure --prefix=/tools --without-bash-malloc
make $JCPU
make tests
make install
ln -vs bash /tools/bin/sh
cd $SOURCEROOT
finishbuild $BASH_PKG

#----------

preparebuild $BZIP_PKG
make $JCPU
make PREFIX=/tools install
cd $SOURCEROOT
finishbuild $BASH_PKG

#----------

preparebuild $COREUTILS_PKG
./configure --prefix=/tools --enable-install-program=hostname
make $JCPU
make RUN_EXPENSIVE_TESTS=yes check
make install
cp -v src/su /tools/bin/su-tools
cd $SOURCEROOT
finishbuild $COREUTILS_PKG

#----------

preparebuild $DIFFUTILS_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
cd $SOURCEROOT
finishbuild $DIFFUTILS_PKG

#----------

preparebuild $FILE_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
cd $SOURCEROOT
finishbuild $FILE_PKG

#----------

preparebuild $FINDUTILS_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
cd $SOURCEROOT
finishbuild $FINDUTILS_PKG

#----------

preparebuild $GAWK_PKG
checkit $?
./configure --prefix=/tools
checkit $?
make
checkit $?
make check
checkit $?
make install
checkit $?
finishbuild $GAWK_PKG
checkit $?

#----------

preparebuild $GETTEXT_PKG
cd gettext-tools
./configure --prefix=/tools --disable-shared
make -C gnulib-lib $JCPU
make -C src msgfmt $JCPU
cp -v src/msgfmt /tools/bin
finishbuild $GETTEXT_PKG

#----------

preparebuild $GREP_PKG
./configure --prefix=/tools \
    --disable-perl-regexp
make $JCPU
make check
make install
finishbuild $GREP_PKG

#----------

preparebuild $GZIP_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $GZIP_PKG

#----------

preparebuild $M4_PKG
sed -i -e '/"m4.h"/a\
#include <sys/stat.h>' src/path.c
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $M4_PKG

#----------

preparebuild $MAKE_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $MAKE_PKG

#----------

preparebuild $PATCH_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $MAKE_PKG

#----------

preparebuild $PERL_PKG
patch -Np1 -i ../perl-5.12.1-libc-1.patch
sh Configure -des -Dprefix=/tools \
                  -Dstatic_ext='Data/Dumper Fcntl IO'
make $JCPU perl utilities ext/Errno/pm_to_blib 
cp -v perl pod/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.12.1
cp -Rv lib/* /tools/lib/perl5/5.12.1
finishbuild $PERL_PKG

#----------

preparebuild $SED_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $SED_PKG

#----------

preparebuild $TAR_PKG
sed -i /SIGPIPE/d src/tar.c
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $TAR_PKG

#----------

preparebuild $TEXINFO_PKG
./configure --prefix=/tools
make $JCPU
make check
make install
finishbuild $TEXINFO_PKG

#----------

strip --strip-debug /tools/lib/*
strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man}
chown -R root:root $LFS/tools

#----------
#----------
