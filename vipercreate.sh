#!/bin/bash

echo "################# START"
echo ""
echo Input module name:
read moduleName
echo ""
echo Input module name:
read authorName

moduleName="$(tr '[:lower:]' '[:upper:]' <<< ${moduleName:0:1})${moduleName:1}"
moduleLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
authorName=$(echo "$authorName" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

function createStoryBoard () {
	file="$moduleName/$moduleName"".storyboard"
	if [ -e $file ]; then
	  echo "File $file already exists!"
	else
	  echo >> $file
	fi
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"11762\" systemVersion=\"16D32\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" colorMatched=\"YES\" initialViewController=\"7lS-Md-dzS\">
    <device id=\"retina4_7\" orientation=\"portrait\">
        <adaptation id=\"fullscreen\"/>
    </device>
    <dependencies>
        <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"11757\"/>
        <capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>
    </dependencies>
    <scenes>
        <!--"$moduleName" View Controller-->
        <scene sceneID=\"UvM-Bt-wIp\">
            <objects>
                <viewController id=\"7lS-Md-dzS\" customClass=\""$moduleName"View\" sceneMemberID=\"viewController\">
                    <layoutGuides>
                        <viewControllerLayoutGuide type=\"top\" id=\"bdK-AK-CdW\"/>
                        <viewControllerLayoutGuide type=\"bottom\" id=\"ej3-LX-LjF\"/>
                    </layoutGuides>
                    <view key=\"view\" contentMode=\"scaleToFill\" id=\"7F6-YC-zcK\">
                        <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"375\" height=\"667\"/>
                        <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>
                        <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dHP-kB-dnb\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>
            </objects>
            <point key=\"canvasLocation\" x=\"-145\" y=\"36\"/>
        </scene>
    </scenes>
</document>
" > $file
}

function createFile () {
	file="$moduleName/$1"
	if [ -e $file ]; then
	  echo "File $file already exists!"
	else
	  echo >> $file
	fi
echo "//
//  $1
//
//
//  Created by $authorName on $date
//  Copyright © 2017 . All rights reserved.
//
" > $file
}

function setupProtocolFile() {
echo "import Foundation

protocol "$moduleName"PresenterInputProtocol: class {}

protocol "$moduleName"PresenterOutputProtocol: class {}

protocol "$moduleName"InteractorInputProtocol: class {}

protocol "$moduleName"InteractorOutputProtocol: class {}

protocol "$moduleName"WireframeProtocol {}" >> "$moduleName/$ProtocolsfileName"
}

function setupInteractor() {
echo "import Foundation

class "$moduleName"Interactor: "$moduleName"InteractorInputProtocol {

	// MARK: Viper Module properties

    weak var output: "$moduleName"InteractorOutputProtocol!

	// MARK: - "$moduleName"InteractorInputProtocol
    
}" >> "$moduleName/$InteractorfileName"
}

function setupPresenter() {
echo "import Foundation

class "$moduleName"Presenter: "$moduleName"PresenterInputProtocol, "$moduleName"InteractorOutputProtocol {

	// MARK: Viper Module properties
	
	weak var view: "$moduleName"PresenterOutputProtocol!
	var wireframe: "$moduleName"WireframeProtocol!
	var interactor: "$moduleName"InteractorInputProtocol!

	// MARK: - "$moduleName"PresenterInputProtocol
	
	// MARK: - "$moduleName"InteractorOutputProtocol
		
}" >> "$moduleName/$PresenterfileName"
}

function setupWireframe() {
echo "import Foundation

class "$moduleName"Wireframe: NSObject, "$moduleName"WireframeProtocol {

	// MARK: - Constants

	private let storyBoardName = \"$moduleName\"
	private let viewIdentifier = \""$moduleName"View\"

	// MARK: Viper Module properties

	weak var view: "$moduleName"View!

	// MARK: Constructor

	override init() {
		super.init()

		self.view = self."$moduleLower"ViewControllerFromStoryoard()
		let presenter = "$moduleName"Presenter()
		let interactor = "$moduleName"Interactor()

		presenter.interactor = interactor
		presenter.wireframe = self
		self.view.presenter = presenter
		presenter.view = self.view
		interactor.output = presenter
	}

	// MARK: Private

	private func "$moduleLower"ViewControllerFromStoryoard() -> "$moduleName"View {
		let storyboard = UIStoryboard(name: self.storyBoardName, bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: self.viewIdentifier) as! "$moduleName"View
        
        return viewController
    }

    // MARK: "$moduleName"WireframeProtocol

}" >> "$moduleName/$WireframefileName"
}

function setupViewFile() {
echo "import Foundation
class "$moduleName"View: UIViewController, "$moduleName"PresenterOutputProtocol {

	// MARK: Viper Module properties

	var presenter: "$moduleName"PresenterInputProtocol!

	// MARK: - Override Methods

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}" >> "$moduleName/$ViewfileName"
}

mkdir $moduleName
date=`date +%m/%d/%y`

ProtocolsfileName="$moduleName""Protocols.swift"
InteractorfileName="$moduleName""Interactor.swift"
PresenterfileName="$moduleName""Presenter.swift"
WireframefileName="$moduleName""Wireframe.swift"
ViewfileName="$moduleName""View.swift"

createStoryBoard

createFile $ProtocolsfileName
createFile $InteractorfileName
createFile $PresenterfileName
createFile $WireframefileName
createFile $ViewfileName

setupProtocolFile
setupInteractor
setupPresenter
setupWireframe
setupViewFile

echo ""
echo "################# END"
