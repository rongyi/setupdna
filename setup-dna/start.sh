#!/bin/bash -x

for i in {1..4}
do
        if [ ! -f node$i/config.json ] || [ ! -f node$i/wallet.dat ]; then
                echo "node$i/config.json or wallet.dat not exist"
                exit
        fi
done

for i in {1..4}
do
cd node$i
port=$((20338+(i-1)*100))
echo 1 | ../dnaNode --config config.json  --enable-consensus --disable-rpc --nodeport $port 1>/dev/null 2>&1 &
cd ..
done

wait

