# build and install the application

PACKAGE="NYX"
# make a lower case version of the package 
PACKAGEDIR=`echo "$PACKAGE" | awk '{print tolower($0)}'`

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

pushd $PANTHEON_WORKFLOW_DIR

module load gcc/6.4.0
# module load cuda/10.1.168 
    # to match spack build of ascent
module load cuda/10.1.243 
module load cmake/3.14.2
module load hdf5/1.8.18

# Commits
NYX_COMMIT=bd7fe8a9f553b9588ea1f90b37705add05d9fec2
AMREX_COMMIT=a595fc350b7c610799233b46f0f7aa0347d57404

mkdir $PACKAGEDIR 
pushd $PACKAGEDIR

# AMREX
git clone --branch development https://github.com/AMReX-Codes/amrex.git
pushd amrex
git checkout $AMREX_COMMIT
popd

# ASCENT
    # branch 'ascent' no longer in repo
# git clone --branch ascent https://github.com/AMReX-Astro/Nyx.git
git clone https://github.com/AMReX-Astro/Nyx.git
pushd Nyx
git checkout $NYX_COMMIT
popd

pushd Nyx/Exec/LyA

# static build on summit
    # this works
ASCENT_VERSION=0.5.2-pre
ASCENT_INSTALL_DIR=/gpfs/alpine/world-shared/csc340/software/ascent/$ASCENT_VERSION/summit/openmp/gnu/ascent-install

# new spack build 
    # this does not work
# ASCENT=$(spack find -p ascent)
# ASCENT_INSTALL_DIR=${ASCENT##* }

make -j 4 \
        AMREX_HOME=$PANTHEON_WORKFLOW_DIR/$PACKAGEDIR/amrex \
        USE_ASCENT_INSITU=TRUE \
        USE_MPI=TRUE \
        USE_OMP=FALSE \
        ASCENT_HOME=$ASCENT_INSTALL_DIR
popd

popd
popd
