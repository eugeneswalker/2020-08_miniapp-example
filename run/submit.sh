#!/bin/bash

#BSUB -J <pantheon_workflow_jid> 
#BSUB -nnodes 2
#BSUB -P <summit_allocation> 
#BSUB -W 00:30

module load gcc/6.4.0

jsrun -n2 -g1 <pantheon_run_dir>/cloverleaf3d_par
