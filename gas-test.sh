#!/bin/sh

for i in 'SimpleCall 1' 'DeepCall 1' 'RecursiveCall 10' 'RecursiveStructCall 10' \
         'StructCall 10' 'StructManyArgsCall 10' 'LambdaCall 10' \
         'CurryCall 10' 'SelfAddress 10' 'StringComparison "foo"' 'VoidCall'; do
    echo -n $i
    arg=`ligo compile-parameter gas-test.mligo main "$i"`
    tezos-client -A tezos.newby.org -P 8732 transfer 0 from alice to gas-test --arg "$arg" --burn-cap 2 | grep 'Consumed gas';
done
