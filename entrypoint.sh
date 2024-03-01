#!/bin/bash

SOURCE_ROOT=/beanstalk
DESTINATION_ROOT=${GITHUB_WORKSPACE:-/github/workspace}

cp -af ${SOURCE_ROOT}/ ${DESTINATION_ROOT}/

