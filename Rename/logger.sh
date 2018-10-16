#!/bin/sh

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
}