#!/bin/sh
# Fetches the pinned Dynarmic (Azahar fork) with the submodules this project needs
# and applies the local patches.
set -eu
cd "$(dirname "$0")/.."
DYNARMIC_COMMIT=a46601580d5512d324104f985b5f0209dc980ddc
if [ ! -d external/dynarmic ]; then
    git init -q external/dynarmic
    git -C external/dynarmic remote add origin https://github.com/azahar-emu/dynarmic.git
    git -C external/dynarmic fetch -q --depth 1 origin "$DYNARMIC_COMMIT"
    git -C external/dynarmic checkout -q FETCH_HEAD
fi

# The dependency directory may already exist with only some submodules
# populated (for example after an interrupted fetch). Always complete it.
git -C external/dynarmic submodule update -q --init --depth 1 \
    externals/fmt externals/mcl externals/oaknut externals/robin-map \
    externals/xbyak externals/zycore externals/zydis
git -C external/dynarmic/externals/zydis submodule update -q --init --depth 1

# Keep this safe to rerun after a partial dependency setup.
if ! git -C external/dynarmic apply --reverse --check "$PWD/patches/dynarmic-system-instructions.patch" 2>/dev/null; then
    git -C external/dynarmic apply "$PWD/patches/dynarmic-system-instructions.patch"
fi

# JUCE for the plugin (VST3, LV2, standalone). Free use of JUCE 8 is under AGPLv3.
JUCE_TAG=8.0.15
if [ ! -d external/JUCE ]; then
    git clone -q --depth 1 --branch "$JUCE_TAG" https://github.com/juce-framework/JUCE.git external/JUCE
fi
