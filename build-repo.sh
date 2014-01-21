#!/bin/bash

set -e
set -x

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=`dirname "$SCRIPT"`
cd $SCRIPTPATH
mkdir -p dependencies
cd dependencies

echo http://cpachecker.sosy-lab.org/CPAchecker-1.2-unix.tar.bz2
wget -c http://cpachecker.sosy-lab.org/CPAchecker-1.2-unix.tar.bz2
tar xfvj CPAchecker-1.2-unix.tar.bz2

cat << EOF > cpachecker-1.2.0.pom
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<modelVersion>4.0.0</modelVersion>
<groupId>org.sosy-lab</groupId>
<artifactId>cpachecker</artifactId>
<version>1.2.0</version>
<dependencies>
EOF

for i in $( ls CPAchecker-1.2-unix/lib/java/runtime/*.jar ); do
	echo Deploying: $i
	filename=$(basename "$i")
	filename="${filename%.*}"
	mvn deploy:deploy-file -Durl=file://$SCRIPTPATH/repo/ -Dfile=$i -DgroupId=org.sosy-lab.dep -DartifactId=$filename -Dpackaging=jar -Dversion=1.2.0
    
	cat <<- EOF >> cpachecker-1.2.0.pom
	<dependency>
	<groupId>org.sosy-lab.dep</groupId>
	<artifactId>$filename</artifactId>
	<version>1.2.0</version>
	</dependency>
	EOF
done
    
cat << EOF >> cpachecker-1.2.0.pom
</dependencies>
</project>
EOF
    
mvn deploy:deploy-file -Durl=file://$SCRIPTPATH/repo/ -Dfile=CPAchecker-1.2-unix/cpachecker.jar -DgroupId=org.sosy-lab -DartifactId=cpachecker -Dpackaging=jar -Dversion=1.2.0 -DpomFile=cpachecker-1.2.0.pom
    
