# Fiji macros
Macros for Fiji/ImageJ

## 1 - IN Cell Analyzer 2200 Manipulator

This macro generates colorized images, merged channels and create stacks from images acquired by the IN Cell Analyzer 2200 (Cytiva, USA).

### How to use it: 

1 - Download [this zip file](https://github.com/iuri-cv/fiji_macros/archive/refs/heads/main.zip) and extract the `IN_Cell_Analyzer_2200_Manipulator.ijm` file to the plugins' 
subfolder of Fiji main folder (`Fiji.app > plugins`). If Fiji is open, restart it. 

2 - Select `Plugins` > `IN Cell Analyzer 2200 Manipulator`. It will likely be one of the last options. Alternatively, you can search for the macro in Fiji's search bar and click 
`Run`.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%201.png?raw=true)

3 - Select the main folder where images are located. This macro will also run automatically on each and every subfolder located within this main folder.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%202.png?raw=true)

4 - Select number of channels acquired (2, 3 or 4) and click `OK`.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%203.png?raw=true)

5 - Next, you will select the order of channels in the stack with respect to the acquisition order. In this example, the acquisition order was DAPI (1) and FITC (2). 
If you want to keep that order in the stack you should type `1,2`. In this case I wanted to alter the order in the stack to FITC (1) and DAPI (2), so I typed `2,1`. Make sure to include a comma between the numbers. Next, you will atribute a color to each of the channels and the click `OK`.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%204.png?raw=true)

6 - The macro will start running. A log window will pop up and update after every file gets processed, showing the % of files already processed and an estimated time to process
all files.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%205.png?raw=true)

7 - After all files were processed, the log window will display the elapsed time. The processed images will be stored within the `manipulator_processed_images_folder` located within
every processed subfolder. 

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%206.png?raw=true)
![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%207.png?raw=true)

8 - Within every `manipulator_processed_images_folder` there will be three subfolders, named  `colorized`,  `merge` and  `stack`, which respectively stores colorized images, 
merged channels and stacks.

![Alt text](https://github.com/iuri-cv/fiji_macros/blob/main/tutorial%20-%208.png?raw=true)

### Citation: 

If you use this macro to generate data for a publication, please cite it by using the following link:
https://github.com/iuri-cv/fiji_macros/blob/main/IN_Cell_Analyzer_2200_Manipulator.ijm

### Contact: 

If you have any questions, suggestions or criticisms about this macro, please contact me at iuricv@gmail.com. Any feedback will be highly appreciated 😀


