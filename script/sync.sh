#!/bin/bash

#/
#/ Usage:
#/
#/ sync.sh [TAG]
#/

usage() {
    grep '^#/' < ${0} | cut -c4-
    exit 1
}

[ $# -eq 1 ] || usage

TAG=${1}

[ -d git.git ] || git clone --bare https://github.com/git/git.git
[ -d contrib ] && rm -rf contrib

GIT_DIR=git.git GIT_WORK_TREE=git.git git fetch --tags
GIT_DIR=git.git GIT_WORK_TREE=. git checkout ${TAG} -- contrib || exit $?
git add contrib
git commit -m "Import ${TAG}"
git push
git tag -a "${TAG}" -m "Mirror of https://github.com/git/git/tree/${TAG}/contrib"
git push origin --tags
