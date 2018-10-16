rootfolder="/Users/salesawagner/Desktop/Rename"
folders=$(find $rootfolder -type d)
regex="^[sS]([0-9]{2,})[eE]([0-9]{2,})+$"

declare -a filetypes=("srt" "mkv" "mp4" "avi")
declare -a videotypes=("mkv" "mp4" "avi")
declare -a subtitletypes=("srt")

# Utils - LOGs

logline() {
	echo "-----------------------------------"
}

logaction() {
	action=$1

	echo ""
	logline
	echo "    $action"
	logline

}

logtitle() {
	title=$1
	echo ""
	echo "#################################"
	echo "$title"
	echo "#################################"
	echo ""
}

# Utils -

getfilename() {
	file=$1
	find="$rootfolder/"
	replace=""
	filename=${1//$find/$replace}
	echo "$filename"
}

getseriename() {
	filepath=$1
	filename=$(getfilename $filepath)
	
	for i in $(echo $filename | tr "." "\n"); do
		if [[ $i =~ $regex ]]; then
			episode=$i
			break
		fi
	done
	
	count=0
	for i in $(echo $filename | tr "$episode" "\n"); do
		if (($count==0)); then 
			serie=$i
		fi 
		count=$count+1
	done

	echo "$serie$episode"
}

# Move Files Methods

movefiles() {
	
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

readfilesfrom() {
	folder=$1

	logaction "VIDEOS"
	for filetype in "${videotypes[@]}"; do
		findfilewithtype $filetype
	done
	
	logaction "SUBTITLES"
	for filetype in "${subtitletypes[@]}"; do
		findfilewithtype $filetype
	done
} 

findfilewithtype() {
	type=$1

	logaction "$type files"

	for file in $(find $folder -type f -name \*.$type); do
		movefile $file
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

# Organize Files Methods

renamesubtitle() {
	video=$1
	subtitle=$2
	
	newfile="$video.pt.srt"
	
	echo $video
	echo "Rename $(getfilename $subtitle) to $(getfilename $newfile)"
	
	mv "$subtitle" "$newfile"
}

setupsubtitle() {
	video=$1
	videoname=$(getseriename $video)
	
	for subtitletype in "${subtitletypes[@]}"; do
		for subtitle in $(find $rootfolder -type f -name \*.$subtitletype); do

			subtitlename=$(getseriename $subtitle)

			if [ "$videoname" == "$subtitlename" ]; then
				echo "New match $(getfilename $video) <> $(getfilename $subtitle)"
				renamesubtitle $video $subtitle
			fi
		done
	done
}

organizefiles() {
	logtitle "START ORGANIZE FILES"

	for videotype in "${videotypes[@]}"; do
		for video in $(find $rootfolder -type f -name \*.$videotype); do
			setupsubtitle $video
		done
	done

	logtitle "END ORGANIZE FILES"
}

main() {
	
	clear
	
	logtitle "START PROGRAM"
	movefiles
	organizefiles
	logtitle "END PROGRAM"

	
	# for video in $mkvFiles; do
	# 	preparevideo $video
	#
	# 	for subtitle in $srtFiles; do
	# 		prepareSubtitle $subtitle
	#
	# 		if (($serie == $serieSRT)) &&  (($episode == $episodeSRT)); then
	# 			addPtToSrt $video $subtitle
	# 			echo $serieSRT
	# 			echo $episodeSRT
	# 		fi
	# 	done
	#
	# done
}

main
