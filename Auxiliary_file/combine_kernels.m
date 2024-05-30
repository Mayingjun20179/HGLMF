%This code is referenced from "Identification of drug-side effect association via multiple information
%integration with centered kernel alignment"
function result = combine_kernels(weights, kernels)
    % length of weights should be equal to length of matrices
    n = length(weights);
    result = zeros(size(kernels(:,:,1)));    
    
    for i=1:n
        result = result + weights(i) * kernels(:,:,i);
    end
end