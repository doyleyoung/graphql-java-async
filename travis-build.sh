#!/bin/bash
set -ev
BUILD_COMMAND="./gradlew assemble && ./gradlew check"
if [ "${TRAVIS_PULL_REQUEST}" = "false" ] && [ "${TRAVIS_BRANCH}" = "master" ]; then
    echo "Building on master"
    BUILD_COMMAND="./gradlew assemble && ./gradlew check && ./gradlew bintrayUpload -x check --info"
fi
docker create -v /usr/lib/jvm/java-8-openjdk-amd64/jre/lib --name java8-rt java:8 /bin/true
docker run -it --rm --volumes-from java8-rt -v `pwd .`:/build -e JDK8_HOME=/usr/lib/jvm/java-8-openjdk-amd64 -e BINTRAY_USER=$BINTRAY_USER -e BINTRAY_API_KEY=$BINTRAY_API_KEY -w /build openjdk:8u111-jdk bash -c "${BUILD_COMMAND}"
