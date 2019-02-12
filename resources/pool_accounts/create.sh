#!/bin/bash

URL_RESOURCES="https://raw.githubusercontent.com/stfc/grid-workernode/pool_accounts/resources/pool_accounts"
URL_GROUPS="$URL_RESOURCES/groups.tsv"
URL_USERS="$URL_RESOURCES/users.tsv"

echo "Creating pool account groups from $URL_GROUPS"
curl -s "$URL_GROUPS" | while IFS=$'\t' read gid groupname; do
    groupadd --gid "$gid" "$groupname"
done

echo "Creating pool account users from $URL_USERS"
curl -s "$URL_USERS" | while IFS=$'\t' read uid username gid description homedir shell; do
    mkdir -p "$(dirname "$homedir")"
    adduser --uid "$uid" --gid "$gid" --comment "$description" --home "$homedir" --shell "$shell" "$username"
done
