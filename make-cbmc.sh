#!/bin/bash

set -e
set -x

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=`dirname "$SCRIPT"`
cd $SCRIPTPATH

jar cf cbmc.jar model-checkers
mvn deploy:deploy-file -Durl=file://$SCRIPTPATH/repo/ -Dfile=cbmc.jar -DgroupId=model-checkers -DartifactId=cbmc -Dpackaging=jar -Dversion=4.6.3