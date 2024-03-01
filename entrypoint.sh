#!/bin/bash

SOURCE_ROOT=/beanstalk
DESTINATION_ROOT=${GITHUB_WORKSPACE:-/github/workspace}

find /beanstalk
cp -af ${SOURCE_ROOT}/ ${DESTINATION_ROOT}/
echo lalalal
ls -al ${DESTINATION_ROOT}/nginx*
echo ololo

