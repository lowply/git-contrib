#!/bin/bash

version_gt() {
    local a="${1#v}"
    local b="${2#v}"

    IFS='.' read -r a_major a_minor a_patch <<< "$a"
    IFS='.' read -r b_major b_minor b_patch <<< "$b"

    if (( a_major > b_major )); then
        return 0
    elif (( a_major < b_major )); then
        return 1
    fi

    if (( a_minor > b_minor )); then
        return 0
    elif (( a_minor < b_minor )); then
        return 1
    fi

    if (( a_patch > b_patch )); then
        return 0
    fi

    return 1
}

[ -d git.git ] || git clone --bare https://github.com/git/git.git

CURRENT=$(git tag -l | tail -n 1)
[ -z "${CURRENT}" ] && { echo "No current tag"; exit 1; }
echo "Current version: ${CURRENT}"

echo "Fetching tags from git.git"
GIT_DIR=git.git git fetch --tags

echo "Configuring git"
git config --global user.name "Sho Mizutani"
git config --global user.email "lowply@github.com"

GIT_DIR=git.git git tag -l | grep "^v2.*" | grep -v "\-rc.*$" | sort -V | while IFS='' read -r TAG; do
    if version_gt "${TAG}" "${CURRENT}"; then
        echo "Processing tag: ${TAG}"
        ./script/sync.sh "${TAG}"
        break
    fi
done
