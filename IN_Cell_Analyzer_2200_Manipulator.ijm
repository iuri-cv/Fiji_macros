// IN Cell Analyzer 2200 Manipulator 
// Wrote by: Iuri Cordeiro Valadão (PhD in Sciences, University of São Paulo, Brazil) 
// Last update: 29/03/2021
// @ CONFOCAL Facility (CEFAP-University of São Paulo, Brazil)
// Have any questions, suggestions, criticism ? Contact me at iuricv@gmail.com. Your feedback would be highly appreciated :) 
// ATTENTION: Please cite this macro if you use it to generate data for publications. 

//Defining global variables
var tiffsum; //gets current sum of processed tiff files
var finalname; //gets final name for saved files  
var sliceLabels; //gets slice's label 

macro "IN Cell Analyzer 2200 Manipulator" {
dir = getDirectory("Choose an input directory");  
setBatchMode(true);

//Gets number and color of channels and order of channels in stack.     
     Dialog.create("IN Cell - image manipulator");
     itens = newArray("2", "3", "4");
     Dialog.addRadioButtonGroup("Number of channels", itens, 1, 3, 2);
     Dialog.show();
     nchannels = parseInt(Dialog.getRadioButton());
     Dialog.create("IN Cell - image manipulator");
     Dialog.addMessage("Please reorder the channels if desired order is different from acquisition order." +"Example:\n"+"Acquisition order --> DAPI(1) - Cy3(2) - FITC(3)\n" +"New order --> Cy3(2) - FITC(3) - DAPI(1)");
     Dialog.addString("Sequence order (ex. 1,2,3):", "");
     Dialog.addMessage("ps.: Numerical order (1,2,3...) is the acquisition order\n"
     +"Make sure to include commas between the numbers");
     itens = newArray("Red", "Green", "Blue", "Cyan", "Magenta", "Yellow", "Grays");
     for (i = 0; i < nchannels; i++) {
     Dialog.addRadioButtonGroup("Color of channel "+i+1+"", itens, 1, 7, 1);
     }
     Dialog.show();
     colorArr = newArray(nchannels);
     for (i = 0; i<nchannels; i++) {
         colorArr[i] = Dialog.getRadioButton();
         }
     start = getTime(); 
     order=Dialog.getString();
  print("\\Clear");

//Determines local variables
tiflist = newArray;
counter = 0;
tifftotal = 0; 

countTotalTif(dir); //count total number of tiff files within folders and subfolders
listFiles(dir); //count total number of tiff files within each subfolder
 
//Import image sequence according infos provided by user in dialog boxes    
 function processtif(dir, tiflist) {
 	outputfolders = newArray("manipulator_processed_images", "stack", "merge", "colorized");
 	generateOutputFolders(outputfolders); //generate output folders to store process data
	for (t = 0; t < tiflist.length; t=t+nchannels) {
		run("Image Sequence...", "open=["+dir+"] number="+nchannels+" starting="+t+1+"");
		if (nSlices/nchannels != parseInt(nSlices/nchannels)) {exit("Error: uneven number of stacks. Please check whether your number of images and channels are really "+counter+" and "+nchannels+", respectively")}
   	generateFinalName(dir,tiflist[t]); //generate final name for files to be saved
	generateAndSaveStack(); 
	generateAndSaveMerge();	
	generateAndSaveColor();
	updateLogWindow(); //updates log window with % of processed files and estimated remaining time to complete running of macro   
	}
 }

//Finishes macro and display running its running time  
print("Finished macro. Please check for results within\nmanipulator_processed_images folder, inside each\nsubfolder of main folder.");
print ("Macro execution time: " + (((getTime()-start)/1000)/60) + " minutes");

//----------Associated functions-----------//

function countTotalTif(dir) {
	list = getFileList(dir);
		for (i=0; i<list.length; i++) {
			if (endsWith(list[i], "/") && matches(list[i], ".*Results.*") == false && matches(list[i], ".*thumbs.*") == false)
           		countTotalTif(""+dir+list[i]);
	        else if ( endsWith(list[i], "tif")) {
	        	tifftotal++;
	        	countTotalTif(""+dir+list[i]);
	        }	
		}
	}

function listFiles(dir) {
	list = getFileList(dir);
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "/") && matches(list[i], ".*Results.*") == false && matches(list[i], ".*thumbs.*") == false)
      	listFiles(""+dir+list[i]);
	    else counter=0;   }
  	for (i=0; i<list.length; i++)        
    	if ( endsWith(list[i], "tif")) 
  		counter++;
		tiflist = newArray(counter);
		counter = 0;
	for (i=0; i<list.length; i++) {          
    	if  (endsWith(list[i], "tif")) {
    		tiflist[counter] = list[i];
    		counter++;
    	} }
   	if (lengthOf(tiflist) > 0) {
		processtif(dir, tiflist);   	  
   }}

function generateOutputFolders(outputfolders) {
	for (i = 0; i<lengthOf(outputfolders); i++) {
		if (matches(outputfolders[i], ".*manipulator_processed_images.*")) {
			outputfolders[i] = dir + outputfolders[i] + File.separator;
			File.makeDirectory(outputfolders[i]); 
		}
		else {
			outputfolders[i] = outputfolders[0] + outputfolders[i] + File.separator;
			File.makeDirectory(outputfolders[i]);
			}
		}
		return outputfolders;
	}

function generateFinalName(dir,file) {
	filename=dir+file;
  	startindex=lastIndexOf(filename, "/");
	finalindex=lastIndexOf(filename, "w");
	basename=substring(filename, startindex+1, finalindex-1);
 	finalname=basename+")";
	return finalname;	
}

function generateAndSaveStack() {		
	run("Make Substack...",   "slices=" + order);
	sliceLabels=newArray(nSlices);
	for (f = 0; f<nSlices; f++) {
		setSlice(f+1);
		sliceLabels[f]=getInfo("slice.label");
		}		
	run("Make Composite", "display=Color");
	for (i = 0; i<lengthOf(colorArr); i++) {
	  Stack.setChannel(i+1);
	  run(colorArr[i]);
	  }
	run("RGB Color");
	saveAs("Tiff", outputfolders[1] + finalname);
	return sliceLabels;
}

function generateAndSaveMerge() {		
	close();
	run("Duplicate...", "duplicate");
	run("Make Composite");
	run("RGB Color");
	saveAs("Tiff", outputfolders[2] + finalname);
}

function generateAndSaveColor() {
	selectWindow("Substack ("+order+")");
	close("\\Others");
	run("Split Channels");
	images=newArray(nImages);
	Array.reverse(sliceLabels);
	for (ni = 0; ni<lengthOf(images); ni++) {
	rename(sliceLabels[ni]);
	saveAs("Tiff", outputfolders[3] + getTitle() + ".tif");
	close();
	}
	run("Close All");
}

function updateLogWindow() {
	print("\\Clear");
	tiffsum = tiffsum + nchannels;
	remainingTime = (((((getTime()-start)/tiffsum)*(tifftotal-tiffsum))/1000)/60);
	print("\\Update:Processed files: "+((tiffsum)/tifftotal)*100+"%"+". Remaining time: " + remainingTime + " minutes");
	return tiffsum;
	}
}