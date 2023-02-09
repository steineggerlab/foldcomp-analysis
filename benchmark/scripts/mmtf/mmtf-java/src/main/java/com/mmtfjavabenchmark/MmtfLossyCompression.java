package com.mmtfjavabenchmark;

// import PDBFileReader;
import org.biojava.nbio.structure.io.PDBFileReader;
import org.biojava.nbio.structure.io.mmtf.MmtfStructureWriter;
import org.biojava.nbio.structure.Structure;

import org.rcsb.mmtf.encoder.GenericEncoder;
import org.rcsb.mmtf.encoder.AdapterToStructureData;
import org.rcsb.mmtf.dataholders.MmtfStructure;
import org.rcsb.mmtf.serialization.MessagePackSerialization;


import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.FileOutputStream;

public class MmtfLossyCompression {

    public static void main(String[] args) {
        // Get args
        // args[0] = input directory that contains pdb files
        // args[1] = output directory that will contain mmtf files

        // Get directories
        Path input = Paths.get(args[0]);
        if (!input.toFile().exists()) {
            System.out.println("Input directory does not exist.");
            System.exit(1);
        }
        Path output = Paths.get(args[1]);

        // Get all files in input directory
        File[] files = input.toFile().listFiles();

        for (File file : files) {
            // Get file name
            String fileName = file.getName();
            // Get file extension
            String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
            // Check if file is a PDB file
            if (!fileExtension.equals("pdb")) {
                continue;
            }
            String outputFileName = fileName.substring(0, fileName.lastIndexOf(".")) + ".mmtf";
            Path outputFile = Paths.get(output.toString(), outputFileName);

            // Measure running time
            long endTime;
            long startTime = System.nanoTime();
            try {
                // Read PDB file to Structure object
                PDBFileReader pdbReader = new PDBFileReader();
                Structure structure = null;
                structure = pdbReader.getStructure(file);

                // AdapterToStructureData hands over the Structure object to the encoder
                AdapterToStructureData adapter = new AdapterToStructureData();
                new MmtfStructureWriter(structure, adapter);

                // writerToEncoder: StructureAdapterInterface
                GenericEncoder encoder;
                // Precision is encoded as int
                // Save only one decimal place with multiplying by 10
                encoder = new GenericEncoder(adapter, 10);

                // MmtfStructure is a Serializable object packed with MessagePack
                MmtfStructure mmtf = encoder.getMmtfEncodedStructure();
                FileOutputStream fos = new FileOutputStream(outputFile.toFile());
                MessagePackSerialization mps = new MessagePackSerialization();
                mps.serialize(mmtf, fos);

                endTime = System.nanoTime();
                System.out.println(fileName + "\t" + (endTime - startTime) / 1000000000.0);
            } catch (Exception e) {
                System.out.println(fileName+ "\t" + "NA");
            }
        }
    }
}
