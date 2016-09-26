function [kw] = cal_kw(ts1, ts2)
    n1 = length(ts1);
    n2 = length(ts2);

    ts      = [ts1; ts2];
    grp_ind = [ones(n1,1); ones(n2,1)*2];

    [~,sort_ind] = sort(ts, 'ascend');

    r_avg = (n1+n2+1)/2;
    r1_avg = mean(sort_ind(grp_ind == 1));
    r2_avg = mean(sort_ind(grp_ind == 2));

    down = sum((sort_ind-r_avg).^2);
    up = n1*((r1_avg-r_avg)^2) + n2*((r2_avg-r_avg)^2);
    kw = (n1+n2-1) * up / down;

end