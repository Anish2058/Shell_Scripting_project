#!/bin/bash

########################################################################
#                                                                      #
# AUTHOR : ANISH TIMSINA                                               #
# DATE   : 14 Jun, 2025                                                #
# VERSION: V1                                                          #
#                                                                      #
# Program to list pull requests for a given GitHub repository          #
#                                                                      #
########################################################################

# GitHub API base URL
API_URL="https://api.github.com"

# GitHub credentials (must be set as environment variables or hardcoded - not recommended)
USERNAME=$username
TOKEN=$token

# User and Repository information (passed as arguments)
REPO_OWNER=$1
REPO_NAME=$2

#Function to make a GET request to GitHub API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list pull request
function list_pull_request {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/pulls"

	#fetch the list of pulls request to the repository
	pull_request="$(github_api_get "$endpoint" | jq -r '.[] | "#\(.number): \(.title) [by \(.user.login)]"')" 

	#Display the list
	if [[ -z  "$pull_request" ]]; then
		echo "No open pull request found for ${REPO_OWNER}/${REPO_NAME}."
	else
		echo "Pull Request for ${REPO_OWNER}/${REPO_NAME} : " 
		echo "$pull_request"
	fi
}

function helper {
	expected_cmd_args=2
	if [$# -ne $expected_cmd_args]; then
		echo "Please execute the script with required command-line arguments."
		echo "asd"
	fi
}
#Main Script

helper
echo "Fetching pull requests for ${REPO_OWNER}/${REPO_NAME}..."
list_pull_request
