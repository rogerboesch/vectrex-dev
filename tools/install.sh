#
# Use user path to avoid permission issues
# 
export DESTDIR="$HOME"
export PATH="$HOME/usr/bin:$HOME/usr/local/bin:$PATH"
#
# Download & install lwtools
#
curl -O http://www.lwtools.ca/releases/lwtools/lwtools-4.17.tar.gz
tar zxvf lwtools-4.17.tar.gz
cd lwtools-4.17
make
make install
cd ..
#
# Download & install gcc6809 style version used by Classics Coder
#
curl -O https://raw.githubusercontent.com/rogerboesch/vectrex-dev/master/tools/cmoc-classics-coder.tar.gz
tar zxvf cmoc-classics-coder.tar.gz
cd cmoc-classics-coder
#
# Standard version
#
#curl -O http://perso.b2b2c.ca/~sarrazip/dev/cmoc-0.1.67.tar.gz
#tar zxvf cmoc-0.1.67.tar.gz
#cd cmoc-0.1.67
#
./autogen.sh
./configure --prefix="$HOME/usr"
make
make install
cd ..
cd ..
