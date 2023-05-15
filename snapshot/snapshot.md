# Description

A tool to create snapshots of the Celestia consensus node.

# Requirements

- Celestia consensus node (Do **NOT** use a validator) [Link](https://docs.celestia.org/nodes/consensus-full-node/#setting-up-a-consensus-full-node)
- Domain (optional but recommended)

# Steps

## 1. Consensus node

Install your consensus node and decide whether you want to have pruning and transaction indexing enabled (you need to resync if you want to change this later). In this tutorial we want to use an archive node with transaction indexing. Therefore we change the following in **~/.celestia-app/config/config.toml**

```
#######################################################
###   Transaction Indexer Configuration Options     ###
#######################################################
[tx_index]

# What indexer to use for transactions
#
# The application will set which txs to index. In some cases a node operator will be able
# to decide which txs to index based on configuration set in the application.
#
# Options:
#   1) "null"
#   2) "kv" (default) - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
# 		- When "kv" is chosen "tx.height" and "tx.hash" will always be indexed.
#   3) "psql" - the indexer services backed by PostgreSQL.
# When "kv" or "psql" is chosen "tx.height" and "tx.hash" will always be indexed.
indexer = "kv"

```

and the following in **~/.celestia-app/config/app.toml**

```
# default: the last 362880 states are kept, pruning at 10 block intervals
# nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)
# everything: 2 latest states will be kept; pruning at 10 block intervals.
# custom: allow pruning options to be manually specified through 'pruning-keep-recent', and 'pruning-interval'
pruning = "nothing"

# These are applied if and only if the pruning strategy is custom.
pruning-keep-recent = "0"
pruning-interval = "0"

```

## 2. Install webserver

For this guide [Miniserve](https://github.com/svenstaro/miniserve) will be used as webserver to host the snapshot files.

- Download the right binary from the [release page]([https://](https://github.com/svenstaro/miniserve/releases)) for your system. In my case `miniserve-0.22.0-x86_64-unknown-linux-gnu`
    ```
    cd $HOME
    wget https://github.com/svenstaro/miniserve/releases/download/v0.22.0/miniserve-0.22.0-x86_64-unknown-linux-gnu
    ```
- Make it executable
  ```
  chmod +x miniserve-0.22.0-x86_64-unknown-linux-gnu
  ```
- Create a directory for your snapshots 
  ```
  mkdir ~/snapshots
  ```
- Run and try the webserver 
    ```
    ./miniserve-0.22.0-x86_64-unknown-linux-gnu ~/snapshots -t "Archive node snapshots" -p 8081
    ```
- Check if you can reach it by connecting to http://nodeIP:8081
- Create a systemd service
  ```
  sudo nano /etc/systemd/system/webserver.service
  ```
- Copy, paste and edit **\$USER** and **\$PATH**
    ```
    [Unit]
    Description=Snapshot webserver
    After=network-online.target
    [Service]
    User=$USER
    ExecStart=$PATH/miniserve-0.22.0-x86_64-unknown-linux-gnu ~/snapshots -t "Archive node snapshots" -p 8081
    Restart=on-failure
    RestartSec=3
    LimitNOFILE=4096
    [Install]
    WantedBy=multi-user.target
    ```
- Enable and start service
  ```
  sudo systemctl daemon-reload
  sudo systemctl enable webserver.service
  sudo systemctl start webserver.service
  ```


## 3. Snapshot script

- Download and review the **celestiaSnap.sh** script.
- Edit the following variables inside the script according to your environment 
  ```
  CHAIN_ID="blockspacerace-0"
  SNAP_PATH="/home/celestia/snapshots/celestia"
  LOG_PATH="/home/celestia/snapshots/celestia/celestia_log.txt"
  DATA_PATH="/home/celestia/.celestia-app/data/"
  SERVICE_NAME="celestia-appd.service"
  RPC_ADDRESS="http://localhost:26657"
  ```
- Run the script and check on your webserver if the snapshot and log file appears and are healthy.
  ```
  chmod +x celestiaSnap.sh
  sudo bash celestiaSnap.sh
- Create cronjob for the script.
  ```
  crontab -e      # I prefer nano as editor
  ```
- Paste the following to the end of the file and edit the path:
  ```
  0 0 * * * /bin/bash -c '$PATH/celestiaSnap.sh'
  ```
- The script will now run each day at 00:00.

## 4. Done