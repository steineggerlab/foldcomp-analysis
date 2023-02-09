WORKDIR=AF_YEAST_v4
NUM_REPS=5

cd $WORKDIR/scripts/mmtf/mmtf-java

# mmtf 5 times
for i in $(seq 1 $NUM_REPS); do
    mvn exec:java -Dexec.mainClass="com.mmtfjavabenchmark.MmtfLosslessCompression" -Dexec.args="$WORKDIR/pdb $WORKDIR/mmtf/java/compressed" > $WORKDIR/log/mmtf_java_compression_$i.txt
    mvn exec:java -Dexec.mainClass="com.mmtfjavabenchmark.MmtfDecompression" -Dexec.args="$WORKDIR/java/compressed $WORKDIR/java/decompressed" > $WORKDIR/log/mmtf_java_decompression_$i.txt
done