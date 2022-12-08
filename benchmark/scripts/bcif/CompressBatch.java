package org.rcsb.cif;

import org.rcsb.cif.model.CifFile;
import org.rcsb.cif.model.FloatColumn;
import org.rcsb.cif.schema.StandardSchemata;
import org.rcsb.cif.schema.mm.AtomSite;
import org.rcsb.cif.schema.mm.MmCifBlock;
import org.rcsb.cif.schema.mm.MmCifFile;

import java.io.IOException;
import java.net.URL;
import java.util.Optional;
import java.util.OptionalDouble;
import java.util.OptionalInt;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

public class CompressBatch {
    public static void main(String[] args) throws Exception {
        // Get args
        // args[0] = input directory that contains cif files
        // args[1] = output directory that will contain bcif files
        Path input = Paths.get(args[0]);
        Path output = Paths.get(args[1]);
        // Get all files in input directory
        File[] files = input.toFile().listFiles();
        // Loop through all files
        for (File file : files) {
            // Get file name
            String fileName = file.getName();
            // Get file extension
            String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
            String outputFileName = fileName.substring(0, fileName.lastIndexOf(".")) + ".bcif";
            // Check if file is a cif file
            if (fileExtension.equals("cif")) {
                // Get input file path
                Path inputFilePath = Paths.get(input.toString(), fileName);
                // Get output file path
                Path outputFilePath = Paths.get(output.toString(), outputFileName);
                // Measure running time
                long endTime;
                long startTime = System.nanoTime();
                // Handle exceptions
                try {
                    // Read cif file
                    CifFile cifFile = CifIO.readFromPath(inputFilePath);
                    // Write bcif file
                    CifIO.writeBinary(cifFile, outputFilePath);
                    endTime = System.nanoTime();
                    System.out.println(fileName + "\t" + (endTime - startTime) / 1000000000.0);
                } catch (Exception e) {
                    System.out.println(fileName+ "\t" + "NA");
                }
            }
        }
    }
}

