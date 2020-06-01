#!/bin/sh

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

ls

git remote add target ${target_repository}
git remote -v

if [[ "${GITHUB_EVENT_NAME}" == "push" ]]; then
  git push target "${GITHUB_REF}:${GITHUB_REF}" -f --tags
fi

if [[ "${GITHUB_EVENT_NAME}" == "delete" ]]; then
  echo "delete"
fi
