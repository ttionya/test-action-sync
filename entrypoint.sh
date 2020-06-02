#!/bin/sh
#
# Docker entrypoint.sh
# Author: ttionya <git@ttionya.com>

. actions_functions.sh
. actions_push.sh
. actions_delete.sh

TARGET_REPOSITORY=${INPUT_TARGET_REPOSITORY}

#################### Function ####################
########################################
# Check target repository is valid.
# Arguments:
#     None
# Outputs:
#     None / exit
########################################
function check_target_repository() {
    local TARGET_REPOSITORY_HTTP_URL_MATCHED_COUNT=$(echo ${TARGET_REPOSITORY} | grep -cE '^http(s?)://')

    if [[ ${TARGET_REPOSITORY_HTTP_URL_MATCHED_COUNT} -gt 0 ]]; then
        echo "Target repository only support SSH URL."
        exit 1
    fi
}

########################################
# Configure SSH.
# Arguments:
#     None
# Outputs:
#     SSH test message
########################################
function configure_ssh() {
    # configure known_hosts
    local TARGET_REPOSITORY_HOST=$(echo ${TARGET_REPOSITORY} | sed -r 's|(.*@)?(.*):.*|\2|')
    echo "TARGET_REPOSITORY_HOST: ${TARGET_REPOSITORY_HOST}"
    # ~ is /github/home/, not /root/
    mkdir -p /root/.ssh
    ssh-keyscan ${TARGET_REPOSITORY_HOST} > /root/.ssh/known_hosts
    chmod 644 /root/.ssh/known_hosts

    # configure SSH private key
    if [[ -n "${INPUT_SSH_PRIVATE_KEY}" ]]; then
        echo "find SSH private key"

        eval $(ssh-agent -s)
        echo "${INPUT_SSH_PRIVATE_KEY}" | tr -d '\r' | ssh-add - > /dev/null
    fi

    # test SSH connection
    local SSH_TEST_URL=$(echo ${TARGET_REPOSITORY} | awk -F':' '{ print $1 }')
    echo "SSH_TEST_URL: ${SSH_TEST_URL}"
    ssh -T ${SSH_TEST_URL}
}

########################################
# Configure Git remote information.
# Arguments:
#     None
# Outputs:
#     Git remote list
########################################
function configure_git_remote() {
    git remote add target ${TARGET_REPOSITORY}
    git remote -v
}

########################################
# Display some variables.
# Arguments:
#     None
# Outputs:
#     variables value
########################################
function display_variables() {
    color blue "========================================"
    color blue "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"
    color blue "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
    color blue "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
    color blue "GITHUB_SHA: ${GITHUB_SHA}"
    color blue "GITHUB_REF: ${GITHUB_REF}"
    color blue "GITHUB_WORKSPACE: ${GITHUB_WORKSPACE}"

    color blue "TARGET_REPOSITORY: ${TARGET_REPOSITORY}"
    color blue "CURRENT_DIR: $(pwd)"
    color blue "WHOAMI: $(whoami)"
    color blue "========================================"
}

#################### Actions ####################
check_target_repository
configure_ssh
display_variables

configure_git_remote

case "${GITHUB_EVENT_NAME}" in
    push)
        color yellow "=============== PUSH ==============="

        push_current_branch
        ;;
    delete)
        color yellow "=============== DELETE ==============="

        delete_refs
        ;;
    schedule)
        color yellow "=============== SCHEDULE ==============="

        delete_refs
        push_branches
        ;;
    *)
        break
        ;;
esac
