dir = getDirectory("Choose Save Directory "); 
mouse=getString("Mouse?","Prismus");
sess=getNumber("Number of Sessions?", 6);
id=getNumber("Recording number.part?",2.1);
run("Set Measurements...", "area mean standard min center limit nan redirect=None decimal=3");

for (sn=1; sn<=sess; sn++){
open(dir+mouse+"-I"+id+"-GFP-S"+sn+".tif");
name=mouse+"-I"+id+"-GFP-S"+sn+".tif";
run("Find Maxima...", "noise=0 output=[Point Selection] exclude dark");
roiManager("Add");
getSelectionCoordinates(xpoints, ypoints);
radius=5;

for (i=0; i<lengthOf(xpoints); i++) {
   	   run("Clear Results");
   	   selectWindow(name);
       makeOval(xpoints[i]-radius, ypoints[i]-radius, 2*radius, 2*radius);
       roiManager("Add");
}

Total=roiManager("count");

run("Select All");
roiManager("Measure");  
print("Session"+sn+": "+Total+"  fos+ cells detected");

array1 = newArray("0");;
  for (i=1;i<roiManager("count");i++){
       array1 = Array.concat(array1,i);
       //Array.print(array1);
  }
 
roiManager("select", array1); 
roiManager("Delete");

tablename=mouse+"-I"+id+"GFP-S"+sn;
saveAs("Results", dir+tablename+".txt");
selectWindow(name);
close(); 
}



//TdTomato:
  open(dir+mouse+"-I"+id+"-Tom-S1.tif");
  name=mouse+"-I"+id+"-Tom-S1.tif";
  run("Clear Results");
  run("Bandpass Filter...", "filter_large=60 filter_small=5 suppress=None tolerance=5");
  run("Measure");
  m=getResult("Mean",0);
  s=getResult("StdDev",0);
  max=getResult("Max",0);
  thr=m+1*s;
  call("ij.plugin.frame.ThresholdAdjuster.setMode", "Red");
  setAutoThreshold("Default dark");
  setThreshold(thr,max);
  run("Create Selection");
  run("Make Inverse");
  wait(20);
  roiManager("Add");
  resetThreshold();
  roiManager("Select", 0);
  roiManager("Measure");
  bg=getResult("Mean",1);
  bgsd=getResult("StdDev",1);
  roiManager("Select", 0);
  roiManager("Delete");
  roiManager("Show All");
  run("Clear Results");
  print(bg); 

  run("Find Maxima...", "noise=5 output=[Point Selection] exclude");
  roiManager("Add");
  getSelectionCoordinates(xpoints, ypoints);



  roiManager("Delete");
  number=lengthOf(xpoints);
  //print(number);

   radius=6;
   //radius2=12;
   j=0;
 
 
  for (i=0; i<lengthOf(xpoints); i++) {

     run("Clear Results");
     makeOval(xpoints[i]-radius, ypoints[i]-radius, 2*radius, 2*radius);
     roiManager("Add");
 
     roiManager("Deselect");
     roiManager("Select", j);
     roiManager("Measure");
     Cellmean=getResult("Mean",0);
   
     if (Cellmean>bg+2.1*bgsd) {
          roiManager("Deselect");
                  
          j=j+1;
         
      }else{
           roiManager("Deselect");
           roiManager("Select", j);
           roiManager("Delete");
         
           j=j;
       }
   }
  run("Clear Results");
  roiManager("Show All");

  A=getNumber("Need to select more? Y=1,N=2", 2);

  if (A<2){
    setTool("multipoint");
    waitForUser("Please select center points for all areas of interest. Click OK when done");
    roiManager("Add");
    nROIs = roiManager("count");
    roiManager("Select", nROIs-1);
     getSelectionCoordinates(xs, ys);

    for (i=0; i<lengthOf(xs); i++) {
        makeOval(xs[i]-radius, ys[i]-radius, 2*radius, 2*radius);
        roiManager("Add");
     }

  roiManager("Select", nROIs-1);
  roiManager("Delete");
  }

  Total=roiManager("count");

  run("Select All");
  roiManager("Measure");  
  print(number+" cells detected, among which, "+Total+" positive");
  run("From ROI Manager");
  
  array1 = newArray("0");;
  for (i=1;i<roiManager("count");i++){
       array1 = Array.concat(array1,i);
       //Array.print(array1);
  }
 
  roiManager("select", array1); 
  roiManager("Delete");
  tablename=mouse+"-I"+id+"Tom-S1";
  saveAs("Results", dir+tablename+".txt");
  selectWindow(name);
  close();