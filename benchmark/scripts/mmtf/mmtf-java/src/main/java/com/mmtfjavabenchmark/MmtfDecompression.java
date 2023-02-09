package com.mmtfjavabenchmark;

// import PDBFileReader;
import org.biojava.nbio.structure.io.mmtf.MmtfActions;
import org.biojava.nbio.structure.Structure;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.FileOutputStream;

public class MmtfDecompression {

    public static void main(String[] args) {
        // Get args
        // args[0] = mode ("lossy" or "lossless")
        // args[1] = input directory that contains pdb files
        // args[2] = output directory that will contain mmtf files

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
            // Check if file is mmtf
            if (!fileExtension.equals("mmtf")) {
                continue;
            }
            String outputFileName = fileName.substring(0, fileName.lastIndexOf(".")) + ".pdb";
            Path outputFile = Paths.get(output.toString(), outputFileName);

            // Measure running time
            long endTime;
            long startTime = System.nanoTime();
            try {
                // Read PDB file to Structure object
                // File to Path
                Structure structure = MmtfActions.readFromFile(file.toPath());
                // Write Structure object to PDB file
                String pdbStr = structure.toPDB();
                // Write PDB file
                FileOutputStream fos = new FileOutputStream(outputFile.toFile());
                fos.write(pdbStr.getBytes());
                fos.close();

                endTime = System.nanoTime();
                System.out.println(fileName + "\t" + (endTime - startTime) / 1000000000.0);
            } catch (Exception e) {
                System.out.println(fileName+ "\t" + "NA");
            }
        }
    }
}
