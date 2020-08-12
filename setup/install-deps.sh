#!/bin/bash -l

# adding comment

source ./pantheon/env.sh

echo "PTN: Establishing Pantheon workflow directory:"
echo $PANTHEON_WORKFLOW_DIR

PANTHEON_SOURCE_ROOT=$PWD

# build serial or parallel
    # serial
# BUILD_FLAGS=""
    # parallel
BUILD_FLAGS="-j"

# these settings allow you to control what gets built ... 
BUILD_CLEAN=false
INSTALL_SPACK=false
INSTALL_ASCENT=true
INSTALL_APP=false

# other variables

# install locations

# commits

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

if $INSTALL_ASCENT; then
    echo "------------------------------------------------------------"
    echo "PTN: building ASCENT ..."
    echo "------------------------------------------------------------"

    # copy spack settings
    cp inputs/spack/spack.yaml $PANTHEON_WORKFLOW_DIR

    pushd $PANTHEON_WORKFLOW_DIR

    if $INSTALL_SPACK; then
        git clone https://github.com/spack/spack 
        pushd spack
        git checkout 6ccc430e8f108d424cc3c9708e700e94ca2ec688
        popd
    fi

    # set up spack and install
    . spack/share/spack/setup-env.sh
    spack -e . concretize -f 2>&1 | tee concretize.log
    spack -e . install --no-cache

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

