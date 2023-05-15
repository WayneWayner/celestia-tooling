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
#Run with tmux to not kill the process and loose the session when closing the window.
tmux
sudo bash updateBin.sh -t 123456789 -b celestia-appd -s celestia-appd.service -u /home/celestia/celestia-app/build/celestia-appd  -i /home/celestia/go/bin/celestia-appd

# Press **CRTL+B** and then **D** to detach from the session
# List sessions
tmux ls
# Open session 0
tmux a -t 0 
```

|  Parameter | Desccription  
|---|---|
|  -t | Target block to perform the update  |
|  -b | Binary name  |
|  -s | Systemd service name |
|  -u | Updated binary  |
|  -i | Install path  |