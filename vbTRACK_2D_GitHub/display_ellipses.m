function display_ellipses(train_data, states)

    num = length(train_data);
    X = train_data';
    G = states;

    gscatter(X(:,1), X(:,2), G)  % plots train_data, red for state 1, blue for state 2. 
    axis equal, hold on

    for k=1:2
        %# indices of points in this group
        idx = ( G == k );

        %# substract mean
        Mu = mean( X(idx,:) );
        plot(Mu(1),Mu(2),'squarek','linewidth',4,'MarkerSize',15);
        X0 = bsxfun(@minus, X(idx,:), Mu);
        
        STD = 2;                     %# 2 standard deviations
        conf = 2*normcdf(STD)-1;     %# covers around 95% of population
        scale = chi2inv(conf,2);     %# inverse chi-squared with dof=#dimensions

        Cov = cov(X0) * scale;
        [V D] = eig(Cov);
        
        %# eigen decomposition [sorted by eigen values]
        %[V D] = eig( X0'*X0 ./ (sum(idx)-1) );     %#' cov(X0)
        [D order] = sort(diag(D), 'descend');
        D = diag(D);
        V = V(:, order);

        t = linspace(0,2*pi,100);
        e = [cos(t) ; sin(t)];        %# unit circle
        VV = V*sqrt(D);               %# scale eigenvectors
        e = bsxfun(@plus, VV*e, Mu'); %#' project circle back to orig space
        
        %# plot cov and major/minor axes
        switch k
            case 1
                plot(e(1,:), e(2,:), 'Color','r');
            case 2
                plot(e(1,:), e(2,:), 'Color','b');
        end

        %#quiver(Mu(1),Mu(2), VV(1,1),VV(2,1), 'Color','k')
        %#quiver(Mu(1),Mu(2), VV(1,2),VV(2,2), 'Color','k')
    end

end