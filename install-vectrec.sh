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
export INSTALLDIR="$HOME/vectrec"
export PATH="$INSTALLDIR:$PATH"
#
# Detect OS
#
OS="`uname`"
case $OS in
  'Linux')
    OS='linux'
    ;;
  'Darwin') 
    OS='macos'
    ;;
  *) ;;
esac
#
# SHOW  INFO
#
echo ""
echo "IMPORTANT INFORMATION"
echo "Install script is not yet ready for all platforms"
echo "Please use make-vectrec.sh instead to build VectreC from source"
echo ""
echo "Install path: $INSTALLDIR"
echo ""
#
# Choose maCOS
#
if [[ $OS == 'macos' ]]
then
echo "macOS Info"
echo "If you want install for macOS Intel press 'y' now"
echo "Otherwise VectreC for ARM will be installed"
echo ""
read -p "Press 'y' to install the Intel version, for ARM press 'n' " answer
case ${answer:0:1} in
    y|Y )
        OS='macos-intel'
        echo "macOS Intel version will be installed"
    ;;
    * )
        OS='macos-arm'
        echo "macOS ARM version will be installed"
    ;;
esac
fi
#
# Create folder
#
mkdir $INSTALLDIR
#
# ===============================================================================
# BINARIES: Copy all
#
echo
echo "INSTALL VECTREC +++++++++++++++++++++++++++++++++++++++++++++++"
echo
#
# Copy LWTOOLS binaries
#
cp -v vectrec-binaries/$OS/lwar $INSTALLDIR/lwar
cp -v vectrec-binaries/$OS/lwasm $INSTALLDIR/lwasm
cp -v vectrec-binaries/$OS/lwlink $INSTALLDIR/lwlink
cp -v vectrec-binaries/$OS/lwobjdump $INSTALLDIR/lwobjdump
#
# Copy CMOC binary and stdlib
#
cp -v vectrec-binaries/$OS/cmoc $INSTALLDIR/cmoc
cp -v -R vectrec-binaries/$OS/stdlib $INSTALLDIR/stdlib
#
# Copy scripts on macOS
#
if [[ $OS == 'macos-arm' ]]; then
cp -v vectrec-binaries/compile-macos.sh $INSTALLDIR/compile.sh
cp -v vectrec-binaries/start-macos.sh $INSTALLDIR/start.sh
fi
if [[ $OS == 'macos-intel' ]]; then
cp -v vectrec-binaries/compile-macos.sh $INSTALLDIR/compile.sh
cp -v vectrec-binaries/start-macos.sh $INSTALLDIR/start.sh
fi
#
# Copy scripts on linux
#
if [[ $OS == 'linux' ]]; then
cp -v vectrec-binaries/compile-linux.sh $INSTALLDIR/compile.sh
cp -v vectrec-binaries/start-linux.sh $INSTALLDIR/start.sh
fi
chmod a+x $INSTALLDIR/compile.sh
chmod a+x $INSTALLDIR/start.sh
#
# Copy Sample & Tutorial
#
cp -v -R vectrec-sample $INSTALLDIR/sample
cp -v -R tutorial-code $INSTALLDIR/tutorial
#
# Copy emulator binary
#
cp -v vectrec-binaries/$OS/vec2x $INSTALLDIR/vec2x
#
# Copy ROM file
#
mkdir $INSTALLDIR/roms
cp -v vec2x/romfast.bin $INSTALLDIR/roms/romfast.bin
cp -v vec2x/empty.png $INSTALLDIR/roms/empty.png
#
# ===============================================================================
# Finished
#
echo ""
echo "*** VectreC installed ***"
echo ""
