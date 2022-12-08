WORKDIR=AF_YEAST_v4
NUM_REPS=5
PIC_PY=PIC/PIC-time.py

# pic 5 times
for i in $(seq 1 $NUM_REPS); do
    parallel -j 100 "python $PIC_PY -rk $WORK_DIR/pic_split/{}/ > $WORK_DIR/log/temp/pic-comp{}.tsv" ::: {0..99}
    grep -A 100 "Compression time" $WORK_DIR/log/temp/pic-comp*.tsv > $WORK_DIR/log/pic_compression_$i.tsv # Merge log files
    parallel -j 100 "python $PIC_PY -rdk $WORK_DIR/pic_split/{}/ > $WORK_DIR/log/temp/pic-decomp{}.tsv" ::: {0..99}
    grep -A 100 "Decompression time" $WORK_DIR/log/temp/pic-decomp*.tsv > $WORK_DIR/log/pic_decompression_$i.tsv
done
