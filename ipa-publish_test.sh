#!/bin/bash

#--------------------------------------------
# 功能：创建符合itms-services协议的发布文件
# 作者：ccf
# E-mail:ccf.developer@gmail.com
# 创建日期：2012/09/24
#--------------------------------------------
# 修改日期：2012/09/27
# 修改人：ccf
# 修改内容：去掉打包的部分脚本，只保留生成协议文件部分，以后此脚本依赖ipa-build脚本
#--------------------------------------------
#须配置内容 start

#发布应用的url地址
pulish_url="https://campus.iot.xiaofuonline.com/FiiLM"
target_name=$1

#可配置内容 end

#参数判断
#if [ $# != 2 ] && [ $# != 1 ];then
#echo "Number of params error! Need one or two params!"
#echo "1.root path of project(necessary) 2.name used to display when installing"
#exit
#elif [ ! -d $1 ];then
#echo "The param must be a dictionary."
#exit
#fi

#工程绝对路径
#cd $1
project_path=$(pwd)

#判断所输入路径是否是xcode工程的根路径
#ls | grep .xcodeproj > /dev/null
#rtnValue=$?
#if [ $rtnValue != 0 ];then
#echo "Error!! The param must be the root path of a xcode project."
#exit
#fi

#判断是否执行过ipa-build脚本
#ls ./build/ipa-build/*.ipa &>/dev/null
#rtnValue=$?
#if [ $rtnValue != 0 ];then
#echo "Error!! No ipa files exists.Please run the \"ipa-build\" shell script first"
#exit
#fi

#IPA名称
#if [ $# = 2 ];then
#ipa_name=$2
#fi

#build文件夹路径
#build_path=${project_path}/build

#工程配置文件路径
#project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
#project_infoplist_path=${project_path}/${project_name}/${project_name}-Info.plist

#取build值
#bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})
bundleVersion=2.0.0

#取bundle Identifier前缀
#bundlePrefix=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" `find . -name "*-Info.plist"` | awk -F$ '{print $1}')
bundlePrefix=com.FoxconnIoT.FiiLogistics

#生成发布文件
#拷贝ipa
#cd $build_path
#target_name=$(basename ./Release-iphoneos/*.app | awk -F. '{print $1}')
if [ $# = 1 ];then
    ipa_name="${target_name}"
fi



if [ -d ./$target_name ];then
    rm -rf $target_name
fi

mkdir $target_name
cp ./*.ipa ./${target_name}/${target_name}.ipa
cp ./*.png ./${target_name}/${target_name}_logo.png
cd $target_name

#生成install.html文件
cat << EOF > index.html
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>安装此软件</title>
</head>
<body>
    <br>
    <br>
    <br>
    <br>
    <p align=center>
    <font size="8">
    <a href="itms-services://?action=download-manifest&url=${pulish_url}/${target_name}/${target_name}.plist">点击这里安装</a>
    </font>
    </p>
    </div>
</body>
</html>
EOF
#生成plist文件
cat << EOF > ${target_name}.plist
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>items</key>
		<array>
			<dict>
				<key>assets</key>
				<array>
					<dict>
						<key>kind</key>
						<string>software-package</string>
						<key>url</key>
						<string>https://campus.iot.xiaofuonline.com/FiiLM/ipa_test/ipatest2/ipatest2.ipa</string>
					</dict>
					<dict>
						<key>kind</key> 
						<string>display-image</string>
						<key>needs-shine</key>
						<true/>
						<key>url</key>
						<string>https://campus.iot.xiaofuonline.com/FiiLM/ipa_test/ipatest2/ipatest2_logo.png</string>
					</dict>
					<dict>
						<key>kind</key>
						<string>full-size-image</string>
						<key>needs-shine</key>
						<true/>
						<key>url</key>
						<string>https://campus.iot.xiaofuonline.com/FiiLM/ipa_test/ipatest2/ipatest2_logo.png</string>
					</dict>
				</array>
				<key>metadata</key>
				<dict>
					<key>bundle-identifier</key>
					<string>com.FoxconnIoT.FiiLogistics</string>
					<key>bundle-version</key>
					<string>2.0.0</string>
					<key>kind</key>
					<string>software</string>
					<key>subtitle</key>
					<string>ipatest2</string>
					<key>title</key>
					<string>ipatest2</string>
				</dict>
			</dict>
		</array>
	</dict>
</plist>
EOF
