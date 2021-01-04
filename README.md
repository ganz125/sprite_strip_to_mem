# sprite_strip_to_mem

<p>This tool coverts images files to a .MEM file that can be used in an FPGA design.  Some details:</p>

<ul>
 <li>Written in Matlab, therefore accepts pretty much any input (png, bmp, jpg, etc.)</li>
 <li>Output .MEM file is a text file with binary values for each pixel</li>
 <li>Reduces pixels down to using 64 colors, i.e. 2 bits each for R, G, and B components for a total of 6 bits/pixel</li>
 <li>Shows previews of original image and the resulting image using the 6 bit color map</li>
 <li>Output .MEM file tested with Altera Quartus Prime and Verilog using $readmemb() function to import data</li>
</ul>

<p align="center">
   Example of the image preview:
   <br> <br>
   <img src="example preview.PNG" height="300" align="center">
</p>
