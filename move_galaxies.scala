/**
  * This script "moves" the images of the galaxies based on its morphology type.
  * 
  * Before using this script, the images must be in the "path" that is declared 
  * inside the main, and the .tsv file containing the morphology of the 
  * galaxies must be in the "tsv_file" path inside the getmapFromTSV
  * 
  * 
  */

import java.io.File
import scala.io.Source

object main{
    def isComment(line: String): Boolean = line.startsWith("#")
    def isGalaxyImage(name: String): Boolean = name.startsWith("PGC")
	
    // get the map: galaxy name -> galaxy type
    def getMapFromTSV: Map[String, String] = {
        var map = Map[String, String]()
        val tsv_file = "DL/data.tsv"
		
		// read the file
        for (line <- Source.fromFile(tsv_file).getLines if !isComment(line)) {
			// split the line based on multiple spaces
            val lineSplitted = line.split(" +")

			// the first one is the image name and the eleventh is the type
            map += (lineSplitted(0) -> lineSplitted(11))
        }
        map
    }
	
	// these functions returns true if the galaxy is of that type
    def isBarredSpiral(s: String): Boolean = s.startsWith("SB")
    def isSpiral(s:String): Boolean = s.startsWith("S")
    def isSpiralNotBarred(s:String): Boolean = !isBarredSpiral(s) && s.startsWith("S")
    def isElliptical(s:String): Boolean = s.startsWith("E") || isS0(s)
	def isS0(s:String): Boolean = s.contains("0") || s.contains("O")
	
	// returns the file name with no extension	
	def nameNoExtension(s:String): String = s.split('.')(0)
	
    def main(args: Array[String]) {
        println("move_galaxies")

        val map = getMapFromTSV
        val path = "DL/galaxies/splitted/filtered_cropped/"
        val folder = new File(path)


        if (folder.exists && folder.isDirectory){
            val n = folder.listFiles().toList.length

			// create the subfolders
            new File(path + "elliptic").mkdir()
            new File(path + "irregular").mkdir()
            new File(path + "spiral").mkdir()
            
            println("starting...")

			// for each file in the directory
            for (file <- folder.listFiles().toList if isGalaxyImage(file.getName)){

				// if the galaxy is of that type
				if (isElliptical(map(nameNoExtension(file.getName)))) 
					// move it to the subfolder by simply renaming the file
                    file.renameTo(new File(path + "/elliptic/" + file.getName))
                    
                else if (isSpiral(map(nameNoExtension(file.getName)))) 
                    file.renameTo(new File(path + "/spiral/" + file.getName))
                
                else 
                    file.renameTo(new File(path + "/irregular/" + file.getName))
                
            }
            println("...galaxies moved")
        }
    }
}
