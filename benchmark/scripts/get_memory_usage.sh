WORKDIR=AF_YEAST_v4
FORMAT_STRING='%C\t%M' # Command name and memory usage
FOLDCOMP=foldcomp/build/foldcomp

for pdb in $WORKDIR/pdb/*.pdb; do
    \time -f $FORMAT_STRING $FOLDCOMP compress $pdb
done

for fcz in $WORKDIR/pdb/*.fcz; do
    \time -f $FORMAT_STRING $FOLDCOMP decompress $fcz
done