#!/bin/sh
# Before starting the server, if this is the first time, we need to download the latest version of the blockchain.sq3 file.
# If BLOCKCHAIN_SQ3_URL is not set, we will skip this step.
echo "Checking for blockchain.sq3 file..."
echo "Check that we have BLOCKCHAIN_SQ3_URL vars"
test -n "$BLOCKCHAIN_SQ3_URL"
if [ -n "$BLOCKCHAIN_SQ3_URL" ]; then
    if [ ! -f /diode_server/data_prod/blockchain.sq3 ]; then
        echo "Downloading blockchain.sq3 from $BLOCKCHAIN_SQ3_URL"
        # Download the blockchain.sq3 file from the URL specified in the BLOCKCHAIN_SQ3_URL environment variable using axel
        axel -n 10 -o /diode_server/data_prod/blockchain.sq3 $BLOCKCHAIN_SQ3_URL
    # If the blockchain.sq3 file already exists, we will check if it is the latest version by comparing the file size.
    # If the file size smaller then the snapshot, we will download the latest version of the blockchain.sq3 file.
    else
        echo "Checking blockchain.sq3 file size"
        # Get the file size of the blockchain.sq3 file from the URL specified in the BLOCKCHAIN_SQ3_URL environment variable
        BLOCKCHAIN_SQ3_URL_FILE_SIZE=$(curl -sI $BLOCKCHAIN_SQ3_URL | grep -i Content-Length | awk '{print $2}')
        # Get the file size of the blockchain.sq3 file in the container
        BLOCKCHAIN_SQ3_FILE_SIZE=$(stat -c%s /diode_server/data_prod/blockchain.sq3)
        # If the file size is smaller, we will download the latest version of the blockchain.sq3 file
        if [ "$BLOCKCHAIN_SQ3_URL_FILE_SIZE" -gt "$BLOCKCHAIN_SQ3_FILE_SIZE" ]; then
            echo "Downloading blockchain.sq3 from $BLOCKCHAIN_SQ3_URL"
            axel -n 10 -o /diode_server/data_prod/blockchain.sq3 $BLOCKCHAIN_SQ3_URL
        fi
    fi
fi
# Before starting the server, we will do git fetch and pull to update the latest version of the source code.
echo "Updating source code"
git fetch
git pull
# Start the server using elixir -S mix run --no-halt
echo "Starting server"
elixir -S mix run --no-halt

