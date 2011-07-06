#!/bin/bash
SOURCEROOT=/root/temp/lfs/sources
BUILDDIRS1=build-s1

exists () {
	local TARGETFOLDER=$1
	local DETECTTARGET=$TARGETFOLDER/$2
	if [ -d $TARGETFOLDER ]; then
		if [ -d $DETECTTARGET ]; then
			return 0
		fi
	fi
	return 1		
}

checkit () {
	if [ $1 -ne 0 ]; then
		echo "failed"
		exit $1
	fi
}

unpackit (){
	local PACKAGENAME="$1"
	if [ "${PACKAGENAME: -6}" == "tar.gz" ]; then
		tar -xzf $PACKAGENAME
		return $?
	fi
	if [ "${PACKAGENAME: -7}" == "tar.bz2" ]; then
		tar -xjf $PACKAGENAME
		return $?
	fi
	return 1
}

preparebuild (){
	local PACKAGENAME="$1"
	local PACKAGEDIR=
	if [ "${PACKAGENAME: -6}" == "tar.gz" ]; then
		local PACKAGEDIR=${PACKAGENAME%.tar.gz}
	fi
	if [ "${PACKAGENAME: -7}" == "tar.bz2" ]; then
		local PACKAGEDIR=${PACKAGENAME%.tar.bz2}
	fi
	if [ "$PACKAGEDIR" == '' ]; then
		echo "$PACKAGENAME is not the standard source package"
		return 1
	fi
	exists $SOURCEROOT/$BUILDDIRS1 $PACKAGEDIR
	if [ $? -eq 0 ]; then
		return 0
	fi
	unpackit $PACKAGENAME
	checkit $?
	cd $PACKAGEDIR
	return $?
}

finishbuild (){
	local PACKAGENAME="$1"
	local PACKAGEDIR=
	if [ "${PACKAGENAME: -6}" == "tar.gz" ]; then
		local PACKAGEDIR=${PACKAGENAME%.tar.gz}
	fi
	if [ "${PACKAGENAME: -7}" == "tar.bz2" ]; then
		local PACKAGEDIR=${PACKAGENAME%.tar.bz2}
	fi
	if [ "$PACKAGEDIR" == '' ]; then
		echo "$PACKAGENAME is not the standard source package"
		return 1
	fi
	cd $SOURCEROOT
	checkit $?
	mv -v $PACKAGEDIR $SOURCEROOT/$BUILDDIRS1
	checkit $?
}
