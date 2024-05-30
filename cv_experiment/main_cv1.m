function main_cv1(cv_flag,DATA)

option = [50.0000   10.0000   10.0000   16.0000];
option = repmat(option,20,1);

nF = 5;  %
[N,NCW] = size(option);
result = zeros(N,NCW+8);


cv_data = [];
for ii = 1:N
    cv_data = [cv_data;cross_validation(DATA.interaction,cv_flag,nF)];
end

    
for i = 1:N
    i
    jieguo = five_cross(DATA,cv_data(i,:),option(i,:),cv_flag);
    jieguo = [option(i,:),jieguo]
    result(i,:) = jieguo;
end


if cv_flag==1
    best_HGLMF_CVa = result;
    save best_HGLMF_CVa best_HGLMF_CVa;
elseif cv_flag==2
    best_HGLMF_CVr = result;
    save best_HGLMF_CVr best_HGLMF_CVr;
elseif cv_flag==3
    best_HGLMF_CVc = result;
    save best_HGLMF_CVc best_HGLMF_CVc;
end


end








function cv_data = cross_validation(intMat,cv_flag,cv)
[N,M] = size(intMat);
cv_data = cell(1,cv);  %
if cv_flag==1    %
    crossval_idx = crossvalind('Kfold',intMat(:),5);
    for i=1:5
        ind = find(crossval_idx==i);
        W = ones(size(intMat)); W(ind)=0;
        test_ind = ind;
        test_label = intMat(test_ind);
        cv_data{i} = {W, test_ind, test_label};
    end
elseif cv_flag==2  %
    crossval_idx = crossvalind('Kfold', N, 5);
    for i=1:5
        ind = find(crossval_idx==i);
        W = ones(size(intMat)); W(ind,:)=0;  %
        test_ind = find(W==0);
        test_label = intMat(test_ind);
        cv_data{i} = {W, test_ind, test_label};
    end
elseif cv_flag==3  %
    crossval_idx = crossvalind('Kfold', M, 5);
    for i=1:5
        ind = find(crossval_idx==i);
        W = ones(size(intMat)); W(:,ind)=0;  %
        test_ind = find(W==0);
        test_label = intMat(test_ind);
        cv_data{i} = {W,test_ind, test_label};
    end    
end
end

