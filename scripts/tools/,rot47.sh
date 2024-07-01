#!/bin/bash

while read -r line; do
    tr '\!-~' 'P-~\!-O' <<< "$line"
done
