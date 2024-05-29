#
# Use user path to avoid permission issues
# 
export INSTALLDIR="$HOME/cmoc-test"
export PATH="$INSTALLDIR:$PATH"
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
#
# Finished
#
echo "VectreC installed."
echo ""
#
cd ..
cd ..
