#!/bin/bash

########################################################################
#                                                                      #
# AUTHOR : ANISH TIMSINA                                               #
# DATE	 : 14 jun,2025                                                 #
# VERSION: V1                                                          #
#                                                                      #
# Program to list users with access to read in git                     #
#			                                               #
########################################################################

#GitHub API URL
API_URL="https://api.github.com"

#GitHub Username and Personal access token
USERNAME=$username
TOKEN=$token

#User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

#Function to make the GET request to the GitHub API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	#send a GET request to the GitHub
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list users with read access to the repository

function list_users_read {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	#fetch the list of collaborators with read access
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

	#Display the list of collaborators with read access
	if [[ -z "$collaborators" ]];then
		echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Users with read access found for ${REPO_OWNER}/${REPO_NAME} : "
		echo "$collaborators"
	fi
}

#Main Script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_read
