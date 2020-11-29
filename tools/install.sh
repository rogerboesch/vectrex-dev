# 
# Download & install lwtools
# 
curl -O http://www.lwtools.ca/releases/lwtools/lwtools-4.17.tar.gz
tar zxvf lwtools-4.17.tar.gz
cd lwtools-4.17
make
make install
#
# Download & install gcc6809 style version used by Classics Coder
#
curl -O https://raw.githubusercontent.com/rogerboesch/vectrex-dev/master/tools/Classics_Coder_for_Vectrex-Latest.tar.gz
tar zxvf cmoc-classics-coder.tar.gz cmoc-classics-coder
cd cmoc-classics-coder
#
# Standard version
#
# curl -O http://perso.b2b2c.ca/~sarrazip/dev/cmoc-0.1.67.tar.gz
# tar zxvf cmoc-0.1.67.tar.gz
# cd cmoc-0.1.67
#
./autogen.sh
./configure
make
make install
cd ..
cd ..
