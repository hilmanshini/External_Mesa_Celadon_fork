rm -rf build-android-x86_64
cp init/android-x86_64 ~/.local/share/meson/cross/android-x86_64 

export PATH=/tmp/mesa-compiler/bin:$PATH

meson setup build-android-x86_64 \
    --cross-file android-x86_64 \
    -Dplatforms=android \
    -Dplatform-sdk-version=34 \
    -Dandroid-stub=true \
    -Dandroid-libbacktrace=disabled \
    -Degl=enabled \
    -Dgallium-drivers=iris \
    -Dvulkan-drivers= \
    -Dallow-fallback-for=libdrm \
    -Dmesa-clc=system -Dprecomp-compiler=system \
    -Dvideo-codecs=all \
    -Dgallium-va=enabled

meson compile -C build-android-x86_64
