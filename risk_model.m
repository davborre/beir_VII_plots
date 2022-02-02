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