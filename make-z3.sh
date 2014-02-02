#!/bin/bash

set -e
set -x

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=`dirname "$SCRIPT"`
cd $SCRIPTPATH

jar cf z3.jar smt-solvers
mvn deploy:deploy-file -Durl=file://$SCRIPTPATH/repo/ -Dfile=z3.jar -DgroupId=smt-solvers -DartifactId=z3 -Dpackaging=jar -Dversion=4.3.2