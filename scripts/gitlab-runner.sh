#!/bin/bash

run() {
  usage
  [ "$1" = '-h' ] || [ "$1" = '-help' ] || [ "$1" = '--help' ] && exit 0
  echo -n "Continue? " && read -r

  CONTAINER_NAME='gitlab-runner'

  docker run -d --name "${CONTAINER_NAME}" --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/"$USER"/.gitlab-runner/config:/etc/gitlab-runner \
    gitlab/gitlab-runner:alpine3.19

  google-chrome https://gitlab.com/groups/ihu-art-portal/-/runners/new 1>&2 2>/dev/null
  echo -n "Runner Registration Token: " && read -r RUNNER_REGISTRATION_TOKEN
  docker exec -it "${CONTAINER_NAME}" gitlab-runner register --token "$RUNNER_REGISTRATION_TOKEN" --url https://gitlab.com --name LocalRunner --executor docker --docker-image alpine:3.19
}

usage() {
  echo '''
  ####################################################
  #     HOW TO SETUP AND REGISTER A LOCAL RUNNER     #
  ####################################################
  1. A browser will pop-up with Gitlab runner registration page.
  2. Add Tags, Description and check Run untagged jobs.
  3. After creating the runner, copy ONLY the token value.
  4. Paste in the token and press enter for rest of the fields accepting the default values.
  '''
}

run "$@"
