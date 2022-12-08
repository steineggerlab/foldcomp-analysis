WORKDIR=AF_YEAST_v4
NUM_REPS=5
MMTF_PY=mmtf/mmtf-batch.py

# mmtf 5 times
for i in $(seq 1 $NUM_REPS); do
    python $MMTF_PY compress 100 $WORKDIR/cif $WORKDIR/mmtf/compressed/ > $WORKDIR/log/mmtf_compression_$i.txt
    python $MMTF_PY decompress 100 $WORKDIR/mmtf/compressed/ $WORKDIR/mmtf/decompressed/ > $WORKDIR/log/mmtf_decompression_$i.txt
done
