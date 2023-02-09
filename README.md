# foldcomp-analysis

This repository contains the benchmarking code and results for the paper,
**"Foldcomp: a library and format for compressing and indexing large protein structure sets"**.


- benchmark
    - result: Benchmark results for each tool. For each tool, compression and
              decompression was run 5 times.
    - scripts: Scripts for running the benchmark
        - bcif: [ciftools-java](https://github.com/rcsb/ciftools-java)
        - foldcomp: [foldcomp](https://github.com/steineggerlab/foldcomp)
        - gzip
        - mmtf
          - [mmtf-python](https://github.com/rcsb/mmtf-python)
          - [mmtf-java](https://github.com/rcsb/mmtf-java)
        - pic: [PIC](https://github.com/lukestaniscia/PIC)
        - pulchra: [pulchra](https://github.com/euplotes/pulchra)
    - visualization: Scripts for visualizing the benchmark results
        - plotting_script.r
        - data
            - benchmark_result.txt: Summary of the benchmark results
            - rmsd.txt: RMSD values for each tool
            - size.txt: Compressed sizes (bytes) for each tool

Special thanks to [@pwrose](https://github.com/pwrose) for the help with
benchmarking MMTF in Java.