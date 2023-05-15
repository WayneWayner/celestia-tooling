# Description

This tool will swap your celestia-appd binary on a given block height. This will help you to prepare and schedule autonomous updates.

# How to use

## Prepare your new celestia binary

```
cd $HOME
git clone https://github.com/celestiaorg/celestia-app
git checkout v0.13.2 # or whatever version you want to update to
make build
```

## Get the updater
```
cd $HOME
nano updateBin.sh
```
Review and copy the content of updateBin.sh of this repo inside

Make it executable
```
chmod+x updateBin.sh
```

# Run the updater

```
sudo bash updateBin.sh -t $TARGET_BLOCK -b celestia-appd -s celestia-appd.service -u /home/celestia/celestia-app/build/celestia-appd  -i /home/celestia/go/bin/celestia-appd
```

|  Parameter | Desccription  
|---|---|
|  -t | Target block to perform the update  |
|  -b | Binary name  |
|  -s | Systemd service name |
|  -u | Updated binary  |
|  -i | Install path  |