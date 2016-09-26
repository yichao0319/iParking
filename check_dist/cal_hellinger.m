function [h] = cal_hellinger(ts1, ts2)
    nb = 30;
    min_val = min([ts1; ts2]);
    max_val = max([ts1; ts2]);
    bs = (max_val - min_val) / nb;

    if min_val == max_val
        edges = [min_val, min_val+1];
    else
        edges = min_val:bs:(max_val+bs);
    end

    tmp = histogram(ts1, edges);
    h1 = tmp.Values;
    h1 = h1 / sum(abs(h1));
    tmp = histogram(ts2, edges);
    h2 = tmp.Values;
    h2 = h2 / sum(abs(h2));

    h = sum((sqrt(h1) - sqrt(h2)).^2);
end