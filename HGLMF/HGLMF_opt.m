function pscores = HGLMF_opt(Y,Y0,sim_U,sim_V,option)
cfix = option(4);      
train_set = cfix*Y;                                % c*Y
train_set1 = (cfix-1)*Y + ones(size(Y));   % (c-1)*Y+1

%%%%%%%
name = 'Zhou';
k_nn = floor(size(sim_U,1)*0.1);
[LM,Sm] = construct_Hypergraphs_knn1(sim_U,k_nn,name); 
k_nn = floor(size(sim_V,1)*0.1);
[LD,Sd]= construct_Hypergraphs_knn1(sim_V,k_nn,name);
%%%%%
[U,V] = AGD_optimization(train_set,train_set1,LM,LD,option);    
U = gather(U);  V = gather(V); 
%
[U1,V1] = complete_opt(Y0,Sm,Sd,U,V);
pscores = exp(U1*V1')./(1+exp(U1*V1'));

end

function [U,V] = AGD_optimization(train_set,train_set1,LM,LD,option)
train_set = gpuArray(train_set);
train_set1 = gpuArray(train_set1);
LM = gpuArray(LM);
LD = gpuArray(LD);


theta = 1;
num_factors = option(1);
[nm,nd] = size(train_set);
max_iter=100;   

seed = 1;
randn('state',seed)
U = sqrt(1/num_factors)*gpuArray(randn(nm,num_factors));
randn('state',seed)
V = sqrt(1/num_factors)*gpuArray(randn(nd,num_factors));

dg_sum = gpuArray.zeros(size(U));
tg_sum = gpuArray.zeros(size(V));
last_log = log_likelihood(U,V,LM,LD,option,train_set,train_set1);   
for t =  1:max_iter
    %%%
    dg =  deriv_opt(train_set,train_set1,U,V,'disease',LM,LD,option); %
    dg_sum = dg_sum + dg.^2;   
    vec_step_size = theta*gpuArray.ones(size(dg_sum))./ sqrt(dg_sum);   %
    U = U + vec_step_size .* dg;  
    %%%%¸üÐÂV
    tg = deriv_opt(train_set,train_set1,U,V,'met',LM,LD,option);  
    tg_sum = tg_sum + tg.^2;
    vec_step_size = theta*gpuArray.ones(size(tg_sum)) ./ sqrt(tg_sum);
    V = V + vec_step_size .* tg;
    %%%%
    curr_log = log_likelihood(U,V,LM,LD,option,train_set,train_set1);   %%
    delta_log = (curr_log-last_log)/abs(last_log);   %
    if abs(delta_log) < 1e-5
        break;
    end
    last_log = curr_log; 
end
end

function vec_deriv = deriv_opt(train_set,train_set1,U,V,name,LM,LD,option)

lata = option(2);
ar = option(3);

%%%
if strcmp(name,'disease')==1
    vec_deriv = train_set*V;   %
else
    vec_deriv = train_set'*U;  %
end
A = exp(U*V');
A = A./(A + ones(size(train_set)));   %%
A = train_set1.* A;     %%
if strcmp(name,'disease') == 1
    vec_deriv = vec_deriv - A * V;
    vec_deriv = vec_deriv - (ar*U+lata*LM*U);   %%%
else
    vec_deriv = vec_deriv - A'*U;
    vec_deriv =  vec_deriv - (ar*V+lata*LD*V);
end
end

function loglik = log_likelihood(U,V,LM,LD,option,train_set,train_set1)



lata = option(2);
ar = option(3);
Z = U*V';
loglik = sum(sum(train_set1.*log(1+exp(Z))-train_set.*Z))+...
    1/2*trace(U'*(ar*eye(size(LM))+lata*LM)*U)+...
    1/2*trace(V'*(ar*eye(size(LD))+lata*LD)*V);
    

end


%%%%%%%%%
function [U1,V1] = complete_opt(train_set,sim_U,sim_V,U,V)

U1 = U;
V1 = V;
K = 10;           

flagu = sum(train_set,2);    inu0 = find(flagu==0);    inuu = find(flagu>0);   
flagv = sum(train_set,1);   inv0 = find(flagv==0);    inuv = find(flagv>0);     

ar = 0.9;  ar = ar.^(0:K-1);  
%%%
for i=1:length(inu0)
    [~,sortu] = sort(sim_U(inu0(i),inuu),'descend');
    inuk = inuu(sortu(1:K));   
    if sum(ar.*sim_U(inu0(i),inuk))>0
        U1(inu0(i),:) = (ar.*sim_U(inu0(i),inuk))*U(inuk,:)/sum(ar.*sim_U(inu0(i),inuk));
    end
end

%%%
for i=1:length(inv0)   
    [~,sortv] = sort(sim_V(inv0(i),inuv),'descend');
    invk = inuv(sortv(1:K));   
    if sum(ar.*sim_V(inv0(i),invk))>0
        V1(inv0(i),:) = (ar.*sim_V(inv0(i),invk))*V(invk,:)/sum(ar.*sim_V(inv0(i),invk));
    end
end

end
