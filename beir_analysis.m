%script to recreate figures from BEIR VII report
clear

%% directories, homeplate & destination of outputs
sep        = filesep;
home_env   = getenv('HOME');
home_code  = pwd;
home_out   = [home_code,sep,'figures',sep];

if 7~=exist(home_out,'dir')
    mkdir(home_out);
end

%% initialize data

% text strings useful in constructing file names
yyyy_mm_dd = datetime('now','format','yyyy_MM_dd');
[~,git_full_hash] = system('git rev-parse HEAD');
git_short_hash = git_full_hash(1:7);

% parameters for risk model:
dose = 1; % radiation dose (Sv)

%% import other risk parameters; See BEIR VII, Pg. XX, Table XX
load ERR_EAR_parameters

%% generate ERR and EAR data for plotting

%%%% ERR Section %%%%
beta_f = ERR.IR.BetaF(1);
beta_m = ERR.IR.BetaM(1);

eta    = ERR.IR.Eta(1);
gamma  = ERR.IR.Gamma(1);

% sex averaged ERR for various ages
% data(i).name will be used to indicate groups and in legend of plot
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
%%%% EAR SECTION %%%%
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

%% call plotting functions
filename = [home_out,sep,sprintf('%s_%s_%s',yyyy_mm_dd,git_short_hash,'ERR')];

num_datapts = sum(cellfun(@numel,{ERR_data.risk}));
xdata = [];
ydata = [];
group = [];

for i = 1:numel(ERR_data)
    num_datapts = numel(ERR_data(i).risk);
    
    %#ok<*AGROW>; ignore preallocation warning in file
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

filename = [home_out,sep,sprintf('%s_%s_%s',yyyy_mm_dd,git_short_hash,'EAR')];

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
