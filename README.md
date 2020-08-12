# Nextcloud deployment files
OpenShift resource files for the deployment of Nextcloud and necessary services together with a simple deployment script.

## Usage

Simply clone this repository to your machine and run `deploy.sh`.
To use the `deploy.sh` script make sure you give it execution permissions as necessary on your system.

Usage:
        -n --namespace    Define the namespace/project you're deploying to
        -s --server       Define the path to the OS API
        -t --token        Define the access token for the API
        -f --fast         Use previously defined arguments, best if doing a quick update
                          for a resource or something along those lines

Namespace, server and token should __all be passed to the script__ or else it won't work.
Server and token values can be copied and pasted straight from the Copy Login Command page on OS

Script needs to be run with at least one argument. 

Namespace is created if it doesn't exist and doesn't change if it's there already. 

All CRs found in the /crs/ folder are treated like you're running `oc apply -f` so the script can be used to update resources as well by using the `-f | --fast` switch.

User running the script should have the cluster-admin role because project creation otherwise fails. Workaround is removing the first task from the deploy.yml playbook and creating the project manually.
