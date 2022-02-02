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

%% Generate ERR and EAR data for plotting

beta_f = ERR.IR.BetaF(1);
beta_m = ERR.IR.BetaM(1);

eta    = ERR.IR.Eta(1);
gamma  = ERR.IR.Gamma(1);

% ERR Section
% sex averaged ERR structure for various ages
% data(i).name is used as for legend and to indicate groups
ERR_data(1).name = 'Age at exposure 30+';
age_exp      = 30;
[ERR_data(1).risk,ERR_data(1).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

ERR_data(2).name = 'Age at exposure 20';
age_exp      = 20;
[ERR_data(2).risk,ERR_data(2).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

ERR_data(3).name = 'Age at exposure 10';
age_exp      = 10;
[ERR_data(3).risk,ERR_data(3).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);
% EAR SECTION
beta_f = EAR.IR.BetaF(1);
beta_m = EAR.IR.BetaM(1);

eta    = EAR.IR.Eta(1);
gamma  = EAR.IR.Gamma(1);

EAR_data(1).name = 'Age at exposure 30+';
age_exp      = 30;
[EAR_data(1).risk,EAR_data(1).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

EAR_data(2).name = 'Age at exposure 20';
age_exp      = 20;
[EAR_data(2).risk,EAR_data(2).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

EAR_data(3).name = 'Age at exposure 10';
age_exp      = 10;
[EAR_data(3).risk,EAR_data(3).age] = risk_model(...
                                (beta_m+beta_f)/2,eta,gamma,dose,age_exp);

%% Calling plotting functions
filename = sprintf('%s_%s_%s',yyyy_mm_dd,git_short_hash,'ERR');

num_datapts = sum(cellfun(@numel,{ERR_data.risk}));
xdata = [];
ydata = [];
group = [];

for i = 1:numel(ERR_data)
    num_datapts = numel(ERR_data(i).risk);
    
    %#ok<*AGROW>; ignore preallocation error in file
    xdata = [xdata;ERR_data(i).age]; 
    ydata = [ydata;ERR_data(i).risk];
    
    temp_group    = cell(num_datapts,1);
    temp_group(:) = {ERR_data(i).name};
    group = [group;temp_group];
end

ylim         = [0.2 2.4];
ytick        = 0.2:0.2:2.4;
leg_position = [0.6 0.6 .1 .3];
ytickformat  = '%.1f';
yminortick   = 0.3:0.2:2.3;
linear_plotter(...
    filename,...
    xdata,...
    ydata,...
    group,...
    'Attained age',...
    'Excess Relative Risk (1 Sv)',...
    '',...
    ylim,...
    ytick,...
    leg_position,...
    ytickformat,...
    yminortick);

filename = sprintf('%s_%s_%s',yyyy_mm_dd,git_short_hash,'EAR');

xdata = [];
ydata = [];
group = [];

for i = 1:numel(EAR_data)
    num_datapts = numel(EAR_data(i).risk);
    
    xdata = [xdata;EAR_data(i).age];
    ydata = [ydata;EAR_data(i).risk];
    
    temp_group    = cell(num_datapts,1);
    temp_group(:) = {EAR_data(i).name};
    group = [group;temp_group];
end

ylim         = [0 75];
ytick        = 0:10:70;
leg_position = [0.15 0.6 .1 .3];
ytickformat  = '%g';
yminortick   = 5:10:75;
linear_plotter(...
    filename,...
    xdata,...
    ydata,...
    group,...
    'Attained age',...
    'Excess cases per 10,000 PY-Sv',...
    '',...
    ylim,...
    ytick,...
    leg_position,...
    ytickformat,...
    yminortick)
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
age_ub = 60+age_exposed;
age_attained = linspace(age_lb,age_ub,(age_ub-age_lb)+1)';
age_attained = age_attained(age_attained(:,1)>=30,:); 

% calculate incidence rate (IR)
IR = beta .* dose .* exp(gamma * e_adj) .* (age_attained./60).^eta;

end
