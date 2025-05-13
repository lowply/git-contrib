# git-contrib

This repository is a mirror of the contrib directory of [git/git](https://github.com/git/git).

To sync from git/git:

```
./script/sync.sh v2.39.0
```

To list git/git versions:

```
GIT_DIR=git.git git fetch --tags
GIT_DIR=git.git git tag -l | grep "^v2." | grep -v "\-rc" | sort -V
```
