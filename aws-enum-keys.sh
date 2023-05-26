#!/usr/bin/env bash

# Enumerate AWS IAM users and their access keys

PROFILE="$1"

if [[ -n  PROFILE ]]; then
    PROFILE=--profile=$PROFILE
fi

echo $PROFILE

for user in $(aws iam list-users --output text $PROFILE | awk '{print $NF}'); do
    aws iam list-access-keys --user $user --output text $PROFILE | cat
done


