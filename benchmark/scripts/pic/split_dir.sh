# Split directories into 100 subdirectories
for i in {0..99}; do
    mkdir -p ./$i
done

# Move files into subdirectories
count=0;
for i in $(ls ./pdb); do
    count=$((count+1))
    basename=${i%.*}
    # move only pdb files
    if [[ $i == *.pdb ]]; then
        cp ./pdb/$i ./pic_split/$((count%100))/$i
    fi
done
