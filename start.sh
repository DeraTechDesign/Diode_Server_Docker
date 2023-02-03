#!/bin/sh
# Before starting the server, if this is the first time, we need to download the latest version of the blockchain.sq3, CACHE_SQ3_URL and SYNC_SQ3_URL files.
# If BLOCKCHAIN_SQ3_URL, CACHE_SQ3_URL and SYNC_SQ3_URL environment variables are not set, we will skip the download process.
echo "Checking for blockchain.sq3 file..."
echo "Check that we have BLOCKCHAIN_SQ3_URL vars"
test -n "$BLOCKCHAIN_SQ3_URL"
if [ -n "$BLOCKCHAIN_SQ3_URL" ]; then
    if [ ! -f /diode_server/data_prod/blockchain.sq3 ]; then
        echo "Downloading blockchain.sq3 from $BLOCKCHAIN_SQ3_URL"
        # Download the blockchain.sq3 file from the URL specified in the BLOCKCHAIN_SQ3_URL environment variable using axel
        mkdir /diode_server/data_prod
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
echo "Checking for cache.sq3 file..."
echo "Check that we have CACHE_SQ3_URL vars"
test -n "$CACHE_SQ3_URL"
if [ -n "$CACHE_SQ3_URL" ]; then
    if [ ! -f /diode_server/data_prod/cache.sq3 ]; then
        echo "Downloading cache.sq3 from $CACHE_SQ3_URL"
        # Download the cache.sq3 file from the URL specified in the CACHE_SQ3_URL environment variable using axel
        mkdir /diode_server/data_prod
        axel -n 10 -o /diode_server/data_prod/cache.sq3 $CACHE_SQ3_URL
    fi
fi
echo "Checking for sync.sq3 file..."
echo "Check that we have SYNC_SQ3_URL vars"
test -n "$SYNC_SQ3_URL"
if [ -n "$SYNC_SQ3_URL" ]; then
    if [ ! -f /diode_server/data_prod/sync.sq3 ]; then
        echo "Downloading sync.sq3 from $SYNC_SQ3_URL"
        # Download the sync.sq3 file from the URL specified in the SYNC_SQ3_URL environment variable using axel
        mkdir /diode_server/data_prod
        axel -n 10 -o /diode_server/data_prod/sync.sq3 $SYNC_SQ3_URL
    fi
fi

# Before starting the server, we will do git fetch and pull to update the latest version of the source code.
echo "Updating source code"
git fetch
git pull
#compile the source code
echo "Compiling source code"
mix deps.get
mix compile
# Start the server using elixir -S mix run --no-halt
echo "Starting server"
elixir -S mix run --no-halt

