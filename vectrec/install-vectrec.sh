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
# Download & build lwtools
#
curl -O http://www.lwtools.ca/releases/lwtools/lwtools-4.17.tar.gz
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
cd ..
#
# Download & build gcc6809 style version used by VectreC
#
curl -O https://raw.githubusercontent.com/rogerboesch/vectrex-dev/master/tools/cmoc-vectrec.tar.gz
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
cd ..
#
# Download compile script
#
curl -O https://raw.githubusercontent.com/rogerboesch/vectrex-dev/master/tools/compile.sh
chmod a+x compile.sh
#
# Cleanup toolchain
#
cd $INSTALLDIR
rm -R -f lwtools-4.17
rm -f lwtools-4.17.tar.gz
rm -R -f cmoc-vectrec
rm -f cmoc-vectrec.tar.gz
#
# Build emulator
#
cd $INSTALLDIR
git clone https://github.com/rogerboesch/vectreC.git temp
cd temp
rm -rf .git
cmake -Bbuild
cd build
make
cp -R VectreC.app $INSTALLDIR/VectreC.app
#
# Copy ROM file
#
cd ..
cd assets
cd roms
cp romfast.bin $INSTALLDIR/romfast.bin
#
# Cleanup emulator
#
cd $INSTALLDIR
rm -R temp
#
# Finished
#
echo ""
echo "*** VectreC installed ***"
echo ""
