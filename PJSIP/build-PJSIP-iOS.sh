#!/bin/sh

#export OPENSSL_DIR='/Users/admin/Documents/WRK/OpenSSL'
export CFLAGS='-miphoneos-version-min=7.0'
export LDFLAGS='-miphoneos-version-min=7.0'
export XC_BASE=`xcode-select --print-path`

rm -rf ./lib/*
mkdir ./lib/armv7
mkdir ./lib/armv7s
mkdir ./lib/arm64
mkdir ./lib/i386
mkdir ./lib/x86_64

export ARCH='-arch armv7'
make realclean
./configure-iphone --with-ssl="${OPENSSL_DIR}"
make realclean depend all
find ./ -name '*.a' -type f | grep -v '^\.\/\/lib' | xargs -J ^ mv ^ ./lib/armv7/

export ARCH='-arch armv7s'
make realclean
./configure-iphone --with-ssl="${OPENSSL_DIR}"
make realclean depend all
find ./ -name '*.a' -type f | grep -v '^\.\/\/lib' | xargs -J ^ mv ^ ./lib/armv7s/

export ARCH='-arch arm64'
make realclean
./configure-iphone --with-ssl="${OPENSSL_DIR}"
make realclean depend all
find ./ -name '*.a' -type f | grep -v '^\.\/\/lib' | xargs -J ^ mv ^ ./lib/arm64/

export DEVPATH="${XC_BASE}/Platforms/iPhoneSimulator.platform/Developer"

export ARCH='-arch i386'
make realclean
./configure-iphone --with-ssl="${OPENSSL_DIR}"
make realclean depend all
find ./ -name '*.a' -type f | grep -v '^\.\/\/lib' | xargs -J ^ mv ^ ./lib/i386/

export ARCH='-arch x86_64'
make realclean
./configure-iphone --with-ssl="${OPENSSL_DIR}"
make realclean depend all
find ./ -name '*.a' -type f | grep -v '^\.\/\/lib' | xargs -J ^ mv ^ ./lib/x86_64/

cd ./lib/arm64
ls -1| sed -e 's/^\(\(.*\)-arm64-apple-darwin_ios\.a\)/\1 \2.a/' | xargs -n2 mv
cd ../armv7
ls -1| sed -e 's/^\(\(.*\)-armv7-apple-darwin_ios\.a\)/\1 \2.a/' | xargs -n2 mv
cd ../armv7s
ls -1| sed -e 's/^\(\(.*\)-armv7s-apple-darwin_ios\.a\)/\1 \2.a/' | xargs -n2 mv
cd ../i386
ls -1| sed -e 's/^\(\(.*\)-i386-apple-darwin_ios\.a\)/\1 \2.a/' | xargs -n2 mv
cd ../x86_64
ls -1| sed -e 's/^\(\(.*\)-x86_64-apple-darwin_ios\.a\)/\1 \2.a/' | xargs -n2 mv
cd ../
ls -1 arm64/|xargs -n1 -R -1 -I ^ echo x86_64/^ i386/^ arm64/^ armv7/^ armv7s/^ -create -output ^ |xargs -L1 xcrun lipo

cd ../

