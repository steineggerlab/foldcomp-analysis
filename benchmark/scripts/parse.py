#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File: parse.py
# Project: scripts
# Description:
#     This code is written as part of foldcomp-analysis
# ------------------------------------------------------------
# Created: 2022-12-08 20:21:45
# Author: Hyunbin Kim (khb7840@gmail.com)
# ------------------------------------------------------------
# Last Modified: 2022-12-08 20:25:24
# Modified By: Hyunbin Kim (khb7840@gmail.com)
# ------------------------------------------------------------
# Copyright © 2022 Hyunbin Kim, All rights reserved

import re

# Regular expression to get alphafold db id
# Format like this:AF-P32340-F1-model_v4.pdb
re_pdb_id = re.compile("AF-.+-F1-model_v4")

def get_pdb_id(pdb_path):

    matched = re_pdb_id.findall(pdb_path)
    if len(matched) == 0:
        return ""
    return matched[0]

output = "../visualization/data/benchmark_result.txt"
with open(output, "w") as f:
    f.write("pdb_path\ttool\trepeat\ttime_type\ttime\n")

def write_to_file(tool, mode, data_path, writing_file):
    with open(data_path, "r") as data_file:
        for line in data_file:
            entries = line.split("\t")
            if len(entries) != 2:
                continue
            else:
                pdb_path = entries[0]
                time = entries[1].strip()
                pdb_id = get_pdb_id(pdb_path)
                if pdb_id == "":
                    continue
                writing_file.write(f"{pdb_id}\t{tool}\t{i+1}\t{mode}\t{time}\n")

def parse_gzip_result(mode, tool, rep, data_path, output_file):
    with open(data_path, "r") as data_file:
        lines = data_file.readlines()
        start_time = 0
        for i, line in enumerate(lines):
            if i == 0:
                start_time = float(line.strip())
            else:
                entries = line.strip().split(" ")
                if len(entries) < 2:
                    continue
                else:
                    end_time = float(entries[0])
                    pdb_path = entries[1]
                    pdb_id = get_pdb_id(pdb_path)
                    if pdb_id == "":
                        continue
                    with open(output, "a") as f:
                        output_file.write(f"{pdb_id}\t{tool}\t{rep}\t{mode}\t{end_time - start_time:.8f}\n")
                    start_time = end_time

for i in range(5):
    with open(output, "a") as f:
        # Append Ciftools result
        bcif_compression_path = f"../result/bcif/bcif_compression_{i+1}.txt"
        bcif_decompression_path = f"../result/bcif/bcif_decompression_{i+1}.txt"
        write_to_file("bcif", "compression", bcif_compression_path, f)
        write_to_file("bcif", "decompression", bcif_decompression_path, f)
        # Append Foldcomp result
        foldcomp_compression_path = f"../result/foldcomp/foldcomp_compression_{i+1}.txt"
        foldcomp_decompression_path = f"../result/foldcomp/foldcomp_decompression_{i+1}.txt"
        write_to_file("foldcomp", "compression", foldcomp_compression_path, f)
        write_to_file("foldcomp", "decompression", foldcomp_decompression_path, f)
        # Append MMTF result
        mmtf_compression_path = f"../result/mmtf/mmtf_compression_{i+1}.txt"
        mmtf_decompression_path = f"../result/mmtf/mmtf_decompression_{i+1}.txt"
        write_to_file("mmtf", "compression", mmtf_compression_path, f)
        write_to_file("mmtf", "decompression", mmtf_decompression_path, f)
        # Append Gzipping PDB result
        gzip_compression_path = f"../result/gzip/6/gzip_compression_{i+1}.txt"
        gzip_decompression_path = f"../result/gzip/6/gzip_decompression_{i+1}.txt"
        parse_gzip_result("compression", "gzip6", i+1, gzip_compression_path, f)
        parse_gzip_result("decompression", "gzip6", i+1, gzip_decompression_path, f)
        gzip_9_compression_path = f"../result/gzip/9/gzip_9_compression_{i+1}.txt"
        gzip_9_decompression_path = f"../result/gzip/9/gzip_9_decompression_{i+1}.txt"
        parse_gzip_result("compression", "gzip9", i+1, gzip_9_compression_path, f)
        parse_gzip_result("decompression", "gzip9", i+1, gzip_9_decompression_path, f)
        # Append PIC result
        pic_compression_path = f"../result/pic/pic_compression_{i+1}.tsv"
        pic_decompression_path = f"../result/pic/pic_decompression_{i+1}.tsv"
        write_to_file("pic", "compression", pic_compression_path, f)
        write_to_file("pic", "decompression", pic_decompression_path, f)
        # Append Pulchra result
        pulchra_compression_path = f"../result/pulchra/pulchra_compression_{i+1}.txt"
        pulchra_decompression_path = f"../result/pulchra/pulchra_decompression_{i+1}.txt"
        write_to_file("pulchra", "compression", pulchra_compression_path, f)
        write_to_file("pulchra", "decompression", pulchra_decompression_path, f)