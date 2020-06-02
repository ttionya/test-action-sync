#!/bin/sh
#
# Push functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Push current branch to remote.
# Arguments:
#     None
########################################
function push_current_branch() {
    git push target "${GITHUB_REF}:${GITHUB_REF}" -f --tags
}

function push_branches() {
    color blue "git branch"
    git branch
    color blue "git branch --all"
    git branch --all

    git fetch --all

    git branch -r --list "origin/*" | grep -v HEAD | xargs -I {} git checkout --track {}

    git push -u target -f --all
    git push -u target -f --tags
}
