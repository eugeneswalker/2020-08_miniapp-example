#!/bin/bash

source ./pantheon/env.sh

RUN_CLEAN=true

if $RUN_CLEAN; then
    echo "----------------------------------------------------------------------"
    echo "PTN: cleaning results directory ..." 
    echo "----------------------------------------------------------------------"

    rm -rf $PANTHEON_RUN_DIR
    mkdir $PANTHEON_RUN_DIR
    pushd $PANTHEON_RUN_DIR
    ASCENT_HASH=ascent-develop-eekuvldph3nshigea2lfccz6bacbulkc
    cp -rf $PANTHEON_WORKFLOW_DIR/spack/opt/spack/linux-rhel7-power9le/gcc-6.4.0/$ASCENT_HASH/examples/ascent/proxies/cloverleaf3d/* .
    popd
fi

# --------------------------------------------------------------------
# BEGIN: EDIT THIS SECTION
# copy executable and support files to the result directory
#     this step will vary, depending on the application requirements

cp run/submit.sh $PANTHEON_RUN_DIR
# copy new actions file
cp inputs/ascent/ascent_actions.yaml $PANTHEON_RUN_DIR

# END: EDIT THIS SECTION
# --------------------------------------------------------------------

# go to run dir and update the submit script
pushd $PANTHEON_RUN_DIR
sed -i "s/<pantheon_workflow_jid>/${PANTHEON_WORKFLOW_JID}/" submit.sh
sed -i "s#<pantheon_workflow_dir>#${PANTHEON_WORKFLOW_DIR}#" submit.sh
sed -i "s#<pantheon_run_dir>#${PANTHEON_RUN_DIR}#" submit.sh
sed -i "s#<summit_allocation>#${SUMMIT_ALLOCATION}#" submit.sh

# remove existing file
rm -f ascent_actions.json

# submit the job
echo "----------------------------------------------------------------------"
echo "PTN: submitting run ..." 
echo "----------------------------------------------------------------------"
bsub submit.sh
