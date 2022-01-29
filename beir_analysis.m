%script to recreate figures from BEIR VII report
clear
%% initialize data
yyyy_mm_dd = datetime('now','format','yyyy_MM_dd');
[~,git_full_hash] = system('git rev-parse HEAD');

git_short_hash = git_full_hash(1:7);
%% import relevant information
load beir_err_model
load beir_ear_model