WORKDIR=AF_YEAST_v4 # Change this to the directory you want to use
NUM_REPS=5
FOLDCOMP=foldcomp/build/foldcomp

# foldcomp 5 times
for i in $(seq 1 $NUM_REPS); do
    $FOLDCOMP compress --time $WORKDIR/pdb > $WORKDIR/log/foldcomp_compression_$i.txt
    $FOLDCOMP decompress -a --time $WORKDIR/pdb_fcz > $WORKDIR/log/foldcomp_decompression_$i.txt
done