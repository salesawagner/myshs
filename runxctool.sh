echo "################# START"
PROJECT="WASKit.xcodeproj"
SCHEME="WASKit"
SDK="iphonesimulator10.1"
DESTINATION="OS=10.1,name=iPhone 7"

###############################
## Variables
###############################
echo "################# Variables"
echo "PROJECT     ->$PROJECT"
echo "WORKSPACE   ->$WORKSPACE"
echo "SCHEME      ->$SCHEME"
echo "SDK         ->$SDK"
echo "DESTINATION ->$DESTINATION"
echo ""
echo "\n"
echo "################# BUILD"
###############################
## build
###############################
xctool -workspace "$WORKSPACE" -scheme "$SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration Debug ONLY_ACTIVE_ARCH=YES ENABLE_TESTABILITY=YES test | xcpretty;
xcodebuild clean test -project WASKit.xcodeproj -scheme "$SCHEME" -destination "$DESTINATION" -enableCodeCoverage YES | xcpretty;
echo ""
echo ""
echo "################# SLATHER"
###############################
## SLATHER
###############################
slather coverage --verbose -s
echo ""
echo ""
echo "################# CODECOV"
###############################
## CODECOV
###############################
bash <(curl -s https://codecov.io/bash)

echo ""
echo ""
echo "################# END"