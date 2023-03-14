#!/bin/bash                                                                                                                                                                                                                                                                                                                                                     
# arguments:                                                                                                                                                                                                                                                                                                                                                    
# inPattern - input file pattern, default: foo_in                                                                                                                                                                                                                                                                                                               
# outPattern - input file pattern, default: foo_out                                                                                                                                                                                                                                                                                                             
# maxNFiles - maximum number of files to add together, default: 10                                                                                                                                                                                                                                                                                              
# override - whether to use -f option in hadd, overwriting existing files, default: false                                                                                                                                                                                                                                                                       

inPattern=${1:-DATA_miniAOD_Tkpt1p5_Tketa2p4_dpt2_deta2p4}
outPattern=${2:-DATA_out_new}
maxNFiles=${3:-150}

override=${4:-false}

echo "inPattern = ${inPattern}"
echo "outPattern = ${outPattern}"

finalhaddchain=""

haddchain=""
if [ override ]
then
  haddchain="-f"
fi

nFiles=0
nHadds=0
for file in `ls ${inPattern}_*.root`
do
  echo "${file}"
  haddchain="${haddchain} ${file}" # appends file to hadd command                                                                                                                                                                                                                                                                                               
  nFiles=$(( ${nFiles}+1 ))        # increment nFiles counter                                                                                                                                                                                                                                                                                                   

  if [ ${nFiles} -ge ${maxNFiles} ] # if we've appended maxNFiles, then hadd them together                                                                                                                                                                                                                                                                      
  then
    hadd ${outPattern}_${nHadds}.root ${haddchain}
    finalhaddchain="${finalhaddchain} ${outPattern}_${nHadds}.root"
    nHadds=$(( ${nHadds}+1 ))       # increment nHadds counter                                                                                                                                                                                                                                                                                                  


    nFiles=0                        # reset relevant variables                                                                                                                                                                                                                                                                                                  
    if [ override ]
    then
      haddchain="-f"
    else
      haddchain=""
    fi
  fi
done


if [ ${nFiles} -ge 1 ]
then
  hadd ${outPattern}_${nHadds}.root ${haddchain}
  finalhaddchain="${finalhaddchain} ${outPattern}_${nHadds}.root"
  nHadds=$(( ${nHadds}+1 ))
fi

if [ ${nHadds} -ge 1 ]
then
  hadd ${outPattern}_combined.root ${finalhaddchain}
fi
