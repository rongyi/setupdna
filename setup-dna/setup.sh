#!/bin/bash

DNA=./dnaNode
CONFIG=./config.json

if [ ! -f $DNA ]; then
        echo "$DNA not exist"
fi
if [ ! -f $CONFIG ]; then
        echo "$CONFIG not exist"
fi

# create did
# 1 here is the default passwd, change 1 to the passwd you want
out=`$DNA account add --did -d -w did.dat <<EOF
1
1
EOF`

did=`echo $out | awk '{for (i=1; i<NF; i++) print $i}' | grep 'did:dna:'`
sed "s/^.*admin_ont_id.*$/\"admin_ont_id\":\"$did\",/" $CONFIG > $CONFIG.tmp

# create wallets
for i in {1..7}
do
mkdir node$i
# 1 here is the default passwd, change 1 to the passwd you want
out=`$DNA account add -d -w node$i/wallet.dat <<EOF
1
1
EOF`
address=`echo $out | awk '{for (i=1; i<NF; i++) print $i}' | grep "^Address" | awk -F: '{print $2}'`
pubkey=`echo $out | awk '{for (i=1; i<NF; i++) print $i}' | grep "^key" | awk -F: '{print $2}'`
sed "s/^.*\"index\":$i.*$/\"index\":$i,\"peerPubkey\":\"$pubkey\",\"address\":\"$address\",\"initPos\":10000/" $CONFIG.tmp > $CONFIG.tmp2
mv $CONFIG.tmp2 $CONFIG.tmp
done

# update config
for i in {1..7}
do
cp $CONFIG.tmp node$i/config.json
cp $DNA node$i/dnaNode
done

mkdir adminDID
mv did.dat adminDID
mv $CONFIG.tmp adminDID/config.json

