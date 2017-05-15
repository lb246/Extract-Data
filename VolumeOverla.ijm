dir = getDirectory("Choose Save Directory "); 
mouse=getString("Which mouse?","Prismus");
id=getNumber("Which recording id?",2);
NewName="SNStack"+mouse+"-I"+id+"-Tom-S";

waitForUser("Open all tdTomato pics");
sess=getNumber("Number of sessions?",6);
Names = newArray("0");
Slices = newArray("0");
Ref= newArray("0");

for (i=1; i<=sess; i++) {
	waitForUser("Select Session "+i);
	n=getTitle();
	s=nSlices;
	Names = Array.concat(Names,n);
	Slices = Array.concat(Slices,s);
	
}

waitForUser("Find an interneuron present in each stack");


for (i=1; i<=sess; i++) {
	ref=getNumber("Ref slice for Session "+i, 50);
	Ref=Array.concat(Ref,ref);
	st=ref-1;
	if (i<2){
		B4=st;
	}else{
		if (st<B4){
			B4=st;
		}
	}

	nd=Slices[i]-ref;
    if (i<2){
		Aftr=nd;
	}else{
		if (nd<Aftr){
			Aftr=nd;
		}
	}
	
}
print("B4="+B4);
print("Aftr="+Aftr);

for (i=1; i<=sess; i++) {
	selectWindow(Names[i]);
	first=Ref[i]-B4;
	last=Ref[i]+Aftr;
	run("Duplicate...", "duplicate range=first-last");
	saveAs("Tiff", dir+NewName+i+".tif");
	close();
	
}
