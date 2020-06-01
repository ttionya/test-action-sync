#!/usr/bin/env bash

if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
  mkdir -p ~/.ssh
  echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa
fi

echo "GITHUB_SHA: ${GITHUB_SHA}"
echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_WORKSPACE: ${GITHUB_WORKSPACE}"
echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"
