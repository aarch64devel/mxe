cd ~
echo "Install any necessary libraries (Ubuntu/apt)"
echo "sudo will be asked for, please put in your password."
echo "Enter yes when asked, unless you see something wrong with the packages you're about to install."
sudo apt update && sudo apt install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libncurses5-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    ninja-build \
    openssl \
    p7zip-full \
    patch \
    perl \
    python2 \
    python-is-python2 \
    python3 \
    python3-pip \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils
echo "Install meson (as sudo)"
sudo pip3 install meson
echo "Clone MXE from my source that way ARM64 is included"
git clone https://github.com/aarch64devel/mxe --depth=1 arm64mxe
echo "cd mxe!"
cd arm64mxe
echo "Download LLVM-MinGW!"
mkdir usr && cd usr && wget https://github.com/aarch64devel/llvm-mingw/releases/download/14.0/aarch64-only-llvm-mingw-linux-x86_64.tar.xz
echo "Extract LLVM-MinGW!"
tar -xf aarch64-only-llvm-mingw-linux-x86_64.tar.xz
cd ..
echo "Adding MXE to your PATH (bash)"
echo "\n" >> ~/.bashrc
echo "export PATH=/home/$USER/arm64mxe/usr/bin"':$PATH' >> ~/.bashrc
echo "Finished!"
