WORKDIR=AF_YEAST_v4
NUM_REPS=5
PULCHRA=pulchra304/src/pulchra

# Extract CA atoms with grep
for pdb_file in $WORKDIR/pdb/*.pdb; do
    echo | ts "%.s"; (grep "CA" $pdb_file > $WORKDIR/pulchra/compressed/$(basename $pdb_file)); echo $"\t"$pdb_file
    parallel -j 100 "$PULCHRA $WORKDIR/pulchra/compressed/{}" ::: $WORKDIR/pulchra/compressed/*.pdb
done
