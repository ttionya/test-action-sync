#!/bin/sh
#
# Delete functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Delete branches and tags that is deleted.
# Arguments:
#     None
# Outputs:
#     remote branches and tags
########################################
function delete_refs() {
    mkdir -p /tmp/

    git ls-remote origin | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/originBranch.txt
    color yellow "originBranch.txt"
    cat /tmp/originBranch.txt

    git ls-remote target | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/targetBranch.txt
    color yellow "targetBranch.txt"
    cat /tmp/targetBranch.txt

    grep -Fvf /tmp/originBranch.txt /tmp/targetBranch.txt | xargs -I {} git push target -f --delete {}
}
