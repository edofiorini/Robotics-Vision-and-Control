function lambda = findLambda(tau, tauConstraints)

    minLambda = [];
    for i = 1:6
        minLambda(i) = tauConstraints(i)/abs(tau(i,1));
    end
    
    lambda = sqrt(min(minLambda));
end