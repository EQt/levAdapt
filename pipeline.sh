#usage: ./pipeline.sh FILE OUTPUT_DIR KMERSIZE NB_INPUT_KMER NB_OUT_KMER
#fetching arguments
filePath=$1
workPath=$2
kmerSize=$3
kCutoff=$4
nbStore=$5
# Getting filename without extension
filename=$(basename -- "$filePath")
filename="${filename%.*}"
#creating workfolder
echo "GENERATING WORKSPACE"
mkdir $workPath
#Creating kmer list
echo "EXTRACTING EXACT KMERS FROM INPUT"
./kExtract $filePath -k $kmerSize |head -n $kCutoff > $workPath'/'$filename'_kmers_first'$kCutoff'.txt'
#Converting to fasta
echo "CONVERTING KMER LIST TO FASTA"
python3 kExtract.py  $workPath'/'$filename'_kmers_first'$kCutoff'.txt' >  $workPath'/'$filename'_kmers_first'$kCutoff'.fasta'
# Neigbourhood gen (deactivated)
#python3 levGen.py  $workPath'/'$filename'_kmers_first'$kCutoff'.fasta' 2
#Counting kmers at ~ 2err
echo "COUNTING KMERS"
./adaptFinder2  $filePath -kf  $workPath'/'$filename'_kmers_first'$kCutoff'.fasta' -nt 4 -ns $nbStore >  $workPath'/'$filename'_COMPTAGE.txt'
echo  "CONVERTING RESULT TO FASTA"
python3 adapterBits2fasta.py  $workPath'/'$filename'_COMPTAGE.txt' > $workPath'/'$filename'_COMPTAGE.fasta'
echo "GENERATING OVERLAPS"
python3 simplOverlap.py $workPath'/'$filename'_COMPTAGE.txt' > $workPath'/'$filename'_OVERLAPS.txt'
echo "DONE"