function decision = gnb_decide(h0m,h0s,h1m,h1s,data,mu,sigma)

        % p(h0 | data) = p(data | h0) * p(h0) / p(data)
        pH0 = (normpdf(data,h0m,h0s) * 0.5);% ./ normpdf(data,mu,sigma);
        pH0 = prod(pH0,1);
        % p(h1 | data) = p(data | h1) * p(h1) / p(data)
        pH1 = (normpdf(data,h1m,h1s) * 0.5);% ./ normpdf(data,mu,sigma);
        pH1 = prod(pH1,1);
%         if pH1 > 1
%             warning(sprintf('pH1 = %1.3f',full(pH1)))
%         end
        % now decide
        if pH1==pH0
            decision = round(rand);
        else
            decision = double(pH1>pH0);
        end
