#!/bin/bash
##############################################################################
# Example command to build the android target.
##############################################################################
# 
# This script shows how one can build a Caffe2 binary for the iOS platform
# using ios-cmake. This is very similar to the android-cmake - see
# build_android.sh for more details.

CAFFE2_ROOT="$( cd "$(dirname "$0")"/.. ; pwd -P)"
echo "Caffe2 codebase root is: $CAFFE2_ROOT"
# We are going to build the target into build_android.
BUILD_ROOT=$CAFFE2_ROOT/build_ios
mkdir -p $BUILD_ROOT
echo "Build Caffe2 ios into: $BUILD_ROOT"

# Build protobuf from third_party so we have a host protoc binary.
echo "Building protoc"
$CAFFE2_ROOT/scripts/build_host_protoc.sh || exit 1

# Now, actually build the android target.
echo "Building caffe2"
cd $BUILD_ROOT

cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=$CAFFE2_ROOT/third_party/ios-cmake/toolchain/iOS.cmake\
    -DCMAKE_INSTALL_PREFIX=../install \
    -DCMAKE_BUILD_TYPE=Release \
    -DIOS_PLATFORM=OS \
    -DUSE_CUDA=OFF \
    -DBUILD_TEST=OFF \
    -DBUILD_BINARY=OFF \
    -DUSE_LMDB=OFF \
    -DUSE_LEVELDB=OFF \
    -DBUILD_PYTHON=OFF \
    -DPROTOBUF_PROTOC_EXECUTABLE=$CAFFE2_ROOT/build_host_protoc/bin/protoc \
    -DCMAKE_VERBOSE_MAKEFILE=1 \
    -DUSE_MPI=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_THREAD_LIBS_INIT=-lpthread \
    -DCMAKE_HAVE_THREADS_LIBRARY=1 \
    -DCMAKE_USE_PTHREADS_INIT=1 \
    || exit 1
make
