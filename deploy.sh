#!/bin/bash
#Bash script for a smarter and simpler deployment of all necessary Nextcloud stuff to OS

if [[ $# -lt 1 ]]; then
	echo "This script needs at least one argument to run, please run deploy.sh -h|--help to see the help screen for more information on usage."
	exit 2
fi
#Run over all command line arguments passed to the script
for i in "$@"
do
case $i in
    -n=*|--namespace=*)
    NAMESPACE="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--server=*)
    HOST="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--token=*)
    TOKEN="${i#*=}"
    shift # past argument=value
    ;;
    -h|--help)
    HELP=1
    echo "This script pulls and deploys CRs from GitHub to OpenShift.
Usage:
	-n --namespace    Define the namespace/project you're deploying to
	-s --server 	  Define the path to the OS API
	-t --token 	  Define the access token for the API
        -f --fast         Use previously defined arguments, best if doing a quick update
			  for a resource or something along those lines
Server and token values can be copied straight from the Copy Login Command page on OS"
    shift
    ;;
    -f|--fast)
    FAST=1
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
if [ ${HOST:+1} ]
then
	echo api_path: $HOST >> cr_list
fi
if [ ${TOKEN:+1} ]
then
	echo token: $TOKEN >> cr_list
fi

#Get all the CR files we have
echo paths: >> cr_list
for file in crs/*.yml; do
	$(echo " - path: $(realpath $file)" >> cr_list)
done
for file in crs/*.yaml; do
        $(echo " - path: $(realpath $file)" >> cr_list)
done

#Everything is done, we can run the playbook
ansible-playbook deploy.yml
