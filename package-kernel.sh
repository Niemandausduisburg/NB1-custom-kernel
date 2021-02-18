#!/bin/sh

#Clean Up
rm -r out/package
# Test for a compiled kernel
if [ ! -f out/arch/arm64/boot/Image.*-dtb ]; then
    echo "Please compile a kernel before attempting to package it!"
    exit 1
fi

# Try to autodetect the device the kernel was built for if it wasn't specified
KVERSION=$(cat out/include/config/kernel.release)
if [ "$KDEVICE" = "" ]; then
    if echo $KVERSION | grep -qi NB1; then
        KDEVICE="NB1"
    fi
fi
if [ "$KNAME" = "" ]; then
    KNAME="nb1-a11-gcc10.2"
fi

# Copy the template config
cp -r package out/package

# Update the variables
echo "Version: $KVERSION" > out/package/version
sed -i "s/{DEVICE}/$KDEVICE/g" out/package/anykernel.sh
sed -i "s/{NAME}/$KNAME/g" out/package/anykernel.sh
sed -i "s/{KVERSION}/$KVERSION/g" out/package/META-INF/com/google/android/update-binary

# Copy the kernel
cp out/arch/arm64/boot/Image.*-dtb out/package

# Package the zip file
mkdir -p out/package
cd out/package
zip -r ../$KVERSION.zip .
cd ../..

# Clean up
rm -r out/package
