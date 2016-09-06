#!/bin/sh
#
#(make sure the right shell will be used)
#$ -S /bin/sh
#
#(the cpu time for this job)
#$ -l h_cpu=1:29:00
#
#(the maximum memory usage of this job)
#$ -l h_vmem=5000M
#
#(use hh site)
#$ -l site=hh
#(stderr and stdout are merged together to stdout)
#$ -j y
#
# use SL5
#$ -l os=sld6
#
# use current dir and current environment
#$ -cwd
#$ -V
#



cd /nfs/dust/cms/user/bobovnii/CMSSW_8_0_12/src/DesyTauAnalyses/NTupleMaker/test;eval `scramv1 runtime -sh` ;


dir="/nfs/dust/cms/user/bobovnii/CMSSW_8_0_12/src/DesyTauAnalyses/NTupleMaker/test"

channel=$2
channel2=$2
btag="0.800"


IS_PFMET_USUAL="true" # for usual met
#IS_PFMET_USUAL="false" #for systematick


#IS_PFMET_JETEN="true" #for  met_Jet
IS_PFMET_JETEN="false" #for  met_Unclustered

#IS_PFMET_UP="true" #for met 1 sigma up
IS_PFMET_UP="false" #for met 1 sigma down

#WJETS_INCLUSIVE="false" # for combinning different WJETS 
WJETS_INCLUSIVE="true" # for WJETS_INCLUSIVE  

if [[ $2 == "Ttemplate" ]] 
then
	channel2="muel"
fi

if [[ $2 == "Wtemplate" ]]
then
	channel2="mutau"
fi

while read line
do

unset file
file=`echo $line | cut -d '/' -f2`
	
mkdir dir_${file}_${channel}
cd dir_${file}_${channel}
echo ==============================================
pwd
echo ==============================================

if [[ $line == *"stau"* || $line == *"C1"* ]] ; then
lsp=`echo $line | awk -F "_LSP" '{print $2}' | cut -d '_' -f1`
else
lsp=0

fi


cp $dir/analyzer_h .
cp $dir/analyzer${channel}_C .


#cp $dir/analyzer_InvMET_C .

sed -i 's/CHIMASSS/'$lsp'/g' analyzer*C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*


cp $dir/runme.C .
cp $dir/plots.h .


unset fileB
fileB=`echo $file | awk -F "_B_OS" '{print $1}'`


echo $line , $fileB

######### signal

if [[ $file == *"B_OS"*  ]] && [[ $file == *"stau"*  || $file == *"C1"* ]];then

cp analyzer_h analyzer.h
cp analyzer${channel}_C analyzer.C

echo Signal file here .....
ls


if [[ ! -f $dir/plots_$channel/${fileB}_B.root ]] ; then
echo the signal filein : $file , the fileout : ${fileB}_B.root

sed -i 's/FILEIN/'$file'/g' analyzer*
sed -i 's/LEPTONHERE/false/g' analyzer.C
sed -i 's/SIGNHERE/OS/g' analyzer.C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*
sed -i 's/BTAGCUT/0.800/g' analyzer*



rm plots.root
root -l -q -b runme.C 
# g++ `$ROOTSYS/bin/root-config --cflags --glibs` analyzer.C -o a;./a
mv plots.root $dir/plots_$channel/${fileB}_B.root
fi

fi



if [[ $file == *"B_OS"* ]];then

cp analyzer_h analyzer.h


######### B region non inverted OS

if [[ ! -f $dir/plots_$channel/${fileB}_B.root  ]] &&  [[ $file != *"stau"* && $file != *"C1"* ]]; then
cp analyzer_h analyzer.h
cp analyzer${channel}_C analyzer.C

echo the filein : $file , the fileout : ${fileB}_B.root NonInvertedLepton OS
sed -i 's/FILEIN/'$file'/g' analyzer*
sed -i 's/LEPTONHERE/false/g' analyzer.C
sed -i 's/SIGNHERE/OS/g' analyzer.C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*
sed -i 's/BTAGCUT/'$btag'/g' analyzer*


sed -i 's/IS_PFMET_USUAL/'$IS_PFMET_USUAL'/g' analyzer.C
sed -i 's/IS_PFMET_JETEN/'$IS_PFMET_JETEN'/g' analyzer.C
sed -i 's/IS_PFMET_UP/'$IS_PFMET_UP'/g' analyzer.C
sed -i 's/WJETS_INCLUSIVE/'$WJETS_INCLUSIVE'/g' analyzer.C

rm plots.root
root -l -q -b runme.C 
mv plots.root $dir/plots_$channel/${fileB}_B.root

fi


######### A region non inverted SS

if [[ ! -f $dir/plots_$channel/${fileB}_A.root ]]  && [[ $file != *"stau"* && $file != *"C1"*  ]] && [[ $2 != "Ttemplate" ]]; then
cp analyzer_h analyzer.h
cp analyzer${channel}_C analyzer.C

echo the filein : $file , the fileout : ${fileB}_A.root , NonInvertedLepton SS
sed -i 's/FILEIN/'$file'/g' analyzer*
sed -i 's/LEPTONHERE/false/g' analyzer.C
sed -i 's/SIGNHERE/SS/g' analyzer.C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*
sed -i 's/BTAGCUT/'$btag'/g' analyzer*


sed -i 's/IS_PFMET_USUAL/'$IS_PFMET_USUAL'/g' analyzer.C
sed -i 's/IS_PFMET_JETEN/'$IS_PFMET_JETEN'/g' analyzer.C
sed -i 's/IS_PFMET_UP/'$IS_PFMET_UP'/g' analyzer.C
sed -i 's/WJETS_INCLUSIVE/'$WJETS_INCLUSIVE'/g' analyzer.C
#if [[ $channel == "muel" ]] ; then

#sed -i '217 a            bqcd=true;' analyzer.C
#fi

rm plots.root
root -l -q -b runme.C 
mv plots.root $dir/plots_$channel/${fileB}_A.root

fi




######## D region
if [[ ! -f $dir/plots_$channel/${fileB}_D.root  ]] &&  [[ $file != *"stau"*  && $file != *"C1"* ]] && [[ $2 != "Ttemplate" ]]; then
cp analyzer${channel}_C analyzer.C
cp analyzer_h analyzer.h


echo the filein : $file , the fileout : ${fileB}_D.root InvertedLepton SS

sed -i 's/FILEIN/'$file'/g' analyzer*
sed -i 's/LEPTONHERE/true/g' analyzer.C
sed -i 's/SIGNHERE/SS/g' analyzer.C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*
sed -i 's/BTAGCUT/'$btag'/g' analyzer*


sed -i 's/IS_PFMET_USUAL/'$IS_PFMET_USUAL'/g' analyzer.C
sed -i 's/IS_PFMET_JETEN/'$IS_PFMET_JETEN'/g' analyzer.C
sed -i 's/IS_PFMET_UP/'$IS_PFMET_UP'/g' analyzer.C
sed -i 's/WJETS_INCLUSIVE/'$WJETS_INCLUSIVE'/g' analyzer.C
rm plots.root
root -l -q -b runme.C 
mv plots.root $dir/plots_$channel/${fileB}_D.root


fi


####### C region
if [[ ! -f $dir/plots_$channel/${fileB}_C.root  ]] &&  [[ $file != *"stau"* && $file != *"C1"*  ]] && [[ $2 != "Ttemplate" ]]; then
cp analyzer${channel}_C analyzer.C
cp analyzer_h analyzer.h



echo the filein : $file , the fileout : ${fileB}_C.root  InvertedLepton OS
sed -i 's/FILEIN/'$file'/g' analyzer*
sed -i 's/LEPTONHERE/true/g' analyzer.C
sed -i 's/SIGNHERE/OS/g' analyzer.C
sed -i 's/CHANNELHERE/'$channel2'/g' analyzer*
sed -i 's/BTAGCUT/'$btag'/g' analyzer*


sed -i 's/IS_PFMET_USUAL/'$IS_PFMET_USUAL'/g' analyzer.C
sed -i 's/IS_PFMET_JETEN/'$IS_PFMET_JETEN'/g' analyzer.C
sed -i 's/IS_PFMET_UP/'$IS_PFMET_UP'/g' analyzer.C
sed -i 's/WJETS_INCLUSIVE/'$WJETS_INCLUSIVE'/g' analyzer.C
rm plots.root
root -l -q -b runme.C 

mv plots.root $dir/plots_$channel/${fileB}_C.root


fi

fi

cd ${dir}

rm -fr dir_$line
done<$1
