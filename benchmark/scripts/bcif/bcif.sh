WORKDIR=AF_YEAST_v4
NUM_REPS=5
BCIF_JAR=ciftools-java/target/ciftools-java-4.0.5-SNAPSHOT.jar

# bcif 5 times
for i in $(seq 1 $NUM_REPS); do
    java -cp $BCIF_JAR org.rcsb.cif.CompressBatch $WORKDIR/cif $WORKDIR/bcif/compressed/ > $WORKDIR/log/bcif_compression_$i.txt
    java -cp $BCIF_JAR org.rcsb.cif.DecompressBatch $WORKDIR/bcif/compressed/ $WORKDIR/bcif/decompressed/ > $WORKDIR/log/bcif_decompression_$i.txt
done
