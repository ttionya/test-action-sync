#!/bin/sh

if [[ -n "${INPUT_SSH_PRIVATE_KEY}" ]]; then
  echo "has private key"
  # mkdir -p ~/.ssh
  # echo "${INPUT_SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
  # chmod 600 ~/.ssh/id_rsa

  # ssh-keyscan github.com > ~/.ssh/known_hosts
  # echo "${INPUT_KNOWN_HOSTS}" > ~/.ssh/known_hosts
  # cat ~/.ssh/known_hosts
  # chmod 644 ~/.ssh/known_hosts
fi

echo "GITHUB_SHA: ${GITHUB_SHA}"
echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_WORKSPACE: ${GITHUB_WORKSPACE}"
echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"
echo "target_repository: ${target_repository}"
echo "target_repository: ${INPUT_TARGET_REPOSITORY}"

echo "pwd"
pwd
echo "ls pwd"
ls -la
echo "ls workspace"
ls -la ${GITHUB_WORKSPACE}

git remote add target ${INPUT_TARGET_REPOSITORY}
git remote -v

ssh -vT git@github.com

if [[ "${GITHUB_EVENT_NAME}" == "push" ]]; then
  git push target "${GITHUB_REF}:${GITHUB_REF}" -f --tags
fi

if [[ "${GITHUB_EVENT_NAME}" == "delete" ]]; then
  echo "delete"
fi
