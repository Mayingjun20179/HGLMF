function result = five_cross(DATA,cv_data,option,cv_flag)
interaction = DATA.interaction;
cv = length(cv_data);
result = 0;
cv_flag=1;
for k=1:cv
    %%%%%%%%%%%%%%%%%%%%%%%%%
    train_set = interaction.*cv_data{k}{1};   
    Y = xiuzheng_Y(train_set,DATA.met_sim{1},DATA.dis_sim{1});   
    %%%
    KSNS_Sm = KSNS_opt(Y);    KSNS_Sm(1:size(KSNS_Sm,1)+1:end)=1;
    K1(:,:,1) =  DATA.met_sim{1};  K1(:,:,2) =  DATA.met_sim{2}; K1(:,:,3) =  KSNS_Sm;
    [weight_v1] = cka_kernels_weights(K1,train_set,1); 
    met_sim = combine_kernels(weight_v1, K1);
    
    %%     
    KSNS_Sd = KSNS_opt(Y');     KSNS_Sd(1:size(KSNS_Sd,1)+1:end)=1;
    K2(:,:,1) =  DATA.dis_sim{1}; K2(:,:,2) =  DATA.dis_sim{2}; K2(:,:,3) =  KSNS_Sd;
    [weight_v2] = cka_kernels_weights(K2,train_set,2); 
    dis_sim = combine_kernels(weight_v2, K2);

    %%%%HGLMF
    scores = HGLMF_opt(Y,train_set,met_sim,dis_sim,option);
    
    %Result Evaluation
    if cv_flag==1 
        pscores = scores(cv_data{k}{2});
        result0 = evaluate_opt1(pscores,cv_data{k}{3});
    elseif cv_flag==2
        ind = cv_data{k}{2};   Nt = length(ind);
        test_matrix_label = cv_data{k}{3};
        result0 = [];        
        for i=1:length(ind)
            result0 = [result0;evaluate_opt1(scores(i,:),test_matrix_label(i,:))];
        end
        result0 = mean(result0);
    elseif cv_flag==3
        ind = cv_data{k}{2};   Nt = length(ind);
        test_matrix_label = cv_data{k}{3};
        result0 = [];        
        for i=1:length(ind) 
            result0 = [result0;evaluate_opt1(scores(:,i),test_matrix_label(:,i))];
        end
        result0 = mean(result0);
    end     
    
    result = result + result0;
    result/k;    
end
result = result/cv
end


