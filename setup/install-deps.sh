#!/bin/bash -l

# adding comment

source ./pantheon/env.sh

echo "PTN: Establishing Pantheon workflow directory:"
echo $PANTHEON_WORKFLOW_DIR

PANTHEON_SOURCE_ROOT=$PWD

# these settings allow you to control what gets built ... 
BUILD_CLEAN=true
INSTALL_SPACK=true
USE_SPACK_CACHE=true
INSTALL_ASCENT=true
INSTALL_APP=false

# commits
SPACK_COMMIT=6ccc430e8f108d424cc3c9708e700e94ca2ec688

# ---------------------------------------------------------------------------
#
# Build things, based on flags set above
#
# ---------------------------------------------------------------------------

START_TIME=$(date +"%r")
echo "------------------------------------------------------------"
echo "PTN: Start time: $START_TIME" 
echo "------------------------------------------------------------"

# if a clean build, remove everything
if $BUILD_CLEAN; then
    echo "------------------------------------------------------------"
    echo "PTN: clean build ..."
    echo "------------------------------------------------------------"

    if [ -d $PANTHEON_WORKFLOW_DIR ]; then
        rm -rf $PANTHEON_WORKFLOW_DIR
    fi
    if [ ! -d $PANTHEONPATH ]; then
        mkdir $PANTHEONPATH
    fi
    mkdir $PANTHEON_WORKFLOW_DIR
    mkdir $PANTHEON_DATA_DIR
    mkdir $PANTHEON_RUN_DIR
fi

if $INSTALL_SPACK; then
    echo "------------------------------------------------------------"
    echo "PTN: installing Spack ..."
    echo "------------------------------------------------------------"

    pushd $PANTHEON_WORKFLOW_DIR
    git clone https://github.com/spack/spack 
    pushd spack
    git checkout $SPACK_COMMIT 
    popd
    popd
fi

if $INSTALL_ASCENT; then
    echo "------------------------------------------------------------"
    echo "PTN: building ASCENT ..."
    echo "------------------------------------------------------------"

    # copy spack settings
    cp inputs/spack/spack.yaml $PANTHEON_WORKFLOW_DIR

    pushd $PANTHEON_WORKFLOW_DIR

    # activate spack and install Ascent
    . spack/share/spack/setup-env.sh
    spack -e . concretize -f 2>&1 | tee concretize.log
    spack mirror add e4s_summit https://cache.e4s.io 
    spack buildcache keys -it
    module load patchelf

    if $USE_SPACK_CACHE; then
        echo "------------------------------------------------------------"
        echo "PTN: using Spack E4S cache ..."
        echo "------------------------------------------------------------"

        time spack -e . install 
    else
        echo "------------------------------------------------------------"
        echo "PTN: not using Spack E4S cache ..."
        echo "------------------------------------------------------------"

        time spack -e . install --no-cache
    fi

    popd
fi

# build the application and parts as needed
if $INSTALL_APP; then
    echo "------------------------------------------------------------"
    echo "PTN: installing app ..."
    echo "------------------------------------------------------------"

    source $PANTHEON_SOURCE_ROOT/setup/install-app.sh
fi

END_TIME=$(date +"%r")
echo "------------------------------------------------------------"
echo "PTN: statistics" 
echo "PTN: start: $START_TIME"
echo "PTN: end  : $END_TIME"
echo "------------------------------------------------------------"

