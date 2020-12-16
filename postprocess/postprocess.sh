#!/bin/bash

source ./pantheon/env.sh > /dev/null 2>&1

echo "----------------------------------------------------------------------"
echo "PTN: Post-processing" 
echo "     packaging up cinema database to:" 
echo "     $PANTHEON_DATA_DIR" 

# install cinema viewer
cp -rf inputs/cinema/* $PANTHEON_RUN_DIR/cinema_databases

pushd $PANTHEON_RUN_DIR > /dev/null 2>&1

TARNAME=cinema_databases
tar -czvf ${TARNAME}.tar.gz $TARNAME > /dev/null 2>&1
mv ${TARNAME}.tar.gz $PANTHEON_DATA_DIR

popd > /dev/null 2>&1

echo "----------------------------------------------------------------------"

