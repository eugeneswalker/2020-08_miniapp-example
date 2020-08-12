![research](https://pantheonscience.github.io/states/research.png)

# Pantheon ECP in-situ miniapp example workflow

A repository for examples using Ascent, in-situ creation of Cinema
databases, and post-processing analysis. 

## Using this repository

When the workflow is run, the following files will be run in this order:

1. `setup/install-deps.sh`
    - `setup/install-app.sh` (called from the above script)
1. `run/run.sh` (this submits the job)
1. `run/wait_for_completion.sh`
1. `postprocessing/postprocessing.sh`

## Edit these files
| file | what to do |
|------|---------|
|`bootstrap.env` | edit the `SUMMIT_ALLOCATION` variable value to reflect your allocation. |
|`pantheon/pantheon.yaml` | edit this to reflect the information from Pantheon for your workflow. If you do not have Pantheon settings information, you may leave this file unedited. |
|`postprocess/postprocess.sh` | edit this to call your postprocessing scripts, if you have them. |
|`readme.md` | edit the top line to indicate what type of Pantheon pipeline this is. |
|`run/run.sh` | edit this to copy files as needed by the application. |
|`run/submit.sh` | edit this to properly submit your job. |
|`setup/install-deps.sh` | edit to install dependencies |
|`setup/install-app.sh` | edit to install application  |


## DO NOT edit these files

1. `main.workflow`
1. `pantheon/pantheon.env`
