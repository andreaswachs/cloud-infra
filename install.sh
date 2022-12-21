#!/bin/bash

# Check if one argument was supplied
if [ $# -ne 1 ]
then
    echo "Invalid number of arguments, please choose one of the following:"
    echo "folding-at-home"
    echo "wachswork"
    exit 1
fi

# Check if the first argument is empty
if [ -z "$1" ]
then
    echo "No argument supplied, please choose one of the following:"
    echo "folding-at-home"
    echo "wachswork"
    exit 1
fi

# Check if the .env file exists, if so, export the variables
if [ -f .env ]
then
    export $(grep -v '^#' .env | xargs)
fi

# Make a case statement over the first argument, check if it is a valid folder in this directory
case $1 in
    "folding-at-home")
        helm upgrade --install \
            --atomic \
            --wait \
            --timeout 5m \
            --namespace default \
            --set configMaps.passkey=$FAH_PASS_KEY \
            folding-at-home folding-at-home
        ;;
    "wachswork")
        helm upgrade --install \
            --atomic \
            --wait \
            --timeout 5m \
            --namespace default \
            wachswork wachswork
        ;;
    "chatgpt")
        helm upgrade --install \
            --namespace default \
            --atomic \
            --timeout 5m \
            --wait \
            --set "openaiAPIKey=$OPENAI_API_KEY" \
            --set "oauth2.clientId=$OAUTH2_CHATGPT_CLIENT_ID" \
            --set "oauth2.clientSecret=$OAUTH2_CHATGPT_CLIENT_SECRET" \
            --set "oauth2.clientCookie=$OAUTH2_CHATGPT_CLIENT_COOKIE" \
            chatgpt chatgpt
        ;;
    *)
        echo "Invalid argument, please choose one of the following:"
        echo "folding-at-home"
        echo "wachswork"
        echo "chatgpt"
        ;;
esac
