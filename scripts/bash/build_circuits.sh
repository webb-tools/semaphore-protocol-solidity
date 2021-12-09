#!/bin/bash

mkdir -p artifacts/circuits/{anchor,bridge,keypair,semaphore,signature,vanchor_2,vanchor_16}

compile () {
    local outdir="$1" circuit="$2" size="$3"
    mkdir -p build/$outdir
    mkdir -p build/$outdir/$size
    echo "$circuits/test/$circuit.circom"
    ~/.cargo/bin/circom --r1cs --wasm --sym \
        -o artifacts/circuits/$outdir \
        circuits/test/$circuit.circom
    echo -e "Done!\n"
}

copy_to_fixtures () {
    local outdir="$1" circuit="$2" size="$3" bridgeType="$4" 
    mkdir -p semaphore-protocol-solidity-fixtures/fixtures/$bridgeType
    mkdir -p semaphore-protocol-solidity-fixtures/fixtures/$bridgeType/$size
    cp artifacts/circuits/$outdir/$circuit.sym semaphore-protocol-solidity-fixtures/fixtures/$bridgeType/$size/$circuit.sym
    cp artifacts/circuits/$outdir/$circuit.r1cs semaphore-protocol-solidity-fixtures/fixtures/$bridgeType/$size/$circuit.r1cs
    cp artifacts/circuits/$outdir/$circuit\_js/$circuit.wasm semaphore-protocol-solidity-fixtures/fixtures/$bridgeType/$size/$circuit.wasm
    cp artifacts/circuits/$outdir/$circuit\_js/witness_calculator.js semaphore-protocol-solidity-fixtures/fixtures/$bridgeType/$size/witness_calculator.js
}

###
# WEBB SEMPAHORES
###
echo "Compiling Webb style Semaphore bridge 2 withdrawal circuit..."
compile semaphore semaphore_bridge_2 2
copy_to_fixtures semaphore semaphore_bridge_2 2 semaphore
