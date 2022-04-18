%% Temperature Calibration
% This script calibrates the data obtained from the BOM from the Kempsey
% AWS with the existing surface temperature data from the cave.
% Unsure of how to calibrate so I have written two scripts (1 and 2)

%% Visualise the raw data
figure('Name','Overlap of raw data');
scatter(DateTime,KAWSAirTemp,'.','r');
hold on
scatter(DateTime,SAWSAirTemp,'.','b');
hold off

%% 1. Determine the difference between the two datasets -I dont think this is the best option because it's not looking at each dataset, rather it's assessing the difference
% This can be used to cross check part 2
%Isolate the overlap period
Kover=KAWSAirTemp([86534:105313]);
Sover=SAWSAirTemp([86534:105313]);

% Determine the difference between the two datasets
diff = Sover-Kover;

% Represent this difference visually
timecrop = DateTime([86534:105313]);

figure('Name','Variance between surface temperature at the cave and Kempsey');
scatter(timecrop,diff,'.');

%Find the mean difference between datasets by removing all NaN values (from
%15 min intervals)
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
%                           ***DO THIS***

