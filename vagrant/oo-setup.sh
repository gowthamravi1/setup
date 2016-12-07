#!/bin/sh

mkdir -p /home/prana
cd /home/prana

export BUILD_BASE='/home/prana/build'
export OO_HOME='/home/prana'
export GITHUB_URL='https://github.com/prana'

mkdir -p $BUILD_BASE

if [ -d "$BUILD_BASE/dev-tools" ]; then
  echo "doing git pull on dev-tools"
  cd "$BUILD_BASE/dev-tools"
  git pull
else
  echo "doing dev tools git clone"
  cd $BUILD_BASE
  git clone "$GITHUB_URL/dev-tools.git"
fi
sleep 2

cd $OO_HOME

cp $BUILD_BASE/dev-tools/setup-scripts/* .

./prana_build.sh "$@"

if [ $? -ne 0 ]; then
  exit 1;
fi

if [ -z $OO_VALIDATION ]; then
	echo "OO_VALIDATION environment variable has not neen set in the host machine.. Skipping prana Validation"
elif [ $OO_VALIDATION == "false" ]; then
	echo "OO_VALIDATION environment variable is set as false in the host machine.. Skipping prana Validation"
elif [ $OO_VALIDATION == "true" ]; then
	echo "OO_VALIDATION environment variable is set as true in the host machine.. Doing prana Validation"
	./oo_test.rb
fi

now=$(date +"%T")
echo "All done at : $now"
