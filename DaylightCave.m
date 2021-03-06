%% Temperature Calibration
% This section calibrates the data obtained from the BOM from the Kempsey AWS with the existing surface AWS temperature data.
%% Visualise the raw data
figure('Name','Overlap of raw data');
scatter(DateTime,KAWSAirTemp,'.','r');
hold on
scatter(DateTime,SAWSAirTemp,'.','b');
hold off
 
%% 1. Determine the difference between the two datasets. This can be used to cross check part 2
%Isolate the overlap period
Kover=KAWSAirTemp([86534:105313]);
Sover=SAWSAirTemp([86534:105313]);
 
% Determine the difference between the two datasets
diff = Sover-Kover;
 
% Represent this difference visually
timecrop = DateTime([86534:105313]);
 
figure('Name','Variance between surface temperature at the cave and Kempsey');
scatter(timecrop,diff,'.');
 
%Find the mean difference between datasets by removing all NaN values (from 15 min intervals)
meandiff = nanmean(diff);
 
%find the standard deviation of the difference between datasets:
stddiff = nanstd(diff);
 
%Determine if this mean is statistically significant using a one sample
%t-test:
[h,p,ci,stats] = ttest(diff)
 
% Using a ztest (because we know the stddev, and n>30)to test if 0.3348 is
% the mean difference
[h,p,ci,zval] = ztest(diff,meandiff,stddiff)
 
%% 2. Determine the mean of each dataset and then determine the statistical significance
 
% Isolate the overlap period
Kover=KAWSAirTemp([86534:105313]);
Sover=SAWSAirTemp([86534:105313]);
 
% Determine the mean of each
xk=nanmean(Kover);
xs=nanmean(Sover);
 
% Determine the standard deviation of each
stdevk = nanstd(Kover);
stdevs = nanstd(Sover);
 
% Determine the variance of each
vark = nanvar(Kover);
vars = nanvar(Sover);
 
% Perform a two tailed t-test to determine if there is a statistically
% significant difference between the two datasets, and determine the 95% confidence interval of the true mean difference between datasets:
[h,p,ci,stats] = ttest2(Sover,Kover)
 
% yes, there is a statistically significant difference with a 95%CI =
% [-0.593,-0.16030] 
% therefore we must subtract 0.3348 from the BOM dataset to calibrate it to
% the existing cave surface dataset.
 
%% Adjust BOM data
% Calibrate the data by subtracting the statistical mean difference from
% the BOM dataset.
KAWSTad = KAWSAirTemp-0.3348;
 
% isualise the effects of the calibration
Kadj = KAWSTad([86534:105313]);
diffnew = Sover-Kadj;
 
figure('Name','Calibration of kempsey data with cave surface data');
subplot(1,2,1);
scatter(timecrop,diff,'.');
xlabel('Date');
ylabel('Difference in original dataset');
title('Original data')
subplot(1,2,2);
scatter(timecrop,diffnew,'.');
xlabel('Date');
ylabel('Difference in adjusted dataset');
title('Adjusted data')
 
 
% Add the calibrated Kempsey data to the surface weather station data to
% create a new surface vector. 
Kcutadj = KAWSTad([1:86533]);
Scutadj = SAWSAirTemp([86534:end]);
SAWSAirTemp1 = [Kcutadj;Scutadj];
 
% Visualise compiled dataset
figure('Name','Calibrated and compiled data');
scatter(DateTime,SAWSAirTemp1,'.');
% change existing .mfies to use this consolidated surface temp vector. 

%% sections will go as follows:
 
%   1. Advection by Water
%   2. Advection by Air
%   3. Conduction
%   4. Other contextual figures and analyses

%BOM.Calibration must be run first!
 
%% Advection by Water
 
%   Part A - Rainfall and Drip Rate
%            This part shows that the cave responds immediately to
%            rainfall, thus indicating that it is controlled by conduit
%            flows.
% Make a single chart with 3 subplots that show:
    % 1. All data overview
    % 2. Rainfall and drips (Log)
    % 3. Drips (Log) and Temperature 
 
% Isolate the variables to consist of the shortest dataset that we have. 
Dec_20 = 174065;
April_21 = 186368;
DateDec20toApr21= DateTime([Dec_20:April_21]);
RainCrop = Rainfall([Dec_20:April_21]);
Dr1DectoApr = Stalagmate640694([Dec_20:April_21]);
Dr2DectoApr = Stalagmate647785([Dec_20:April_21]);
 
% Create the figure Rainfall vs Drip rate
figure('Name','Effects of Rainfall on drip rate')
 
yyaxis left
area(DateDec20toApr21,RainCrop,'DisplayName','Rainfall')
hold on
 
yyaxis right
scatter(DateDec20toApr21,log10(Dr1DectoApr),'.','o');
scatter(DateDec20toApr21,log10(Dr2DectoApr),'.','b');
hold off
grid
 
%   Part B - Drip rate and temperature
%            This part shows that hydrological activity in the cave will
%            induce temperature changes. Therefore indicating that rainfall
%            would cause temperature changes.
 
% Define the end of the data input
Dec_21 = 209580;
DectoDec = DateTime([Dec_20:Dec_21]);
Dr1 = Stalagmate640694([Dec_20:Dec_21]);
Dr2 = Stalagmate647785([Dec_20:Dec_21]);
SolinstCrop = SolinstTemp([Dec_20:Dec_21]);
IntegratedRain = Rainfall([Dec_20:Dec_21]);
 
%Create the figure
figure('Name','Do maximum drip rates increase lower chamber temeperature?');
 
yyaxis left
area(DectoDec,IntegratedRain);
addaxis(DectoDec,Dr1);
hold on
plot(DectoDec,Dr2);
hold off
 
yyaxis right
scatter(DectoDec,SolinstCrop,'.');
 
%   Part C - Rainfall and temperature
%            This part shows that rainfall induced hydrological activity
%            that causes an increase in temperature within the cave.
 
% First define the start and end of the dataset:
June_18 = 86536;
July_16 = 20364;
 
% Crop vectors:
July16toApril21 = DateTime([July_16:April_21]);
SolinstTotalAT = SolinstTemp([July_16:April_21]);
RainfallTotalAT = Rainfall([July_16:April_21]);
KempseyAWS = KAWSRainfall([July_16:April_21]);
 
% Create the figure:
figure('Name','Effects of Precipitation on Cave Temperature of entire study');
 
yyaxis left
area(July16toApril21,RainfallTotalAT,'DisplayName','Precipitation');
hold on
area(July16toApril21,KempseyAWS,'DisplayName','Precipitation');
 
yyaxis right
scatter(July16toApril21, SolinstTotalAT,'.');
hold off
grid 
 
%       Part C - Winter and summer means post fire
 
% Plot all the Solinst Data
 figure ('Name','All Solinst Data');
scatter(DateTime,SolinstTemp,'.')

%% Section 2 ??? Ventilation
% Isolate Weekly data after fire event
% Add BOM data to the table:
    % Remove two empty rows at the start of the table
AllData([1,2],:)=[];
size(AllData);
 
% Add combined surface temp as new column to table
AllData.SAWSAirTemp1 = SAWSAirTemp1;
 
% Convert to timetable
Data = table2timetable(AllData);
 
% Make a row for ventilation. If Ventilation is positive, the cave is
% breathing.
Data.Ventilation = Data.UCAWSAirtemp - Data.SAWSAirTemp1;
 
% The total number of times that the cave ever ventilates
sum(Data.Ventilation >0);
 
%% Compare the week after the fire (pre and post fire)
% Extract the data for the week after the fire 2019
WA19 = Data(132927:133599,{'UCAWSAirtemp', 'SAWSAirTemp1', 'Ventilation'});
 
% Extract the data for the week after the fire 2018
WA18 = Data(97888:98560,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2017
WA17 = Data(62847:63519,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2016
WA16 = Data(27807:28479,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% calculate the average hours per day that the cave vents for each year:
% 2019
WAvent19 = (0.25/7)*sum(WA19.Ventilation >0);
 
% 2018
WAvent18 = (0.25/7)*sum(WA18.Ventilation >0);
 
% 2017
WAvent17 = (0.25/7)*sum(WA17.Ventilation >0);
 
% 2016
WAvent16 = (0.25/7)*sum(WA16.Ventilation >0);
 
%% Compare the week before and after the fire 2019 and 2018
% Extract the data for the week before the fire in 2019
WB19 = Data(132255:132927,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week before fire in 2018
WB18 = Data(97216:97888,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week before fire in 2017
WB17 = Data(62175:62847,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week before fire in 2016
WB16 = Data(27135:27806,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% calculate the average hours per day that the cave vents for each year:
% 2019
WBvent19 = (0.25/7)*sum(WB19.Ventilation >0);
 
% 2018
WBvent18 = (0.25/7)*sum(WB18.Ventilation >0);
 
% 2017
WBvent17 = (0.25/7)*sum(WB17.Ventilation >0);
 
% 2016
WBvent16 = (0.25/7)*sum(WB16.Ventilation >0);
 
%% Repeat above on a monthly scale
% Compare the month after the fire (pre and post fire)
% Extract the data for the month after the fire 2019
MA19 = Data(132927:135903,{'UCAWSAirtemp', 'SAWSAirTemp1', 'Ventilation'});
 
% Extract the data for the week after the fire 2018
MA18 = Data(97888:100864,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2017
MA17 = Data(62847:65823,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2017
MA16 = Data(27807:30783,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% calculate the hours/day that the cave vented in the month after 
% up to the fire dates in each year:
% 2019
MAvent19 = (0.25/31)*sum(MA19.Ventilation >0);
 
% 2018
MAvent18 = (0.25/31)*sum(MA18.Ventilation >0);
 
% 2017
MAvent17 = (0.25/31)*sum(MA17.Ventilation >0);
 
% 2016
MAvent16 = (0.25/31)*sum(MA16.Ventilation >0);
 
%% Compare the month before the fire (pre and post fire)
% Extract the data for the month after the fire 2019
MB19 = Data(130047:132927,{'UCAWSAirtemp', 'SAWSAirTemp1', 'Ventilation'});
 
% Extract the data for the week after the fire 2018
MB18 = Data(95008:97888,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2017
MB17 = Data(59967:62847,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% Extract the data for the week after the fire 2017
MB16 = Data(24927:27807,{'UCAWSAirtemp', 'SAWSAirTemp1','Ventilation'});
 
% calculate the hours/day that the cave vented in the month leading 
% up to the fire dates in each year:
% 2019
MBvent19 = (0.25/30)*(sum(MB19.Ventilation >0));
 
% 2018
MBvent18 = (0.25/30)*(sum(MB18.Ventilation >0));
 
% 2017
MBvent17 = (0.25/30)*(sum(MB17.Ventilation >0));
 
% 2016
MBvent16 = (0.25/30)*(sum(MB16.Ventilation >0));
 
%% Plot in a bar chart comparing monthly ventilation pre and post fire dates:
% Make a matrix of the montly ventilation results
 MPD= [MBvent16,MBvent17,MBvent18,MBvent19;MAvent16,MAvent17,MAvent18,MAvent19];
 
% Create figure
figure1 = figure;
 
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
 
% Create multiple lines using matrix input to bar
bar1 = bar(MPD,'Parent',axes1);
set(bar1(1),'DisplayName','2016');
set(bar1(2),'DisplayName','2017');
set(bar1(3),'DisplayName','2018');
set(bar1(4),'DisplayName','2019');
 
% Create ylabel
ylabel({'Daily Ventilation (hours/day)'});
 
% Create xlabel
xlabel({'Relationship to Fire Date'});
box(axes1,'on');
hold(axes1,'off');
 
% Create Title
title({'1 Month Impact of Fire on Daylight Cave'});
 
% Set the remaining axes properties
set(axes1,'XTick',[1 2],'XTickLabel',...
    {'Month before October 16th','Month after October 16th'});
 
% Create Legend
legend(axes1,'show');
 
%% Plot in a bar chart comparing weekly ventilation pre and post fire dates:
% Make a matrix of the montly ventilation results
 WPD =[WBvent16,WBvent17,WBvent18,WBvent19;WAvent16,WAvent17,WAvent18,WAvent19];
 
% Create figure
figure1 = figure;
 
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
 
% Create multiple lines using matrix input to bar
bar1 = bar(WPD,'Parent',axes1);
set(bar1(1),'DisplayName','2016');
set(bar1(2),'DisplayName','2017');
set(bar1(3),'DisplayName','2018');
set(bar1(4),'DisplayName','2019');
 
% Create ylabel
ylabel({'Daily Ventilation (hours/day)'});
 
% Create xlabel
xlabel({'Relationship to Fire Date'});
box(axes1,'on');
hold(axes1,'off');
 
% Create Title
title({'1 Week Impact of Fire on Daylight Cave'});
 
% Set the remaining axes properties
set(axes1,'XTick',[1 2],'XTickLabel',...
    {'Week Before October 16th','Week After October 16th'});
 
% Create Legend
legend(axes1,'show');
 
%% Determine the Statistical Significance  
%Make a 2 column matrix with all week data
    %remove NAN values
  w16 = WA16.Ventilation(~isnan(WA16.Ventilation));
  w17 = WA17.Ventilation(~isnan(WA17.Ventilation));
  w18 = WA18.Ventilation;
  w19 = WA19.Ventilation;
  %Create a matrix of ones for the group of each year
  w16g = ones([(size(w16)) 1]);
  w17g = ones([(size(w16)) 1]);
  w18g = ones([(size(w18)) 1]);
  w19g = 2*ones([(size(w19)) 1]); 
  
  %Create the input matrix for the Welch's test
  Before = [w16; w17; w18];
  Bsize = [w16g; w17g; w18g];
  wAfter = [Before Bsize; w19 w19g];
  Wtest(wAfter)
  
          %Month Stats
  m16 = MA16.Ventilation(~isnan(MA16.Ventilation));
  m17 = MA17.Ventilation(~isnan(MA17.Ventilation));
  m18 = MA18.Ventilation;
  m19 = MA19.Ventilation;
  %Create a matrix of ones for the group of each year
  m16g = ones([(size(m16)) 1]);
  m17g = ones([(size(m17)) 1]);
  m18g = ones([(size(m18)) 1]);
  m19g = 2*ones([(size(m19)) 1]);
  
  %Create the input matrix for the Welch's test
  mAfter = [m16 m16g;m17 m17g;m18 m18g;m19 m19g];
  Wtest(mAfter)
  
%% Section 3  - Conduction
% Determine the lag between the surface and cave temperature and the
% amplitude dampening
 
%       Change format of DateTime as a number category
DateNum = datenum(DateTime);
weights = ones([214055,1]);
 
    % After this point we use the curve fitting toolbox to do a Fourier
    % transform on the surface (n=8) and lower chamber (n=5) data. We name the objects SurfFit and LCRegress as cfit files respectively.
    % The following code uses the generated cfit files.
    
    % Define and Plot Surface 
    SurfRegress = SurfFit(SAWSAirTemp1);
    plot(SurfFit,DateNum,SAWSAirTemp1);
    
    % Find maximas and minimas of lower chamber
    % Differentiate regression function
       SurfDiff =@(x)differentiate(SurfFit,x);
   
    % Regression graph to define segments    
    smax1 = [736667 736851];
    smin1 = [736851 737033];
    smax2 = [737033 737216];
    smin2 = [737216 737400];
    smax3 = [737400 737574];
    smin3 = [737574 737757];
    smax4 = [737757 737932];
    smin4 = [737932 738111];
    smax5 = [738111 738327];
  
   
   Surfmin1 = fzero(SurfDiff,smin1);     
   Surfmin2 = fzero(SurfDiff,smin2);
   Surfmin3 = fzero(SurfDiff,smin3);
   Surfmin4 = fzero(SurfDiff,smin4);
   
   Surfmax1 = fzero(SurfDiff,smax1);
   Surfmax2 = fzero(SurfDiff,smax2);
   Surfmax3 = fzero(SurfDiff,smax3);
   Surfmax4 = fzero(SurfDiff,smax4);
   Surfmax5 = fzero(SurfDiff,smax5);
    
    % Define and Plot Lower Chamber  
    SolinstRegress = LCRegress(SolinstTemp);
    plot(LCRegress,DateNum, SolinstTemp);
    
    % Find maximas and minimas of lower chamber
    % Differentiate regression function
    LCDiff =@(x)differentiate(LCRegress,x);
   
    % Regression graph to define segments
    max1 = [736667 736851];
    min1 = [736851 737033];
    max2 = [737033 737216];
    min2 = [737216 737400];
    max3 = [737400 737574];
    min3 = [737574 737757];
    max4 = [737757 737932];
    min4 = [737932 738111];
    max5 = [738111 738327];
   
   LCmin1 = fzero(LCDiff,min1);%Exclude truncations
   LCmin2 = fzero(LCDiff,min2);
   LCmin3 = fzero(LCDiff,min3);
   LCmin4 = fzero(LCDiff,min4);
   
   LCmax1 = fzero(LCDiff,max1);
   LCmax2 = fzero(LCDiff,max2);
   LCmax3 = fzero(LCDiff,max3);
   LCmax4 = fzero(LCDiff,max4);
   LCmax5 = fzero(LCDiff,max5);
 
% Find the lag in days
    %Winters
    Winters = [Surfmin1 Surfmin2 Surfmin3 Surfmin4;LCmin1 LCmin2 LCmin3 LCmin4];
    %Summers
    Summers = [Surfmax1 Surfmax2 Surfmax3 Surfmax4 Surfmax5; LCmax1 LCmax2 LCmax3 LCmax4 LCmax5];
   
    % Convert datenum to datetime
    WinterLag = datetime(Winters,'ConvertFrom','datenum')
    SummerLag = datetime(Summers,'ConvertFrom','datenum')
    
    % Find the difference between the lower  chamber and the surface in
    % hours
    WinterLagHours = WinterLag(2,:)-WinterLag(1,:);  
    SummerLagHours = SummerLag(2,:)-SummerLag(1,:);
    
    % Find the difference between the lower  chamber and the surface in
    % days
    WinterLagDays = days(WinterLag(2,:)-WinterLag(1,:));  
    SummerLagDays = days(SummerLag(2,:)-SummerLag(1,:));
    
    % Find the mean lag time by season
    WinterLagMean = mean(WinterLagDays);
    SummerLagMean = mean(SummerLagDays);
    
    % Overall Average Lag
    Lag = mean([WinterLagMean; SummerLagMean]);
    
% Convert numeric x-axis to datetime format
dates = [736600,736800,737000,737200,737400,737600,737800, 738000,738200];
datesactual = datetime(dates,'ConvertFrom','datenum')
% Show that there is some long term evidence of conduction due to the
% sinusoidal relationship that the cave has with the surface climate
 
%% Conduction
% Hypotheically create three difference scenarios based on Rau's Models 
    % 1. Define the variables
T_o = mean(SAWSAirTemp(~isnan(SAWSAirTemp)));
A = [250,400,650] % This is the temperature of the fire
P = 1 % One day signal
d = 0.5; % depth of the soil
D = 0.0396; % Diffusivity value of dry soil. 
z = [1.7;7.1]; % Upper chamber depths
D_r = 0.0808; % Limestone diffusivity value
theta = (289/365.25)*360*pi/180; %day of the year in rads
t =365.25; % how it changes in a year -> Change this value if we want to assess this over other time periods.
 
% Insert values into equation to generate matrix for each
% temperature and depth
T = T_o+A*exp(-(sqrt(pi/P)*((d/sqrt(D))+((z-d)/sqrt(D_r)))))...
    *cos((2*pi*t/P)-sqrt(pi/P)*((d/sqrt(D))+((z-d)/sqrt(D_r)))-theta)
 
%% Overarching figures 
% All thermal data of Daylight Cave
AllTemp = figure('Name','Temperature Responses Within Daylight Cave');
 
fire = DateTime([132965]);
 
yyaxis left
scatter(DateTime, SAWSAirTemp1,'.');
hold on
plot(DateTime([1:146540]), UCAWSAirtemp([1:146540]),'Color',[0.9290 0.6940 0.1250]);
plot(DateTime,SolinstTemp, 'Color',[0.8500 0.3250 0.0980]);
xline(fire,'--r',{'Fire Event'},'LineWidth',2);
 
yyaxis right
area(DateTime, Rainfall);
hold off
 
% Hydrological Overview of Daylight Cave
figure('Name','Hydrological Overview of Daylight Cave')
yyaxis left
figure('Name','Effects of Rainfall on drips (area plot)')
 
yyaxis left
area(DateCrop,RainCrop,'DisplayName','Rainfall')
hold on
yyaxis right
scatter(DateCrop,Drip2Crop,'.','b');
scatter(DateCrop,Drip1Crop,'.','b');
set(gca, 'YScale', 'log')
hold off
grid

%% 3. Identify duration of spikes using a change point analysis
% This is the optimised change points script.

% findchangepts doesn't work if there are data gaps, there is a 1 hr gap each
% time someone enters the cave due to thermal increase which has been
% removed as outliers, thus we must eliminate all NAN values and squish 
% data together.
Squish = SolinstTemp(~isnan(SolinstTemp));
 
% Find where the standard deviation changes the most in the signal
STDpts = findchangepts(Squish,'MaxNumChanges',15,'Statistic','std')
 
% Graph the Standard Deviation Change Points
figure('Name','Standard Deviation Change Points in LC Temperature');
plot(Squish);
hold on
line([STDpts.';STDpts.'], [min(Squish); max(Squish)].*ones(size(STDpts.')))
title({'Standard Deviation Change Points')
hold off

%% Annual Thermal Comparason
% Define the Winters (ventilation seasons)
Ws17 = Squish([STDpts([2]):STDpts([3])]);
Ws18 = Squish([STDpts([5]):STDpts([6])]);
Ws19 = Squish([STDpts([8]):STDpts([9])]);
Ws20 = Squish([STDpts([12]):STDpts([13])]);
% Using the StdDev Change points determine the mean winter temperatures.
 
Win17s = mean(Ws17);
Win18s = mean(Ws18);
Win19s = mean(Ws19);
Win20s = mean(Ws20);

% Use the stdev change pts to look at the stdev each winter
%Win16var = std(Ws16);
Win17var = std(Ws17);
Win18var = std(Ws18);
Win19var = std(Ws19);
Win20var = std(Ws20);
%Win21var = std(Ws21);
 
% a) Do a Levene mean variance test make a matrix of data for the winter period
    % 1. make each vector an even length:
n=max(numel(Ws19));
  % Ws16(end+1:n)=nan;
    Ws17(end+1:n)=nan;
    Ws18(end+1:n)=nan;
    Ws19(end+1:n)=nan;
    Ws20(end+1:n)=nan;
  % Ws21(end+1:n)=nan;
    
    % 2. Make the Matrix
%WintersMatrix = [Ws16,Ws17,Ws18,Ws19,Ws20,Ws21];          
WintersMatrix = [Ws17,Ws18,Ws19,Ws20];   
 
% Do a Levene Test to determine if the variance is equal
vartestn(WintersMatrix,'TestType','LeveneAbsolute')      % Levene Score 1080, p=0 therefore there is a statistically significant difference between winter temperatures
 
% b) Comparason of two means (pared sample ttest):
    % 1. Data before and data after the same size:
%befores = [Ws16;Ws17;Ws18;Ws19];
%afters = [Ws20;Ws21];
befores = [Ws17;Ws18;Ws19];
afters = [Ws20];
    N = max(numel(befores),numel(afters));
        befores(end+1:N) = nan;
        afters(end+1:N) = nan;
    
    % 2. Perform paired sample t test comparing the means before and after:
[h,p,ci,stats] = ttest(befores,afters)

%% Summers
% Define the Summers
Ss16_17 = Squish([STDpts([1]):STDpts([2])]);
Ss17_18 = Squish([STDpts([4]):STDpts([5])]);
Ss18_19 = Squish([STDpts([7]):STDpts([8])]);
Ss19_20 = Squish([STDpts([10]):STDpts([11])]);
Ss20_21 = Squish([STDpts([14]):STDpts([15])]);
 
% a) Do a Levene mean variance test make a matrix of data for the winter period
    % 1. make each vector an even length:
n=max(numel(Ss16_17));
    Ss16_17(end+1:n)=nan;
    Ss17_18(end+1:n)=nan;
    Ss18_19(end+1:n)=nan;
    Ss19_20(end+1:n)=nan;
    Ss20_21(end+1:n)=nan;
  
% 2. Make the Matrix
%WintersMatrix = [Ws16,Ws17,Ws18,Ws19,Ws20,Ws21];          
SummersMatrix = [Ss16_17,Ss17_18,Ss18_19,Ss19_20,Ss20_21];   
 
% Do a Levene Test to determine if the variance is equal
vartestn(SummersMatrix,'TestType','LeveneAbsolute')      % Levene Score 1080, p=0 therefore there is a statistically significant difference between winter temperatures
 
% b) Comparason of two means (pared sample ttest):
    % 1. Data before and data after the same size:
Sbefores = [Ss16_17;Ss17_18;Ss18_19];
Safters = [Ss19_20;Ss20_21];
    N = max(numel(Sbefores),numel(Safters));
        Sbefores(end+1:N) = nan;
        Safters(end+1:N) = nan;
    
% 2. Perform paired sample t test comparing the means before and after:
[h,p,ci,stats] = ttest(Sbefores,Safters)
