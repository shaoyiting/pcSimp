function simpX = simplify(alpha, lambda, sigma, eta, k, X)
    % to simplify the given point cloud (points in a grid)
    % Author: Junkun Qi
    % 2018/5/13

    n = size(X,1);

    if n*alpha < 1
        simpX = [];
    else
        m = ceil(n*alpha);
        k = min(k,n-1);
        
        L = zeros(n);
        A = zeros(n);
        
        for i = 1:n
            d = dist(X,X(i,:),sigma,eta);
            [d,p] = sort(d);
            for j = 2:k+1
                L(i,p(j)) = exp(-d(j));
                L(p(j),i) = L(i,p(j));
                A(i,p(j)) = 1;
                A(p(j),i) = 1;
            end
        end
        
        d = sum(L,2);
        for i = 1:n
            L(i,:) = L(i,:)/d(i);
        end

        I = eye(n);
        J = ones(n);
        L = I-L; % normalized random walk laplacian
        gamma = 1/alpha-1-2*k*lambda;
        beta = alpha*gamma*(gamma+1); % actually it's -1/2*beta

        Psi = inv((gamma+1)*I+lambda*A^2)*...
                ((L*X)*(L*X)'+lambda*k*alpha*A*J+beta*I)*...
                inv((L*X)*(L*X)'+J+gamma*I);

        d = sum(Psi,2);
        [~,p]=sort(d*-1); % max of d <=> min of -d

        simpX = X(p(1:m),:);
        clear L A I J Psi d;
    end
end
