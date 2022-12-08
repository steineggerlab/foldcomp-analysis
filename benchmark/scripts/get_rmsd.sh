# Get two directories and compare the rmsd of pdb files with same basename
# Usage: rmsd_with_foldcomp.sh <dir1> <dir2>
foldcomp_path=foldcomp/build/foldcomp
WORK_DIR=AF_YEAST_v4

# Tools to calculate rmsd
# bcif, mmtf, pic, pulchra, foldcomp, gzip
# BCIF_DIR contains cif files, for others they contain pdb files
BCIF_DIR=$WORK_DIR/bcif/decompressed
MMTF_DIR=$WORK_DIR/mmtf/decompressed
PIC_DIR=$WORK_DIR/pic/decompressed
PULCHRA_DIR=$WORK_DIR/pulchra/decompressed
FOLDCOMP_DIR=$WORK_DIR/pdb_fcz_pdb
GZIP_DIR=$WORK_DIR/gzip

echo file1$'\t'file2$'\t'backboneLen$'\t'totalAtoms$'\t'backboneRMSD$'\t'totalRMSD$'\t'tool
for file in $WORK_DIR/pdb/*.pdb
do
    base=`basename $file .pdb`
    cif_file=$BCIF_DIR/$base.cif
    pulchra_file=$PULCHRA_DIR/$base.rebuilt.pdb
    # bcif
    $foldcomp_path rmsd $file $cif_file # CHECKED
    echo $'\t'bcif
    # mmtf
    $foldcomp_path rmsd $file $MMTF_DIR/$base.pdb # CHECKED
    echo $'\t'mmtf
    # pic
    $foldcomp_path rmsd $file $PIC_DIR/${base}_decompressed.pdb
    echo $'\t'pic
    # pulchra
    $foldcomp_path rmsd $file $pulchra_file
    echo $'\t'pulchra
    # foldcomp
    $foldcomp_path rmsd $file $FOLDCOMP_DIR/$base.pdb
    echo $'\t'foldcomp
done

# Redirection the output to file and change '\n\t' to '\t
# sed -i 's/\n\t/\t/g' rmsd.txt