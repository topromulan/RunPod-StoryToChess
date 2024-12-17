#!/usr/bin/env bash

set -e

echo $0

CONTACT_SUPPORT="\nIf necessary, please reinstall the client, or contact support with all this output!"

function errorquit {
	ERRCODE=$?

	set +e
	trap - EXIT

	echo "Error handler: $* -> Exit code $ERRCODE. $CONTACT_SUPPORT"

	exit $ERRCODE
}
trap errorquit EXIT

function cleanquit {
	trap - EXIT
	echo Exiting program. $*
	exit 0
}

ENDPOINT_FILE=dat/endpoint.dat

cd `dirname "$0"` || errorquit Failed to change to install directory. 
[ -d `dirname $ENDPOINT_FILE` ] || errorquit Data directory missing in install. 

ENDPOINT=$(<$ENDPOINT_FILE) || errorquit Unable to read $ENDPOINT_FILE

RW_KEY="$MY_RUNPOD_API_KEY"
RO_KEY="$RW_KEY"

[ -n "$RW_KEY" ] || errorquit Remember to export MY_RUNPOD_API_KEY
[[ "$RW_KEY" =~ ^rpa_[[:alnum:]]{46}$ ]] || errorquit "Bad API KEY"

if [ $# -eq 0 ]; then 
	echo Getting your story: Please type it as long as you want.
	echo Please type it in now, then end file by pressing ^D on a blank line.
	echo To cancel your story, press ^C.
	echo - ---
	story=$(cat)

	echo -e "Your story was as follows:\n\n$story\n\n"

	URL="https://api.runpod.ai/v2/$ENDPOINT/run"
	json=$( curl -sX POST -s "$URL" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $RW_KEY" \
		-d "{\"input\": {\"story\":\"$story\"}}"
	) || errorquit Failure calling API.

	ENTITY_ID=$( echo "$json" | jq -r '.id' ) || errorquit "Failed to parse response JSON."

	echo "Story ID: $ENTITY_ID"
	echo
	echo Now, type this to read your story:
	echo $0 $ENTITY_ID
	echo
	echo If a cold start is IN_QUEUE long, try this:
	echo watch $0 $ENTITY_ID
else
	ENTITY_ID="$1"
	echo Getting story ID $ENTITY_ID
	[ ${#ENTITY_ID} -eq 39 ] || errorquit Invalid Story ID

	URL="https://api.runpod.ai/v2/$ENDPOINT/status/$ENTITY_ID"

	json=$( 
		curl -s "$URL" -H 'Content-Type: application/json' -H "Authorization: Bearer $RO_KEY"
	) || errorquit Failure calling API.

	status=$( echo $json | jq '.status' | tr -d '"' )

	if [ "$status" == "COMPLETED" ]; then
		echo -e "\n   $( echo "$json" | jq -r '.output.output' | sed 's/\\"/"/g' )"
	elif [ "$status" == "IN_QUEUE" ]; then
		echo Still waiting in line for a worker.
	elif [ "$status" == "IN_PROGRESS" ]; then
		echo Working on it now.. try again soon..
	else
		errorquit Unexpected API response status: $status
	fi
fi

echo
cleanquit
