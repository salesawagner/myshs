#!/bin/sh

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/logger.sh"

logtitle "START PROGRAM"

rootfolder=""

if [ "$1" != "" ]; then
    rootfolder="$1"
	declare -a videotypes=("mkv" "mp4" "avi")
else
    logaction "!!! Você precisar passar o folder !!!"
fi

logaction "Folder: $rootfolder"

readfilesfrom() {
	folder=$1

	logaction "VIDEOS"
	for filetype in "${videotypes[@]}"; do
		findfilewithtype $filetype
	done	
}

findfilewithtype() {
	type=$1

	logaction "$type files"

	for file in $(find $folder -type f -name \*.$type); do
		if [ ! -f $file ]; then
			movefile $file
		fi
	done
}

movefile() {
	file=$1
	
	echo "moving $file"
	mv "$file" "$rootfolder"
}

removefolder() {
	folder=$1
	logaction "removing folder $folder."
	rm -rf $folder
}

movefiles() {
	folders=$(find $rootfolder -type d)
	logtitle "START MOVE FILES"
	
	for folder in $folders; do 

		if [ "$folder" != "$rootfolder" ]; then
			
			logaction "start read folder $folder"

			readfilesfrom $folder
			removefolder $folder
			
			logaction "end read folder"

		fi

	done
	
	logtitle "END MOVE FILES"
}

movefiles
logtitle "END PROGRAM"