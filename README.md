# Nextcloud deployment files
OpenShift resource files for the deployment of Nextcloud and necessary services together with a simple deployment script.

## Usage

Simply clone this repository to your machine and run `deploy.sh`.
To use the `deploy.sh` script make sure you give it execution permissions as necessary on your system.
Database secret should be additionaly created to suit your needs if using the CRs found here!

Usage:

        -n --namespace    Define the namespace/project you're deploying to
        -s --server       Define the path to the OS API
        -t --token        Define the access token for the API
        -c --crs          Point to some othe folder containing CRs, should be full path, not ending in "/"
        -f --fast         Use previously defined arguments, best if doing a quick update
                          for a resource or something along those lines
        -p --pull         Pull from base git repo(the one hosting this script), acts the
                          same as -f after pulling if no other params specified
        -P --Pull         Pull from a specified public git repo, acts like -p

Examples:
```
Update everything and deploy using last defined parameters, acts the same as -f after pulling:
./deploy.sh -p

Set project name and access details to allow connecting to your cluster. Run this first to set your environment:
./deploy.sh -n=my-project -s=api.myserver.com:3342 -t=t0k3n

Pull stuff from somewhere else:
./deploy.sh --Pull=https://github.com/SomeoneElse/some-repo --namespace=my-project

Use /home/sirtedious/resource_folder as folder to read CRs from instead of the default one:
./deploy.sh --crs=/home/sirtedious/resource_folder -n=petar-projekt --token=t0k3n --server=https://my-server.com:4843
```

Server and token and namespace __have to be passed to the script at least once__ or else it won't work. Keep in mind access tokens do time out after a while so you may need to set this from time to time.
Server and token values can be copied and pasted straight from the Copy Login Command page on OS

Script needs to be run with at least one argument. 

Namespace needs to be created on OpenShift prior to deployment as this was the simplest way to get around the need for different permissions. If you are logged in as a user that has admin priviledges on at least one project/namespace you can use this to deploy to that project.

All CRs found in the /crs/ folder are treated like you're running `oc apply -f` so the script can be used to update resources as well by using the `-f | --fast` switch.
