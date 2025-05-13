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

echo "Checking out the contrib dir from git.git ${TAG}"
GIT_DIR=git.git GIT_WORK_TREE=. git checkout ${TAG} -- contrib || exit $?

CURRENT=$(git tag --sort=-v:refname | head -n 1)

echo "Add, commit, push, tag and push the tag to the repository"
if git diff --quiet contrib; then
    echo "No changes in contrib dir"
    SHA=$(git rev-list -n 1 ${CURRENT})
else
    git add contrib
    git commit -m "Import ${TAG}"
    git push
    # SHA is empty
fi

git tag -a ${TAG} ${SHA} -m "Mirror of https://github.com/git/git/tree/${TAG}/contrib"
git push origin --tags
