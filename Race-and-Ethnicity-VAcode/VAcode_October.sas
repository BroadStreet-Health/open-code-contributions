/*Code for October, 2020. Completed 1/18/21. Jessica Song*/
filename Wider 
		'C:\Users\16147\OneDrive - Kent State University\Kent State\Active Projects\BroadStreet_COVID\For SAS\October_Wide.xlsx';
proc import datafile=Wider 
out= Wider
dbms=xlsx
replace;
getnames=yes;
run; 

filename County 
		'C:\Users\16147\OneDrive - Kent State University\Kent State\Active Projects\BroadStreet_COVID\For SAS\Virginia_Proportions.xlsx';
proc import datafile=County 
out= County
dbms=xlsx
replace;
getnames=yes;
run;


proc sort data=wider; by Health_District; run;
proc contents data=wider; run; /*Check for number of days (variables go to 29 or 30?) 30 here.
									This will impact proc transpose code. Make sure it matches the full span of the variables*/


data wide; merge wider County; by Health_District;
if Health_District = "" then delete; run;


proc sort data=wide; by County_Name; run;


proc transpose data=wide out=longWhite prefix=White_Count;
by County_Name;
var White_Count White_Count_1-White_Count_30;
run; /*This code has all the counts for whites in each health district. Also has _LABEL_ & _NAME_*/

/*Repeating code for each Race/Ethnicity field*/
proc transpose data=wide out=longBlack prefix=Black_Count;
by County_Name;
var Black_Count Black_Count_1-Black_Count_30;
run;

proc transpose data=wide out=longAsian prefix=Asian_Count;
by County_Name;
var Asian_Count Asian_Count_1-Asian_Count_30;
run;

proc transpose data=wide out=longNative prefix=Native_Count;
by County_Name;
var Native_Count Native_Count_1-Native_Count_30;
run;

proc transpose data=wide out=longPacific prefix=Pacific_Count;
by County_Name;
var Pacific_Count Pacific_Count_1-Pacific_Count_30;
run;

proc transpose data=wide out=longTwoPlus prefix=TwoPlus_Count;
by County_Name;
var TwoPlus_Count TwoPlus_Count_1-TwoPlus_Count_30;
run;

proc transpose data=wide out=longOther prefix=Other_Count;
by County_Name;
var Other_Count Other_Count_1-Other_Count_30;
run;

proc transpose data=wide out=longUnk prefix=Unk_Count;
by County_Name;
var Unk_Count Unk_Count_1-Unk_Count_30;

run;proc transpose data=wide out=longHispanic prefix=Hispanic_Count;
by County_Name;
var Hispanic_Count Hispanic_Count_1-Hispanic_Count_30;
run;

proc transpose data=wide out=longNonHispanic prefix=NonHispanic_Count;
by County_Name;
var NonHispanic_Count NonHispanic_Count_1-NonHispanic_Count_30;
run;

proc transpose data=wide out=longUnspec prefix=Unspec_Count;
by County_Name;
var Unspec_Count Unspec_Count_1-Unspec_Count_30;
run;


/*Now, merging long datasets together and dropping variables that are unneeded*/

data long_Aug;
	merge longwhite (rename=(White_Count1=White_Count) drop=_name_ _label_) 
			longBlack (rename=(Black_Count1=Black_Count) drop=_name_ _label_) 
			longAsian (rename=(Asian_Count1=Asian_Count) drop=_name_ _label_) 
			longNative (rename=(Native_Count1=Native_Count) drop=_name_ _label_) 
			longPacific (rename=(Pacific_Count1=Pacific_Count) drop=_name_ _label_) 
			longTwoPlus (rename=(TwoPlus_Count1=TwoPlus_Count) drop=_name_ _label_) 
			longwhite (rename=(White_Count1=White_Count) drop=_name_ _label_) 
			longOther (rename=(Other_Count1=Other_Count) drop=_name_ _label_) 
			longUnk (rename=(Unk_Count1=Unk_Count) drop=_name_ _label_) 
			longHispanic (rename=(Hispanic_Count1=Hispanic_Count) drop=_name_ _label_) 
			longNonHispanic (rename=(NonHispanic_Count1=NonHispanic_Count) drop=_name_ _label_) 
			longUnspec (rename=(Unspec_Count1=Unspec_Count) drop= _label_);
	by County_Name;
		If _name_ = "Unspec_Count" then Day = 1;
		If _name_ = "Unspec_Count_1" then Day = 2;
		If _name_ = "Unspec_Count_2" then Day = 3;
		If _name_ = "Unspec_Count_3" then Day = 4;
		If _name_ = "Unspec_Count_4" then Day = 5;
		If _name_ = "Unspec_Count_5" then Day = 6;
		If _name_ = "Unspec_Count_6" then Day = 7;
		If _name_ = "Unspec_Count_7" then Day = 8;
		If _name_ = "Unspec_Count_8" then Day = 9;
		If _name_ = "Unspec_Count_9" then Day = 10;
		If _name_ = "Unspec_Count_10" then Day = 11;
		If _name_ = "Unspec_Count_11" then Day = 12;
		If _name_ = "Unspec_Count_12" then Day = 13;
		If _name_ = "Unspec_Count_13" then Day = 14;
		If _name_ = "Unspec_Count_14" then Day = 15;
		If _name_ = "Unspec_Count_15" then Day = 16;
		If _name_ = "Unspec_Count_16" then Day = 17;
		If _name_ = "Unspec_Count_17" then Day = 18;
		If _name_ = "Unspec_Count_18" then Day = 19;
		If _name_ = "Unspec_Count_19" then Day = 20;
		If _name_ = "Unspec_Count_20" then Day = 21;
		If _name_ = "Unspec_Count_21" then Day = 22;
		If _name_ = "Unspec_Count_22" then Day = 23;
		If _name_ = "Unspec_Count_23" then Day = 24;
		If _name_ = "Unspec_Count_24" then Day = 25;
		If _name_ = "Unspec_Count_25" then Day = 26;
		If _name_ = "Unspec_Count_26" then Day = 27;
		If _name_ = "Unspec_Count_27" then Day = 28;
		If _name_ = "Unspec_Count_28" then Day = 29;
		If _name_ = "Unspec_Count_29" then Day = 30;
		If _name_ = "Unspec_Count_30" then Day = 31;
   drop _name_;
	run;

	proc contents data=long_aug order=varnum; run;/*Which are character variables? Must change below.
										Pacific, NonHispanic, Unspec*/

data long_aug1; set long_aug;
If Pacific_Count = "-" then Pacific_Count="";/*May need this code if the cells aren't all blank*/
If NonHispanic_Count = "-" then NonHispanic_Count="";
If Unspec_Count = "-" then Unspec_Count="";
Pacific_Count1 = input(Pacific_Count, 8.);
   drop Pacific_Count;
   rename Pacific_Count1=Pacific_Count;
NonHispanic_Count1 = input(NonHispanic_Count, 8.);
   drop NonHispanic_Count;
   rename NonHispanic_Count1=NonHispanic_Count;
Unspec_Count1 = input(Unspec_Count, 8.);
   drop Unspec_Count;
   rename Unspec_Count1=Unspec_Count;
run;

proc contents data=long_aug1; run;/*Fixed. All are numeric now*/

/*Now that this is long, I need to clean and import the proportions worksheet and then do some math*/
proc sort data = County; by County_Name; run;

data final; merge County (drop=Health_District) long_aug1; by County_Name; 
White = round(White_Prop*White_Count, 1); 
Black = round(Black_Prop*Black_Count, 1); 
Asian = round(Asian_Prop*Asian_Count, 1); 
Native = round(Native_Prop*Native_Count, 1); 
Pacific = round(Pacific_Prop*Pacific_Count, 1); 
Other = round(Other_Prop*Other_Count, 1); 
TwoPlus = round(TwoPlus_Prop*TwoPlus_Count, 1); 
Hispanic = round(Hispanic_Prop*Hispanic_Count, 1); 
NonHispanic = round(NonHispanic_Prop*NonHispanic_Count, 1); 

drop White_Prop Black_Prop Asian_Prop Native_Prop Pacific_Prop Other_Prop TwoPlus_Prop Hispanic_Prop NonHispanic_Prop
		White_Count Black_Count Asian_Count Native_Count Pacific_Count Other_Count TwoPlus_Count Hispanic_Count NonHispanic_Count 
		Unspec_Count Unk_Count; /*We lose all data on unspecified ethnicity and unknown race when doing it this way*/
run;

/*Exporting*/

PROC EXPORT DATA= WORK.final
            OUTFILE= 'C:\Users\16147\OneDrive - Kent State University\Kent State\Active Projects\BroadStreet_COVID\Final Products\October.xlsx'
            DBMS=EXCEL REPLACE; 
RUN;
