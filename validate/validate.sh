#!/bin/bash

source ./pantheon/env.sh > /dev/null 2>&1

echo "----------------------------------------------------------------------"
echo "PTN: validating" 

OUTPUT=$PANTHEON_RUN_DIR/cinema_databases/clover_db/data.csv
GOLD=validate/data/cloverleaf3d_001.cdb/data.csv

PASS=false
if [ -f $OUTPUT ]; then
    if cmp "$OUTPUT" "$GOLD"; then
        PASS=true
    else
        echo "FILES differ:"
        echo "    $OUTPUT"
        echo "    $GOLD"
    fi
else
    echo "FILE: $OUTPUT does not exist"
fi

if $PASS; then
    echo "PTN: PASS"
    echo "----------------------------------------------------------------------"
else
    echo "PTN: FAIL"
    echo "----------------------------------------------------------------------"
    exit 1
fi

