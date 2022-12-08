# Script to get compressed file size
WORKDIR=AF_YEAST_v4
# Gather splitted files from PIC benchmark
cp $WORKDIR/pic_split/**/*.png $WORKDIR/pic/png
cp $WORKDIR/pic_split/**/*.bin $WORKDIR/pic/bin
# If not gzipped, gzip
gzip $WORKDIR/gzip/*.pdb
# Iterate
for pdb_file in $WORKDIR/pdb/*.pdb; do
    pdb_id=$(basename $pdb_file .pdb)
    foldcomp_size=$(stat -c%s $WORKDIR/pdb_fcz/$pdb_id.fcz)
    pic_size=$(stat -c%s $WORKDIR/pic/($pdb_id)_img_1.png)
    gzip_size=$(stat -c%s $WORKDIR/gzip/$pdb_id.pdb.gz)
    pulchra_size=$(stat -c%s $WORKDIR/pulchra/compressed/$pdb_id.pdb)
    mmtf_size=$(stat -c%s $WORKDIR/mmtf/$pdb_id.mmtf)
    bcif_size=$(stat -c%s $WORKDIR/bcif/compressed/$pdb_id.bcif)
    cif_size=$(stat -c%s $WORKDIR/cif/$pdb_id.cif)
    pdb_size=$(stat -c%s $WORKDIR/pdb/$pdb_id.pdb)
    echo $pdb_id$'\t'pdb$'\t'$pdb_size
    echo $pdb_id$'\t'cif$'\t'$cif_size
    echo $pdb_id$'\t'bcif$'\t'$bcif_size
    echo $pdb_id$'\t'mmtf$'\t'$mmtf_size
    echo $pdb_id$'\t'pulchra$'\t'$pulchra_size
    echo $pdb_id$'\t'gzip$'\t'$gzip_size
    echo $pdb_id$'\t'pic$'\t'$pic_size
    echo $pdb_id$'\t'foldcomp$'\t'$foldcomp_size
done
