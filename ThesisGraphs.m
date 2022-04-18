%% Description
% This script will generate the final graphs used in my thesis. The
% sections will go as follows:

%   1. Advection by Water
%   2. Advection by Air
%   3. Conduction
%   4. Other contextual figures and analyses

%% Advection by Water

%   Part A - Rainfall and Drip Rate
%            This part shows that the cave responds immediately to
%            rainfall, thus indicating that it is controlled by conduit
%            flows.
% Make a single chart with 3 subplots that show:
    % 1. All data overview
    % 2. Rainfall and drips (Log)
    % 3. Drips (Log) and Temperature 

% Isolate the variables to conist of the shortest dataset that we have. 
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


%% Conduction
% Determine the lag between the surface and cave temperature and the
% amplitude dampening

%    Do a Spline Regression   
%       Change format of DateTime as a number category
DateNum = datenum(DateTime);
weights = ones([214055,1]);

    % After this point we use the curve fitting toolbox to do a fourier
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
   
   LCmin1 = fzero(LCDiff,min1);     %Scrap this one
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
%% Ventillation

%% Conduction
% Hypotheically create three difference scenarios based on Rau's Models 
    % 1. Define the variables
T_o = mean(SAWSAirTemp(~isnan(SAWSAirTemp)));
A = [250,400,650] % This is the temperature of the fire
P = 1 % One day signal
d = 0.5; % depth of the soil
D = 0.0396; % Diffusivity value of dry soil. 
z_u = 1.7; % Upper chamber depth
z_l = 7.1; % Lower Chamber depth
D_r = 0.0808; % Limestone diffusivity value
theta = (289/365.25)*360*pi/180; %day of the year in rads
t =365.25; % how it changes in a year -> Change this value if we want to assess this over other time periods.

% insert values into for upper chamber - generates matrix for each
% temperature
T = T_o+A*exp(-(sqrt(pi/P)*((d/sqrt(D))+((z_u-d)/sqrt(D_r)))))...
    *cos((2*pi*t/P)-sqrt(pi/P)*((d/sqrt(D))+((z_u-d)/sqrt(D_r)))-theta)

% Insert values into formula for lower chamber
T = T_o+A*exp(-sqrt(pi/P)*((d/sqrt(D))+((z_l-d)/sqrt(D_r))))...
    *cos((2*pi*t/P)-sqrt(pi/P)*((d/sqrt(D))+((z_l-d)/sqrt(D_r)))-theta)

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