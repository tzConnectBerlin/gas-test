#!/bin/sh

ligo compile-contract gas-test.mligo main > gas-test.tz
tezos-client -A tezos.newby.org -P 8732 originate contract gas-test transferring 0 from alice running gas-test.tz --init 0 --burn-cap 0.6 --force
