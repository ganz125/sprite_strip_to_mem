%  ------------------------------------------------------------------------------
%
%  sprite_strip_to_mem -- converts images to .mem file for FPGAs
%
%  Copyright (C) 2020 Michael Gansler
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%  ------------------------------------------------------------------------------
%
%  Module:       sprite_strip_to_mem.v
%
%  This is a tool that coverts images files to a .MEM file that can be 
%  used in an FPGA design. Some details:
%
%  - Since it's written in Matlab, it accepts pretty much any input 
%   (png, bmp, jpg, etc)
%  - output .MEM file is a text file with binary values for each pixel.
%  - Reduces down to 64 colors, i.e. 2 bits each for R, G, and B 
%    components for a total of 6 bits/pixel
%  - Shows previews of original image and the resulting image using the 
%    6 bit color map
%  - Resulting .mem file tested with Altera Quartus Prime and Verilog 
%    using $readmemb() function to import data
%
% I made this to support a project requiring sprites for an FPGA-based 
% 80's retro video game, so the tool is pretty primitive and just gets 
% the job done without anything snazzy.
%

%%
% close all figures
close all    

% clear all variables in workspace
clear        

%%
%  Change filesnames below
%

% read in image
I=imread('..\graphics\alexs ships 2.png');

% 1/0 for whether to write output .mem file
write_output_file = 1;

% ouput filename
if (write_output_file==1)
    fid = fopen('alexs ships 2.mem','w');
end

%%
% Rescale image to doubles, with each pixel a floating point value 
% between 0 and 1.  Helps deal with Matlab fixed pont type headaches.
%
I=im2double(I);   

%%

% create image with only RED content
R_orig=I;
R_orig(:,:,2)=0;
R_orig(:,:,3)=0;

% create image with only GREEN content
G_orig=I;
G_orig(:,:,1)=0;
G_orig(:,:,3)=0;

% create image with only BLUE content
B_orig=I;
B_orig(:,:,1)=0;
B_orig(:,:,2)=0;

%%
% Reduce to 6 bits/pixel, 2 for each color
%

R_64 = floor(R_orig*255/64);
G_64 = floor(G_orig*255/64);
B_64 = floor(B_orig*255/64);

I_64 = floor(I*255/64);

% Create side by side image, for user review, containing:
% - original image
% - image, reduced to 64 colors
% - R, G, and B content for original and 64 color images

composite = [I I_64 R_orig R_64 G_orig G_64 B_orig B_64];

% display image 
image(composite);
axis image
set(gca,'xtick',0)
set(gca,'ytick',0)


%%

im = I_64;

if (write_output_file==1)

    fprintf(1,'Writing output file.\n');
    
    for row=1:size(I,1)        % # of rows
    
        for col=1:size(I,2)    % of columns

           r = im(row,col,1);
           g = im(row,col,2);
           b = im(row,col,3);

           fprintf(fid,'%s%s%s ', print2bits(r), ...
                                  print2bits(g), ...
                                  print2bits(b) );

        end

        fprintf(fid,'\n');

    end
    
    fclose(fid);

    fprintf(1,'Done.\n');
    
end

%%
%
% Returns string with 2 bit value, with preceding zero if needed
%
function [s] = print2bits(x)

    switch x
        case 0 
            s='00';
        case 1
            s='01';
        case 2
            s='10';
        case 3
            s='11';
        otherwise
            s='ERROR';
    end
    
end
