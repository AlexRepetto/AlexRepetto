%%Seasonal Change
% Change points
Squish = SolinstTemp(~isnan(SolinstTemp));
STDpts =[10818;32379;41547;46632;65705;78302;83345;98831;117661;123436;131607;136752;147822;153373;168144];
MEANpts =[12173;29223;46536;65603;82482;98929;116178;132457;153372;168065];

%% Winters
% Define the Winters
%Ws16 = Squish([1:STDpts([1])]);
Ws17 = Squish([STDpts([2]):STDpts([3])]);
Ws18 = Squish([STDpts([5]):STDpts([6])]);
Ws19 = Squish([STDpts([8]):STDpts([9])]);
Ws20 = Squish([STDpts([12]):STDpts([13])]);
%Ws21 = Squish([STDpts([15]):end]);

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