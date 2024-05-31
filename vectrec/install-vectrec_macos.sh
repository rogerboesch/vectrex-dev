#
# Install CMOC
# - Parameter $1: Install folder
# 
export INSTALLDIR="$1"
export PATH="$INSTALLDIR:$PATH"
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
cd vectrec
tar zxvf lwtools-4.17.tar.gz
cd lwtools-4.17
make
# Copy binaries to install path
#
cp lwar/lwar $INSTALLDIR/lwar
cp lwasm/lwasm $INSTALLDIR/lwasm
cp lwlink/lwlink $INSTALLDIR/lwlink
cp lwlink/lwobjdump $INSTALLDIR/lwobjdump
#
# ===============================================================================
# CMOC: Build gcc6809 style version used by VectreC
#
echo
echo "INSTALL CMOC +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
git clone https://github.com/rogerboesch/vectrex-dev.git temp
cd temp
rm -rf .git
find . | grep .git | xargs rm -rf
#
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
# SCRIPTS: Copy compile script
#
echo
echo "COPY SCRIPTS +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
cd temp
cd vectrec
cp compile_macos.sh $INSTALLDIR/compile.sh
chmod a+x $INSTALLDIR/compile.sh
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
# Cleanup
#
cd $INSTALLDIR
rm -rfv temp
#
# ===============================================================================
# EMULATOR: Build
#
echo
echo "INSTALL EMULATOR +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd $INSTALLDIR
git clone https://github.com/rogerboesch/vectreC.git temp
cd temp
rm -rf .git
find . | grep .git | xargs rm -rf
#
cmake -Bbuild
cd build
make
cp -R VectreC.app $INSTALLDIR/VectreC.app
#
# ------------------------------------------------------------------------------
# Copy ROM file
#
echo
echo "COPY ROM FILE +++++++++++++++++++++++++++++++++++++++++++++++"
echo
cd ..
cd assets
cd roms
mkdir $INSTALLDIR/roms
cp -v romfast.bin $INSTALLDIR/roms/romfast.bin
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
