#!/bin/sh 
mainFileName=""
dirName="CopyHeadFile"
sFileName="allFileName.txt"
configFileName="config.ini"
phName="plugHead.h"
clogName="checkLog1.txt"
cdName="checkData1.txt"
llogName="checkLog2.txt"
testDirName=""

lbp="libClangtest"
mcheckp="matchCheck"
#mcheck2p="matchCheck2"
cpFilep="cpFile"
checkFilep="checkMemory"
#checkFile2p="checkMemory2"

argc=$#


if [ $argc -lt 2 ];then
#    echo "argc" $argc
#    echo "#0" $0 "#1" $1 "2" $2
	echo "extra argument should be at least 2(directoryName,fileName)!"
	exit 1
	
else
    mainFileName=$2
	testDirName=$1
	#echo "fileName" $fileName
	
    if [ ! -d $dirName ];then
        mkdir $dirName
    fi	
    dirName="${dirName}/${testDirName}"
    
    if [ ! -d $dirName ];then
        echo "directory not found!"
        exit 1
	
	else
        #./$cpFilep $mainFileName

        #g++ -o $mcheckp "${mcheckp}.cpp"
        echo $dirName
        
        cp $cpFilep ./$dirName/$cpFilep
        #cp $mainFileName ./$dirName/$mainFileName
        cp $sFileName ./$dirName/$sFileName
        cp $phName ./$dirName/$phName
        cp $configFileName ./$dirName/$configFileName
        
        cp $checkFilep ./$dirName/$checkFilep
#	    cp $checkFile2p ./$dirName/$checkFile2p
        cp $mcheckp ./$dirName/$mcheckp
#	    cp $mcheck2p ./$dirName/$mcheck2p
        cp $lbp ./$dirName/$lbp
        cd $dirName
       
           
       	if [ ! -f $mainFileName ];then
	        echo "file not found!"
	        exit 1
    	fi

       
       
        ./$cpFilep $mainFileName
        ./$lbp $mainFileName
        
	    cp "$mainFileName" "${mainFileName}_bak"
        mv "${mainFileName}_out" $mainFileName
#	    cp $mainFileName "out_${mainFileName}"
#	    ./$checkFile2p "out_${mainFileName}" --
        ./$checkFilep $mainFileName --
        for LINE in `cat $sFileName`
        do 
	        echo $LINE
	        if [ -d "${LINE%/*}/" ] ;then
    	        cp $phName "${LINE%/*}/$phName"
    	    fi
	        ./$checkFilep $LINE --
	        outFileName="${LINE}_out"
	        
	        mv ${outFileName} $LINE
        done
        mv "${mainFileName}_out" $mainFileName
#	    mv "out_${mainFileName}_out" "out_${mainFileName}"
        if [ -f $cdName ] ;then
	        rm $cdName
        fi
        touch $cdName
        if [ -f $llogName ] ;then
            rm $llogName
        fi
        touch $llogName
        #it should be the official makefile to build the project
        #now it is replaced by a simple example
#        g++ -o "${mainFileName%%.c}" $mainFileName
#        ./${mainFileName%%.c}
	
#    	g++ -o "out_${mainFileName%%.c}" "out_${mainFileName}"

        #then use the data to do the checking
#        ./$mcheckp 
#        cp $clogName ../../$clogName
#        cp $llogName ../../c$llogName
	
#	cp "out_${mainFileName%%.c}" ../"out_${mainFileName%%.c}"
	cd CopyHeadFile/$testDirName
	make
#	run your program
#	sh runme.sh
    fi
fi
