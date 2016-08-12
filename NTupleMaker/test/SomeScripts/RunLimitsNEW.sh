
#variables="DZeta_MTsum DZeta_MTtot met_DZeta met_MCTb met_MT met_MTsum met_MTtot MTsum_MCTb MTtot_MCTb"
#variables="MT2lester_MCTb MT2lester_met MT2lester_DZeta"
variables="MT2lester_met"


massp=$1
lspp=$2
lumi=12000

cut=13

model=$1

if [[ $1 == "stau" ]] ; then

model="stau_stau"

fi

if [[ $1 == "C1N2" ]] ; then

model="C1N2_"

fi

if [[ $1 == "C1C1" ]] ; then

model="C1C1_"

fi

lsprange=$3

echo ============================ $lsprange

#for mass in `seq 100 25 100`
#for mass in 60 70 80 90 100 110 120
for mass in $2
do
    #for masslsp in 1 10 20
    for masslsp in $lsprange
    do
	    #for channel in mt et muel
	    for channel in  comb
	    do
		echo "--> channel" $channel and $mass , LSP$masslsp



for var in $variables
do

if [[ ! -f  outputTEST/${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}invpb.root ]] ; then

cardnew=combinedTEST/${model}${mass}_LSP${masslsp}_${var}_${cut}_onelepton_${lumi}invpb.txt

if [[ $channel == "comb" ]] && [[ ! -f $cardnew ]] ; then

cardmt=cards_mt/${model}${mass}_LSP${masslsp}_${var}_${cut}_mt_${lumi}invpb.txt
cardet=cards_et/${model}${mass}_LSP${masslsp}_${var}_${cut}_et_${lumi}invpb.txt
cardme=cards_me/${model}${mass}_LSP${masslsp}_${var}_11_me_${lumi}invpb.txt
#cardme=""

#cardnew=combined/${model}${mass}_LSP${masslsp}_${var}_${cut}_onelepton_${lumi}invpb.txt

combineCards.py $cardmt $cardet  $cardme > $cardnew

fi

cardd=$cardnew
	cat bss > ljob_${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}.sh

	echo ./CreateTableLimits.sh ${model} ${mass} ${masslsp} ${var} ${cut} ${channel} ${lumi} ${cardd} >> ljob_${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}.sh
	echo    mv higgsCombine${mass}_LSP${masslsp}_${var}.Asymptotic.mH${mass}.root outputTEST/${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}invpb.root  >> ljob_${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}.sh

	qsub -N ${model}_${mass}_${masslsp}_${var} ljob_${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}.sh
fi
	done
    done
done
done
