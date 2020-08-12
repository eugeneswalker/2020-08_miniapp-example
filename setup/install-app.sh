# build and install the application

PACKAGE="ECP-PROXY-APPS"
# make a lower case version of the package 
# PACKAGEDIR=`echo "$PACKAGE" | awk '{print tolower($0)}'`

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

cp inputs/spack/spack.yaml $PANTHEON_WORKFLOW_DIR

pushd $PANTHEON_WORKFLOW_DIR

# ASCENT
git clone https://github.com/spack/spack 
pushd spack
git checkout 6ccc430e8f108d424cc3c9708e700e94ca2ec688
popd
. spack/share/spack/setup-env.sh
spack -e . concretize -f 2>&1 | tee concretize.log
spack -e . install --no-cache

popd
