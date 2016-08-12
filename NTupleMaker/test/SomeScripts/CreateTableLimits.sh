	 

	model=$1
	mass=$2
	masslsp=$3
	var=$4
	cut=$5
	channel=$6
	lumi=$7
	cardd=$8

	tempfile=temp${model}_${mass}_LSP${masslsp}_${var}_${cut}_${channel}_${lumi}.log 
	combine -M ProfileLikelihood --significance $cardd -t -1 --expectSignal=1 --toysFreq > $tempfile 
	sigexp=`grep --color=always Significance $tempfile | cut -d " " -f2` 
	echo A posteriori expected `grep --color=always Significance $tempfile`	

	combine -M ProfileLikelihood --significance $cardd -t -1 --expectSignal=1  > $tempfile 
	sigobs=`grep --color=always Significance $tempfile | cut -d " " -f2` 
	echo A priori expected `grep --color=always Significance $tempfile` 


	combine -M Asymptotic $cardd -m ${mass} -n ${mass}_LSP${masslsp}_${var} > $tempfile 
	pdown=`grep --color=always "Expected 16.0%" $tempfile | cut -d " " -f5` 
	pexp=`grep --color=always "Expected 50.0%" $tempfile | cut -d " " -f5` 
	pup=`grep --color=always "Expected 84.0%" $tempfile | cut -d " " -f5` 
	echo A priori `grep --color=always "Expected 16.0%" $tempfile` 
	echo A priori `grep --color=always "Expected 50.0%" $tempfile` 
	echo A priori `grep --color=always "Expected 84.0%" $tempfile` 

	pmx=${mass} 
	pmy=${masslsp} 
	pxsec=5 
	pobs=$pexp 
	pobsup=$pup 
	pobsdown=$pdown 
 	echo $pmx $pmy $pxsec $pobs $pobsup $pobsdown $pexp $pup $pdown $sigobs $sigexp >> TESTout 
