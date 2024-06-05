#
# INSTALL VECTREC
# 
# This script installs already compiled binary files.
# In most cases, this is the easier way, because you don't have to
# install all the developer tools and libraries to build them.
# 
#
# Install CMOC
# - Parameter $1: Install folder
# 
export INSTALLDIR="$1"
export PATH="$INSTALLDIR:$PATH"
#
# Detect OS
#
OS="`uname`"
case $OS in
  'Linux')
    OS='linux'
    echo "Install on Linux"
    ;;
  'Darwin') 
    OS='macos'
    echo "Install on macOS"
    ;;
  *) ;;
esac
#
# END HEER FOR NOW
#
echo ""
echo "IMPORTANT INFORMATION"
echo "Install script is not yet ready for all platforms"
echo "Please use make-vectrec.sh instead to build VectreC from source"
echo ""
exit
#
# Create folder
#
mkdir $INSTALLDIR
cd $INSTALLDIR
#
# ===============================================================================
# CLONE REPO
#
echo
echo "CLONE REPO +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
git clone https://github.com/rogerboesch/vectrex-dev.git temp
cd temp
rm -rf .git
find . | grep .git | xargs rm -rf
#
#
# ===============================================================================
# LWTOOLS: Download & build
#
echo
echo "INSTALL LWTOOLS +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vectrec
tar zxvf lwtools-4.17.tar.gz
cd lwtools-4.17
make
#
# Copy binaries to install path
#
cp lwar/lwar $INSTALLDIR/lwar
cp lwasm/lwasm $INSTALLDIR/lwasm
cp lwlink/lwlink $INSTALLDIR/lwlink
cp lwlink/lwobjdump $INSTALLDIR/lwobjdump
#
# Set path (cmoc needs lwasm)
#
export PATH=$INSTALLDIR:$PATH
#
# ===============================================================================
# CMOC: Build gcc6809 style version used by VectreC
#
echo
echo "INSTALL CMOC +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vectrec
tar zxvf cmoc-vectrec.tar.gz
cd cmoc-vectrec
./autogen.sh
./configure
make
#
# Copy binaries to install path
#
cp src/cmoc $INSTALLDIR/cmoc
cp -R src/stdlib $INSTALLDIR/stdlib
#
# ------------------------------------------------------------------------------
# SCRIPTS: Copy script
#
echo
echo "COPY SCRIPTS +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vectrec
#
# Copy on macOS
#
if [[ $OS == 'macos' ]]; then
cp compile-macos.sh $INSTALLDIR/compile.sh
cp start-macos.sh $INSTALLDIR/start.sh
fi
#
# Copy on linux
#
if [[ $OS == 'linux' ]]; then
cp compile-linux.sh $INSTALLDIR/compile.sh
cp start-linux.sh $INSTALLDIR/start.sh
fi
chmod a+x $INSTALLDIR/compile.sh
chmod a+x $INSTALLDIR/start.sh
#
# ------------------------------------------------------------------------------
# CODE: Copy Sample & Tutorial
#
echo
echo "COPY CODE ++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vectrec
cp -R sample $INSTALLDIR/sample
cd ..
cp -R tutorial-code $INSTALLDIR/tutorial
#
# ===============================================================================
# EMULATOR: Build
#
echo
echo "INSTALL EMULATOR +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vec2x
#
cmake -Bbuild
cd build
make
#
# Copy exe
#
if [[ $OS == 'macos' ]]; then
cp vec2x $INSTALLDIR/vec2x
fi
#
# ------------------------------------------------------------------------------
# Copy ROM file
#
echo
echo "COPY ROM FILE +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vec2x
#
mkdir $INSTALLDIR/roms
cp -v romfast.bin $INSTALLDIR/roms/romfast.bin
cp -v empty.png $INSTALLDIR/roms/empty.png
#
# ===============================================================================
# Cleanup
#
echo
echo "CLEANUP ++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
rm -rfv temp
#
# ===============================================================================
# Finished
#
echo ""
echo "*** VectreC installed ***"
echo ""
