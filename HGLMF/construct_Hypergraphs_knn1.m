function [L ,AA]= construct_Hypergraphs_knn1(W,k_nn,name)

L_H=[];
n_size = size(W,1);
n_vertex = n_size;
n_edge = n_size;


H = zeros(n_edge,n_vertex);
We = zeros(n_edge,n_edge);
%build Association matrix of Hypergraphs
for i=1:n_vertex
    ll = W(i,:);
    [B,index_i] = sort(ll,'descend');
    k_ii = index_i(1:k_nn);
    H(i,k_ii) = 1;
    We(i,i) = mean(ll(k_ii));
end
%%%%%
H = H';
De = diag(sum(H,1));
Dn = diag(sum(H,2));
w = diag(ones(1,size(De,2)));

if strcmp(name,'Zhou')
    DeZhou = De;
    AA = H*DeZhou^(-1)*w*H';
elseif strcmp(name,'Rod')
    AA = H*w*H' - Dn;
    Dn = diag(sum(AA));
elseif strcmp(name,'Saito')
    De = De - diag(ones(1,size(De,2)));
    A = H*De^(-1)*w*H';
    AA = A-diag(diag(A));
else
    error('You have to choose mode from either Zhou, Rod, or Saito')
end
L = Dn^(-1/2)*(Dn - AA)*Dn^(-1/2);



end