%script to recreate figures from BEIR VII report
clear
%% initialize data

% text strings useful in constructing file names
yyyy_mm_dd = datetime('now','format','yyyy_MM_dd');
[~,git_full_hash] = system('git rev-parse HEAD');
git_short_hash = git_full_hash(1:7);

% parameters for risk model
dose = 1; % radiation dose (Sv)


%% import other risk parameters; See BEIR VII, Pg. XX, Table XX
load ERR_EAR_parameters

%% Generate ERR and EAR arrays

beta_f = ERR.IR.BetaF(1);  %BetaF(n) where n 
beta_m = ERR.IR.BetaM(1);

eta    = ERR.IR.Eta(1);
gamma  = ERR.IR.Gamma(1);


% sex averaged ERR structure for various ages
% data(i).name is used as for legend and to indicate groups
data(1).name = 'Age at exposure 30+';
age_exp      = 30;
[data(1).risk,data(1).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

data(2).name = 'Age at exposure 20';
age_exp      = 20;
[data(2).risk,data(2).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

data(3).name = 'Age at exposure 10';
age_exp      = 10;
[data(3).risk,data(3).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);
                            

%% Calling plotting functions
filename = sprintf('%s_%s_%s',yyyy_mm_dd,git_short_hash,'ERR');

xdata = [];
ydata = [];
group = [];

for i = 1:numel(data)
    num_datapts = numel(data(i).risk);
    
    xdata = [xdata;data(i).age];
    ydata = [ydata;data(i).risk];
    
    temp_group    = cell(num_datapts,1);
    temp_group(:) = {data(i).name};
    group = [group;temp_group];    
end

linear_plotter(filename,xdata,ydata,group,'age','risk','test')
%% ERR and EAR models functions
function [IR,age_attained]=risk_model(beta,eta,gamma,dose,age_exposed)
%{
The ERR or EAR is of the form:
 `\Beta_s * D * exp(\Gamma * e_adj) * (a/60)*\eta
%}

% transport age at exposure parameter
if age_exposed >= 30
    e_adj = 0;
else
    e_adj = (age_exposed-30)/10;
end

% generate linear array for attained age
age_lb = 5+age_exposed; 
age_ub = 50+age_exposed;
age_attained = linspace(age_lb,age_ub,(age_ub-age_lb)+1)';

% calculate incidence rate (IR)
IR = beta .* dose .* exp(gamma * e_adj) .* (age_attained./60).^eta;

end
