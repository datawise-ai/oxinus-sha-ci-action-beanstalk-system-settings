#!/bin/bash

SOURCE_ROOT=/beanstalk
DESTINATION_ROOT=${GITHUB_WORKSPACE:-/github/workspace}

find /beanstalk
cp -af ${SOURCE_ROOT}/.platform ${DESTINATION_ROOT}/
cp -af ${SOURCE_ROOT}/nginx.conf ${DESTINATION_ROOT}/
echo lalalal
ls -al ${DESTINATION_ROOT}/
ls -al ${DESTINATION_ROOT}/nginx*
echo ololo

