function M_D = chuli_opt()
load('met_dis_2020.mat')
met_ID = met_dis_2020.met_inf.met_ID(:,1);
dis_ID = met_dis_2020.dis_inf.dis_ID(:,1);
interaction_md =met_dis_2020.inter(:,[1,3]);   
[~,indx] = cellfun(@(x)ismember(x,met_ID),interaction_md(:,1));  
[~,indy] = cellfun(@(x)ismember(x,dis_ID),interaction_md(:,2));  
interaction = full(sparse(indx,indy,ones(length(indx),1))); 
M_D.interaction = interaction;

M_D.dis_sim = {met_dis_2020.dis_inf.dis_gosim,met_dis_2020.dis_inf.dis_treesim};
M_D.met_sim = {met_dis_2020.met_inf.met_gen_go_sim,met_dis_2020.met_inf.met_simle_sim};

end