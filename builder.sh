# Define device (change if necessary)
DEVICE=${1:-c2s}

# Update repos
sudo apt update

# Install dependencies
sudo apt update && sudo apt install -yq attr bc bison build-essential python3-pip 7zip brotli patchelf openjdk-21-jdk ccache clang curl ffmpeg flex g++ g++-aarch64-linux-gnu gcc-aarch64-linux-gnu curl git git-lfs gnupg gperf imagemagick kmod lld lib32readline-dev lib32z1-dev libbrotli-dev libbz2-dev libgtest-dev liblz4-dev liblz4-tool libncurses5-dev libpcre2-dev libprotobuf-dev libssl-dev libunwind-dev libxml2 libxml2-utils libzstd-dev linux-modules-extra-$(uname -r) libsdl1.2-dev lzop pngcrush protobuf-compiler python-is-python3 rsync schedtool squashfs-tools webp wget xsltproc zip zlib1g-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
wget https://raw.githubusercontent.com/kdrag0n/kramflash/refs/heads/master/mkbootimg.py && sudo ln -sf $(pwd)/mkbootimg.py /usr/bin/mkbootimg && chmod +x /usr/bin/mkbootimg
sudo modprobe erofs f2fs
pip3 install gdown

# setup git account
git config --global user.name miguelbarretoo

# setup email
git config --global user.email miguel03barreto@gmail.com

# Clone source
git clone https://github.com/At30c/UN1CA_y2slte.git -b seventeen --recurse-submodules

# Remove sudo references:
cd UN1CA_y2slte
sed -i '/if ! sudo -n -v &> \/dev\/null; then/,/^        fi$/d' scripts/extract_fw.sh
sed -i '/if ! sudo -n -v &> \/dev\/null; then/,/^fi$/d' platform/exynos990/patches/tethering_legacy/customize.sh
sed -i '/if ! sudo -n -v &> \/dev\/null && ! sudo -v; then/,/^    fi$/d' platform/exynos990/patches/__desixtification/customize.sh

# Download S24+ OneUI 9.0 FW
mkdir -p out/odin
cd out/odin
gdown https://drive.google.com/uc\?id\=15e1YEeJezpgHIQWFOIYFr_PL28rjhMPG
unzip S24+_ONEUI9.0.zip
rm S24+_ONEUI9.0.zip
cd ../..

# Initialize build enviroment
source buildenv.sh $DEVICE

# Start build
./scripts/make_rom.sh
