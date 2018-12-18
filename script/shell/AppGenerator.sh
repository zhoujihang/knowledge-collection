#!/bin/sh
#使用方法：将该脚本放到项目根目录下，执行 sh AppGenerator.sh XZTenant v4.17.20 即可
#目的：生成一个.app的文件，能交给测试同学安装在模拟器中使用
if [ -z "$1" ];then
    echo "请输入 项目名称 和 分支名称，如：sh AppGenerator.sh XZTenant v4.17.20"
    exit 1
fi

if [ -z "$2" ];then
echo "请输入 项目名称 和 分支名称，如：sh AppGenerator.sh XZTenant v4.17.20"
    exit 1
fi

#项目名称
projectName=$1
#目标分支
branchName=$2
#build目录
derivedDataPath="`pwd`/build/derivedDataPath"
#最终目录
resultAppDir="`pwd`/build/AppFiles/branch-$branchName"
resultAppPath=$resultAppDir/$projectName-$branchName.app

echo "目标分支$branchName\nbuild目录$derivedDataPath\n最终目录$resultAppPath\n"

#删除缓存
if [ -d $derivedDataPath ];then
    echo "清除derivedData目录：$derivedDataPath"
    rm -rf $derivedDataPath
fi

git reset --hard HEAD
git checkout $branchName
pod install 
cmd="xcodebuild clean build -workspace $projectName.xcworkspace -scheme $projectName -configuration Debug  -sdk iphonesimulator -derivedDataPath $derivedDataPath COMPILER_INDEX_STORE_ENABLE=NO"
echo "执行命令：$cmd\n"
eval $cmd

appFile=`find $derivedDataPath -name "$projectName.app" -type d`
echo "app地址：$appFile\n"
if [ -z "$appFile" ];then
    echo "未找到生成的.app文件\n"
    exit
fi

mkdir -p $resultAppDir
mv $appFile $resultAppPath
echo "app最终地址：%resultAppPath"