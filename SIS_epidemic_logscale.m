function SIS_epidemic_logscale( delta,sample_length, runs, input_adj_mat, ofile )
% Nathan Harding 2017
% SIS_epidemic_logscale
% SIS epidemic simulation used to generate time-series data
% Supplementary to "Thermodynamic efficiency of contagions: A statistical mechanical analysis of the SIS epidemic model", 
% N. Harding, R. Nigmatullin, M. Prokopenko, 2018.
load( input_adj_mat );
rng('shuffle')
sz = size(adjacency_matrix);
adj_mat = adjacency_matrix;
graph_size = sz(1);
proportion_infected = 0.5;
I = zeros(runs,sample_length);
C = zeros(runs,sample_length);
nu_vec = logspace(-4,-2,100);

for i =1:runs
    nu=nu_vec(i);
    system_state = zeros(1,graph_size);
    system_state(datasample(1:graph_size,floor(graph_size*proportion_infected)))=1;
    tmp_I = zeros(1,sample_length);
    tmp_C = zeros(1,sample_length);
    for j=1:sample_length
        newinfected = zeros(1,graph_size);
        newrecovered = zeros(1,graph_size);
        infectious_contacts = system_state*adj_mat;
        P_infect = (1-system_state).*(1-(1-nu).^infectious_contacts);
        P_recover = delta*system_state;
    
        newinfected(rand(1,graph_size)<P_infect) = 1;
        newrecovered(rand(1,graph_size)<P_recover) = 1;
    
        system_state = system_state+newinfected-newrecovered;
        tmp_I(j) = sum(system_state(:));
        tmp_C(j) = system_state*adj_mat*(1-system_state)';
    end
    I(i,:) = tmp_I;
    C(i,:) = tmp_C;
    
end

save( ofile ,'I','C','nu_vec')

end

