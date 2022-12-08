from Bio.PDB.PDBIO import PDBIO
from Bio.PDB import MMCIFParser
from Bio.PDB.mmtf import MMTFIO, MMTFParser
import time
import os
import sys
import multiprocessing

MMCIF_PARSER = MMCIFParser()
MMTF_PARSER = MMTFParser()
MMTF_IO = MMTFIO()
PDB_IO = PDBIO()

def mmtf_compression(input_path, output_path):
    start = time.process_time()
    structure = MMCIF_PARSER.get_structure("structure", input_path)
    MMTF_IO.set_structure(structure)
    MMTF_IO.save(output_path)
    end = time.process_time()
    return (input_path, end - start)

def mmtf_decompression(input_path, output_path):
    start = time.process_time()
    structure = MMTF_PARSER.get_structure(input_path)
    PDB_IO.set_structure(structure)
    PDB_IO.save(output_path)
    end = time.process_time()
    return (input_path, end - start)

def main():
    mode = sys.argv[1]
    num_processes = int(sys.argv[2])
    input_path = sys.argv[3]
    output_path = sys.argv[4]
    pool = multiprocessing.Pool(processes=num_processes)
    input_files = os.listdir(input_path)
    if mode == "compress":
        batch_input = [(os.path.join(input_path, file), os.path.join(output_path, file[:-3] + "mmtf")) for file in input_files if file.endswith(".cif")]
        result = pool.starmap(mmtf_compression, batch_input)
    elif mode == "decompress":
        batch_input = [(os.path.join(input_path, file), os.path.join(output_path, file[:-4] + "pdb")) for file in input_files if file.endswith(".mmtf")]
        result = pool.starmap(mmtf_decompression, batch_input)
    pool.close()
    pool.join()
    for file, elapsed_time in result:
        print(f"{file}\t{elapsed_time}")

if __name__ == "__main__":
    main()
