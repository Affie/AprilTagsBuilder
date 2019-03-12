# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "AprilTagsBuilder"
version = v"0.1.0"

# Collection of sources required to build AprilTagsBuilder
sources = [
    "https://github.com/Affie/apriltags.git" =>
    "5480f61216519ad24f211748d6bafe8133adc5ce",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/apriltags
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libapriltag", :libapriltag)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

