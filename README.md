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
        -p --pull         Pull from base git repo(the one hosting this script), acts the
                          same as -f after pulling
        -P --Pull         Pull from a specified public git repo, acts like -p

Examples:
```
./deploy.sh -p -> Update everything and deploy using last defined parameters, acts the same as -f after pulling
./deploy.sh -n=my-project -s=api.myserver.com:3342 -t=t0k3n -> set project name and access details to allow connecting 
                                                               to your cluster. Run this first to set your environment.
./deploy.sh --Pull=https://github.com/SomeoneElse/some-repo --namespace=my-project
```

Server and token and namespace __have to be passed to the script at least once__ or else it won't work. Keep in mind access tokens do time out after a while so you may need to set this from time to time.
Server and token values can be copied and pasted straight from the Copy Login Command page on OS

Script needs to be run with at least one argument. 

Namespace is created if it doesn't exist and doesn't change if it's there already. 

All CRs found in the /crs/ folder are treated like you're running `oc apply -f` so the script can be used to update resources as well by using the `-f | --fast` switch.

User running the script should have the cluster-admin role because project creation otherwise fails. Workaround is removing the first task from the deploy.yml playbook and creating the project manually.
