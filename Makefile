ARCHS = arm64
TARGET = iphone:latest:15.0
DEB_ARCH = iphoneos-arm64e
IPHONEOS_DEPLOYMENT_TARGET = 15.0

INSTALL_TARGET_PROCESSES = Unagent

THEOS_PACKAGE_SCHEME = roothide

THEOS_DEVICE_IP = iphone13.local

#disable theos auto sign for all mach-o
TARGET_CODESIGN = echo "don't sign"

include $(THEOS)/makefiles/common.mk

XCODE_SCHEME = Unagent
XCODEPROJ_NAME = Unagent

Unagent_XCODEFLAGS = MARKETING_VERSION=$(THEOS_PACKAGE_BASE_VERSION) \
	IPHONEOS_DEPLOYMENT_TARGET="$(IPHONEOS_DEPLOYMENT_TARGET)" \
	CODE_SIGN_IDENTITY="" \
	AD_HOC_CODE_SIGNING_ALLOWED=YES
Unagent_XCODE_SCHEME = $(XCODE_SCHEME)
#Unagent_CODESIGN_FLAGS = -Sentitlements.plist
Unagent_INSTALL_PATH = /Applications

include $(THEOS_MAKE_PATH)/xcodeproj.mk

clean::
	rm -rf ./packages/*

before-package::
	rm -rf ./packages
	cp -a ./Extension ./.theos/_/Applications/Unagent.app/
	ldid -Sentitlements.entitlements ./.theos/_/Applications/Unagent.app/Unagent
	ldid -Sentitlementextension.entitlements ./.theos/_/Applications/Unagent.app/Unagent
	mkdir -p ./packages/Payload
	cp -R ./.theos/_/Applications/Unagent.app ./packages/Payload
	cd ./packages && zip -mry ./Unagent.tipa ./Payload
	rm -rf ./.theos/_/Applications
	mkdir ./.theos/_/tmp
	cp ./packages/Unagent.tipa ./.theos/_/tmp/

after-install::
	#install.exec 'uiopen -b com.tom.Unagent'
