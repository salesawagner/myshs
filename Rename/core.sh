#!/bin/bash

rootFolder=$(pwd)
folders=$(find $rootFolder -type d)
allFiles=$(find $rootFolder -type f)
regex="^[sS]([0-9]{2,})[eE]([0-9]{2,})+$"

srtFiles=$(find $rootFolder -type f -name \*.srt)
mkvFiles=$(find $rootFolder -type f -name \*.mkv)
mp4Files=$(find $rootFolder -type f -name \*.mp4)
aviFiles=$(find $rootFolder -type f -name \*.avi)

echo "Start -----> $rootFolder"

removeFolders() {
	for folder in */ ; do
	    rm -rf $folder
	done
}

moveSrtFiles() {
	for file in $srtFiles; do 
		mv "$file" "$rootFolder"
	done
}

movemkvFiles() {
	for file in $mkvFiles; do 
		mv "$file" "$rootFolder"
	done
}

movemp4Files() {
	for file in $mp4Files; do 
		mv "$file" "$rootFolder"
	done
}

moveaviFiles() {
	for file in $aviFiles; do 
		mv "$file" "$rootFolder"
	done
}

addPtToSrt() {
	video=$1
	subtitle=$2
	
	newfile="$1.pt.srt"
	
	mv "$subtitle" "$newfile"
}

prepareVideo() {
	
	find="$rootFolder/"
	replace=""
	videoName=${1//$find/$replace}
	
	count=0
	for i in $(echo $videoName | tr "." "\n")
	do

		if (($count==0));
		then serie=$i
		else 
			if [[ $i =~ $regex ]]; 
			then
			    episode=$i
				break
			fi
		fi

		count=$count+1
		
	done
}

prepareSubtitle() {
	
	find="$rootFolder/"
	replace=""
	videoName=${1//$find/$replace}
	
	count=0
	for i in $(echo $videoName | tr "." "\n")
	do

		if (($count==0));
		then serieSRT=$i
		else 
			if [[ $i =~ $regex ]]; 
			then
			    episodeSRT=$i
				break
			fi
		fi

		count=$count+1
		
	done
}

renameSubtitles() {
	for video in $mkvFiles; do 
		prepareVideo $video
		
		for subtitle in $srtFiles; do 
			prepareSubtitle $subtitle
			
			if (($serie == $serieSRT)) &&  (($episode == $episodeSRT)); then 
				addPtToSrt $video $subtitle
				echo $serieSRT
				echo $episodeSRT
			fi
		done
		
	done
}

moveSrtFiles
movemkvFiles
movemp4Files
moveaviFiles

removeFolders

renameSubtitles
