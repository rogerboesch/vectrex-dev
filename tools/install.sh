# 
# Download lwtools
# 
curl -O http://www.lwtools.ca/releases/lwtools/lwtools-4.17.tar.gz
tar zxvf lwtools-4.17.tar.gz
cd lwtools-4-17
make
make install
#
# Download cmoc
#
curl -O http://perso.b2b2c.ca/~sarrazip/dev/cmoc-0.1.67.tar.gz
tar zxvf cmoc-0.1.67.tar.gz
cd cmoc-0.1.67
./autogen.sh
./configure
make
make install
cd ..
cd ..
#
# Compile hello_world.c
#
cd samples
cmoc --vectrex --verbose hello_world.c
