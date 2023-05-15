#!/bin/bash


while getopts n:i:t:v:b: flag; do
  case "${flag}" in
  t) TARGET_BLOCK=$OPTARG ;;
  b) BINARYNAME=$OPTARG ;;
  s) SERVICE=$OPTARG ;;
  u) UPDATEDBINARY=$OPTARG ;;
  i) INSTALLPATH=$OPTARG ;;
  *) echo "WARN: unknown parameter: ${OPTARG}"
  esac
done


echo -e "Your Celestia node will be upgraded on block height $TARGET_BLOCK"
sleep 1
echo ""


for (( ; ; )); do
  height=$($BINARYNAME status 2>&1 | jq -r .SyncInfo.latest_block_height)
  if ((height >= TARGET_BLOCK)); then
    sleep 5s
    sudo systemctl stop $SERVICE
    sudo rm $INSTALLPATH
    sudo cp $UPDATEDBINARY $INSTALLPATH
    sudo chmod +x $INSTALLPATH 

    sudo systemctl start $SERVICE

    echo "Your node was upgraded successfully"
    sleep 1
    $BINARYNAME version --long 
    break
  else
    sudo echo -e "Current block height: $height"
  fi
  sleep 5
done