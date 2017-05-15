name=getTitle();
dir = getDirectory("Choose Save Directory "); 
mouse=getString("Mouse?","Prismus");
sess=getNumber("Session number?", 1);
id=getNumber("Recording number?",2);
n=getNumber("Ref Slices", 71);
B4=getNumber("Stack B4?",56);
Aftr=getNumber("Stack Aftr?",112);
first=n-B4;
last=n+Aftr;
radius=6;
radius2=7;
Stacksize=B4+Aftr+1

run("Duplicate...", "duplicate range=first-last");
name=getTitle();
FIName="SNStack"+mouse+"-I"+id+"-GFP-S"+sess;
//FIName="I";
newImage(FIName, "16-bit black", 512, 512, Stacksize);
selectWindow(name);

run("Despeckle", "stack");
run("Bandpass Filter...", "filter_large=40 filter_small=5 suppress=None tolerance=5 process");


for (s = 1; s <= nSlices; s++) {
   selectWindow(name);
   //print(name);
   setSlice(s); 
   run("Clear Results");
   
   makeRectangle(10, 10, 492, 492);
   roiManager("Deselect");
   run("Find Maxima...", "noise=20 output=[Point Selection] exclude dark");
   roiManager("Add");
   getSelectionCoordinates(xpoints, ypoints);
   //roiManager("Select",0);
  // roiManager("Delete");
   j=1;
   //waitForUser("OK?");
   arrayInt = newArray("0");
   
   // This means that the array has a zero in front!!
   
   
   for (i=0; i<lengthOf(xpoints); i++) {
   	   run("Clear Results");
   	   selectWindow(name);
   	   setSlice(s); 
       makeOval(xpoints[i]-radius, ypoints[i]-radius, 2*radius, 2*radius);
       roiManager("Add");
        makeOval(xpoints[i]-radius2, ypoints[i]-radius2, 2*radius2, 2*radius2);
       roiManager("Add");
       roiManager("Select",roiManager("count")-1)
       run("Make Band...", "band=3");
       roiManager("Update");
       roiManager("Select", j);
       roiManager("Measure");
       roiManager("Select", j+1);
       roiManager("Measure");
       Signal=getResult("Mean",0);
       Noise=getResult("Mean",1);
       if (Noise<1){
       	Noise=1;
       }
       R=(Signal/Noise)*100;
       //print(R);

  		 if(R>=300){
   			//selectWindow(FIName);
 			//setSlice(s); 
  			//roiManager("Select",j);
 			//setColor(R); 
 			//fill();
 			arrayInt = Array.concat(arrayInt,R);
   			roiManager("Deselect");
   			roiManager("Select",j+1);
   			roiManager("Delete");
  		 	j=j+1;
   	
   	
 		  }else{
  		 	roiManager("Deselect");
   			roiManager("Select", newArray(j,j+1)); 
  		 	roiManager("Delete");
  		 	j=j;
   	
  		 }
     
     }

  if (arrayInt.length>1){
  // i=0 for ROI is all the points, while for array, is just a 0...
   for (i=1; i<roiManager("count"); i++) {
     	selectWindow(FIName);
 	    setSlice(s); 
 	    roiManager("Select", i);
 	    Rcell=arrayInt[i];
 	    //print(Rcell);
 	    setColor(Rcell); 
 		fill();
    }
  }
    wait(20);
  //waitForUser("OK?");
  //roiManager("Show All");

  array1 = newArray("0");
  for (i=0;i<roiManager("count");i++){
       array1 = Array.concat(array1,i);
       //Array.print(array1);
  }
  roiManager("Select", array1); 
  
  roiManager("Delete");
  roiManager("Deselect");
}
roiManager("Deselect");
selectWindow(FIName);
saveAs("Tiff",dir+"SNStack"+mouse+"-I"+id+"-GFP-S"+sess+".tif");