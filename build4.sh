#!/bin/bash
set -e

# 1. Rebuild the host tools (mesa_clc, vtn_bindgen2) against LLVM 21
#    if they don't exist yet (e.g. after /tmp was wiped)
TOOLS_DIR=/work/mesa/mesa-25.2.5/build-native21
if [ ! -x "$TOOLS_DIR/src/compiler/clc/mesa_clc" ]; then
    cd /work/mesa/mesa-25.2.5
    meson setup build-native21 \
        --native-file /work/mesa/native-llvm21.ini \
        --buildtype release \
        -Dplatforms= -Dgallium-drivers= -Dvulkan-drivers= \
        -Dglx=disabled -Degl=disabled -Dgbm=disabled \
        -Dopengl=true -Dgles1=disabled -Dgles2=disabled \
        -Dllvm=enabled -Dmesa-clc=enabled \
        -Dvideo-codecs= -Dbuild-tests=false \
        -Dinstall-mesa-clc=true
    ninja -C build-native21 \
        src/compiler/clc/mesa_clc src/compiler/spirv/vtn_bindgen2
fi

# 2. Install host tools where build.sh expects them
mkdir -p /tmp/mesa-compiler/bin
cp "$TOOLS_DIR/src/compiler/clc/mesa_clc" \
   "$TOOLS_DIR/src/compiler/spirv/vtn_bindgen2" \
   /tmp/mesa-compiler/bin/

# 3. Run the actual build
bash /work/aosp/space/celadon/external-mesa/build.sh
