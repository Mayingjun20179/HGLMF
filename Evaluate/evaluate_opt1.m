function result = evaluate_opt1(score,label)
%%%%计算TN,TP,FN,FP
sort_predict_score=unique(sort(score));
score_num = length(sort_predict_score);
Nstep = min(score_num,2000);
threshold=sort_predict_score(ceil(score_num*(1:Nstep)/(Nstep+1)));

threshold=threshold';
threshold = threshold(end:-1:1);
threshold_num=length(threshold);
TN=zeros(threshold_num,1);
TP=zeros(threshold_num,1);
FN=zeros(threshold_num,1);
FP=zeros(threshold_num,1);

for i=1:threshold_num
    tp_index=logical(score>=threshold(i) & label==1);
    TP(i,1)=sum(tp_index);
    
    tn_index=logical(score<threshold(i) & label==0);
    TN(i,1)=sum(tn_index);
    
    fp_index=logical(score>=threshold(i) & label==0);
    FP(i,1)=sum(fp_index);
    
    fn_index=logical(score<threshold(i) & label==1);
    FN(i,1)=sum(fn_index);
end


%%%%%计算AUPR
SEN=TP./(TP+FN);
PRECISION=TP./(TP+FP);
recall=SEN;
x=recall;
y=PRECISION;
[x,index]=sort(x);
y=y(index,:);
x = [0;x];  y = [1;y];
x(end+1,1)=1;  y(end+1,1)=0;
AUPR=0.5*x(1)*(1+y(1));
for i=1:threshold_num
    AUPR=AUPR+(y(i)+y(i+1))*(x(i+1)-x(i))/2;
end
AUPR_xy = [x,y];

%%%%%计算AUC
AUC_x = FP./(TN+FP);      %FPR
AUC_y = TP./(TP+FN);      %tpR
[AUC_x,ind] = sort(AUC_x);
AUC_y = AUC_y(ind);
AUC_x = [0;AUC_x];
AUC_y = [0;AUC_y];
AUC_x = [AUC_x;1];
AUC_y = [AUC_y;1];

AUC = 0.5*AUC_x(1)*AUC_y(1)+sum((AUC_x(2:end)-AUC_x(1:end-1)).*(AUC_y(2:end)+AUC_y(1:end-1))/2);

AUCxy = [AUC_x(:),AUC_y(:)];

%%%%%计算其他指标
temp_accuracy=(TN+TP)/length(label);   %%准确率
temp_sen=TP./(TP+FN);    %%真实的有链接，预测正确的正确率
recall = temp_sen;
temp_spec=TN./(TN+FP);   %%真实无连接，预测正确率
temp_precision=TP./(TP+FP); %%预测有链接的正确率
temp_f1=2*recall.*temp_precision./(recall+temp_precision);
[~,index]=max(temp_f1);
%%%%计算F1最高的如下值：
f1=temp_f1(index);
%%%%计算得分前10，前15，前20的召回率
[~,ind] = sort(score,'descend');

% precision_top5 = sum(label(ind(1:5)))/sum(label);
% precision_top10 = sum(label(ind(1:10)))/sum(label);
% precision_top20 = sum(label(ind(1:20)))/sum(label);
% precision_top30 = sum(label(ind(1:30)))/sum(label);
% precision_top40 = sum(label(ind(1:40)))/sum(label);
prop = round(length(label)*[0.02,0.04,0.06,0.08,0.1]);
precision_top_p2 = sum(label(ind(1:prop(1))))/sum(label);
precision_top_p4 = sum(label(ind(1:prop(2))))/sum(label);
precision_top_p6 = sum(label(ind(1:prop(3))))/sum(label);
precision_top_p8 = sum(label(ind(1:prop(4))))/sum(label);
precision_top_p10 = sum(label(ind(1:prop(5))))/sum(label);


result=[AUPR,AUC,f1,...
    precision_top_p2,precision_top_p4, precision_top_p6,precision_top_p8,...
    precision_top_p10];
%     precision_top10,precision_top20, precision_top30,precision_top40,...


end