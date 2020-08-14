#!/bin/bash
#Bash script for a smarter and simpler deployment of all necessary Nextcloud stuff to OS

if [[ $# -lt 1 ]]; then
	echo "This script needs at least one argument to run, please run deploy.sh -h|--help to see the help screen for more information on usage."
	exit 2
fi
FOLDER=crs
#Run over all command line arguments passed to the script
for i in "$@"
do
case $i in
    -c=*|--crs=*)
    FOLDER="${i#*=}"
    shift
    ;;
    -n=*|--namespace=*)
    export NAMESPACE="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--server=*)
    export K8S_AUTH_HOST="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--token=*)
    export K8S_AUTH_API_KEY="${i#*=}"
    shift # past argument=value
    ;;
    -h|--help)
    HELP=1
    echo "This script pulls and deploys CRs from GitHub to OpenShift.
Usage:
	-n --namespace    Define the namespace/project you're deploying to
	-s --server 	  Define the path to the OS API
	-t --token 	  Define the access token for the API
	-c --crs          Point to some othe folder containing CRs, should be
			  full path, not ending in "/"
        -f --fast         Use previously defined arguments, best if doing a 
			  quick update for a resource or something along those
			  lines
	-p --pull	  Pull from base git repo(the one hosting this script)
			  and deploy with previous parameters
	-P --Pull	  Pull from a specified public git repo, acts like -p

Server and token values can be copied straight from the Copy Login Command page
on OpenShift. 

Examples:
./deploy.sh -p -> Update everything and deploy using last defined parameters,
	acts the same as -f after pulling
./deploy.sh -n=my-project -s=api.myserver.com:3342 -t=t0k3n -> set project name
	and access details to allow connecting to your cluster. Run this first."
    shift
    ;;
    -f|--fast)
    FAST=1
    shift
    ;;
    -p|--pull)
    git pull https://github.com/SirTediousOfFoo/nextcloud-deployments.git
    shift
    ;;
    -P=*|--Pull=*)
    git pull "${i#*=}"
    shift
    ;;
    *)
    echo "Unknown parameter $i, use -h or --help for help"   # unknown option
    exit 1
    ;;
esac
done

#Check if user asked for help, show it and die
if [ ${HELP:+1} ]; then
	exit 1
fi

#Check if user used the -f command, run it and die
if [ ${FAST:+1} ]; then
	echo "Running previous deployment"
	#Run the ansible playbook with old values and then bail
	ansible-playbook deploy.yml
	exit 1
fi

#If not running fast mode remake the cr_list file by removing it and printing it back out
rm cr_list

if [ ${NAMESPACE:+1} ]
then
	echo project_name: $NAMESPACE >> cr_list
fi

#Get all the CR files we have
echo paths: >> cr_list
for file in $FOLDER/*.yml; do
	$(echo " - path: $(realpath $file)" >> cr_list)
done
for file in $FOLDER/*.yaml; do
        $(echo " - path: $(realpath $file)" >> cr_list)
done

#Everything is done, we can run the playbook
ansible-playbook deploy.yml
