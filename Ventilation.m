% Isolate Weekly data after fire event
%% Must Run BOM_Calibration.m before executing this file.
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
% Weekly Data
    %In theory ventilation should decrease in the week after compared to
    %the week before under normal conditions, work out the difference in
    % ventilation:
%n=max(673);
 %   WB16.Ventilation(end+1:n)=nan
 % WB17.Ventilation(end+1:n)=nan
  %  WB18.Ventilation(end+1:n)=nan
   % WB19.Ventilation(end+1:n)=nan
    %WA16.Ventilation(end+1:n)=nan
    %WA17.Ventilation(end+1:n)=nan
    %WA18.Ventilation(end+1:n)=nan
    %WA19.Ventilation(end+1:n)=nan
    
    %wbBefore = [WB16.Ventilation,WB17.Ventilation,WB18.Ventilation,WB19.Ventilation];
    %wbAfter = [WA16.Ventilation,WA17.Ventilation,WA18.Ventilation,WA19.Ventilation];
  
  %[h,p,ci,stats] =ttest(wbBefore)
  %[h,p,ci,stats] =ttest(wbAfter)
  
% Monthly Data
%n=max(2977);
 %   MB16.Ventilation(end+1:n)=nan;
  %  MB17.Ventilation(end+1:n)=nan;
   % MB18.Ventilation(end+1:n)=nan;
    %MB19.Ventilation(end+1:n)=nan;
    %MA16.Ventilation(end+1:n)=nan;
    %MA17.Ventilation(end+1:n)=nan;
    %MA18.Ventilation(end+1:n)=nan;
    %MA19.Ventilation(end+1:n)=nan;
    
 %mbBefore = [MB16.Ventilation,MB17.Ventilation,MB18.Ventilation,MB19.Ventilation];
 %mbAfter = [MA16.Ventilation,MA17.Ventilation,MA18.Ventilation,MA19.Ventilation];
  
 % [h,p,ci,stats] =ttest(mbBefore)
  %[h,p,ci,stats] =ttest(mbAfter)
  
 1]); %Make a 2 column matrix with all week data
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
  
  %The number of samples are: 2

%-----------------------------
% Sample    Size      Variance
%-----------------------------
%   1       1347         13.9124
%   2       673         49.5114
%-----------------------------
 
%Welch's Test for Equality of Variances F=0.4328, df1= 1, df2=865.4175
%Probability associated to the F statistic = 0.5115
%The associated probability for the F test is equal or larger than 0.05
%So, the assumption of homoscedasticity was met.
  
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
  
%  The number of samples are: 2

%-----------------------------
% Sample    Size      Variance
%-----------------------------
%   1       5918         24.8455
%   2       2977         50.0648
%-----------------------------
 
%Welch's Test for Equality of Variances F=0.0111, df1= 1, df2=4506.1007
%Probability associated to the F statistic = 0.9168
%The associated probability for the F test is equal or larger than 0.05
%So, the assumption of homoscedasticity was met.