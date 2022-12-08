WORKDIR=AF_YEAST_v4
NUM_REPS=5

# gzip 5 times
for i in $(seq 1 $NUM_REPS); do
    (echo | ts '%.s'; gzip -r -v $WORK_DIR/gzip 2>&1 | ts '%.s'; echo | ts '%.s';) > $WORKDIR/log/gzip_compression_$i.txt
    (echo | ts '%.s'; gunzip -r -v $WORK_DIR/gzip 2>&1 | ts '%.s'; echo | ts '%.';) > $WORKDIR/log/gzip_decompression_$i.txt
done