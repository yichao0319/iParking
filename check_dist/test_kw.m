%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% - Input:
%%
%%
%% - Output:
%%
%%
%% example:
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function test_kw()
    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results


    %% --------------------
    %% Constant
    %% --------------------
    input_dir  = '../../data/sensor/';
    output_dir = '';
    fig_dir    = './tmp/';

    months = {'201504', '201505'};


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    % if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------
    for mi = 1:length(months)
        mon1 = months{mi};
        if DEBUG2, fprintf('mon1=%s\n', mon1); end

        data1 = load(sprintf('%sdata_%s.mat.txt', input_dir, mon1));
        label1 = load(sprintf('%slabel_%s.txt', input_dir, mon1));
        nf = size(data1, 2);
        fprintf('  data size = %dx%d, label size = %dx%d\n', size(data1), size(label1));

        for mj = mi+1:length(months)
            if mi == mj, continue; end

            mon2 = months{mj};
            if DEBUG2, fprintf('  > mon2=%s\n', mon2); end

            data2 = load(sprintf('%sdata_%s.mat.txt', input_dir, mon2));
            label2 = load(sprintf('%slabel_%s.txt', input_dir, mon2));
            fprintf('    data size = %dx%d, label size = %dx%d\n', size(data2), size(label2));

            %%%%%%%%%%%%%%%%%%%
            %% for each feature
            for fi = 1:nf
                kw(fi) = cal_kw(data1(:,fi), data2(:,fi));
                len = min([size(data1,1), size(data2,1)]);
                kw_p(fi) = kruskalwallis([data1(1:len,fi), data2(1:len,fi)]);

                h(fi)  = cal_hellinger(data1(:,fi), data2(:,fi));

                %% DEBUG
                [cdf1,x1] = ecdf(data1(:,fi));
                pdf1 = [cdf1(1); cdf1(2:end) - cdf1(1:end-1)];

                [cdf2,x2] = ecdf(data2(:,fi));
                pdf2 = [cdf2(1); cdf2(2:end) - cdf2(1:end-1)];

                fh = figure(1); clf;
                plot(x1, pdf1, '-r.'); hold on;
                plot(x2, pdf2, '-b.');
                print(fh, '-dpng', sprintf('%s%s.%s.f%d.png', fig_dir, mon1, mon2, fi));

                ks(fi) = cal_ks_cdf(x1, cdf1, x2, cdf2);
                ks_p(fi) = kstest2(data1(:,fi), data2(:,fi));
                fprintf('    f%d kw=%f, ks=%f\n', fi, kw(fi), ks(fi));
            end

            kw = kw - min(kw); kw = kw / max(kw);
            kw_p = kw_p - min(kw_p); kw_p = kw_p / max(kw_p);
            h = h - min(h); h = h / max(h);
            ks = ks - min(ks); ks = ks / max(ks);
            ks_p = ks_p - min(ks_p); ks_p = ks_p / max(ks_p);

            fh = figure(2); clf;
            plot(kw, '-r.'); hold on;
            plot(kw_p, '-b*');
            plot(ks, '-go');
            plot(ks_p, '-y^');
            plot(h, '-c.');
            legend('kw', 'kw_p', 'ks', 'ks_p', 'h', 'Location', 'Best');
            print(fh, '-dpng', sprintf('%s%s.%s.kw.png', fig_dir, mon1, mon2));
            %%%%%%%%%%%%%%%%%%%

        end
    end
end


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


function [h] = cal_hellinger(ts1, ts2)
    nb = 30;
    min_val = min([ts1; ts2]);
    max_val = max([ts1; ts2]);
    bs = (max_val - min_val) / nb;

    edges = min_val:bs:(max_val+bs);
    tmp = histogram(ts1, edges);
    h1 = tmp.Values;
    h1 = h1 / sum(h1);
    tmp = histogram(ts2, edges);
    h2 = tmp.Values;
    h2 = h2 / sum(h2);

    h = sum((sqrt(h1) - sqrt(h2)).^2);
end


function [ks] = cal_ks_cdf(x1, cdf1, x2, cdf2)
    % N = 1000;
    [x1,idx,~] = unique(x1);
    cdf1 = cdf1(idx);
    [x2,idx,~] = unique(x2);
    cdf2 = cdf2(idx);


    if length(x1) < 4 || length(x2) < 4
        ks = 1;
        return;
    end

    %% interpolate to get common x
    x_min = min([x1;x2]);
    x_max = max([x1;x2]);
    % x_step = (x_max-x_min)/N
    % x = x_min:x_step:(x_max+x_step);
    x = [x1; x2];
    x = unique(sort(x, 'ascend'));
    % x
    % x1
    cdf1_intp = interp1(x1,cdf1,x,'spline');
    cdf1_intp = min(1, cdf1_intp);
    cdf1_intp = max(0, cdf1_intp);
    cdf2_intp = interp1(x2,cdf2,x,'spline');
    cdf2_intp = min(1, cdf2_intp);
    cdf2_intp = max(0, cdf2_intp);

    dif = abs(cdf1_intp-cdf2_intp);
    ks = max(dif);
    % ks = median(dif);

    if isnan(ks)
        x
        cdf1
        cdf1_intp
        cdf2
        cdf2_intp
        error('[ERROR] find NaN!');
    end

    % fh = figure(3); clf;
    % subplot(2,1,1)
    % plot(x, cdf1_intp); hold on;
    % plot(x, cdf2_intp); hold on;
    % xlabel(sprintf('feature %d', fi))
    % ylabel('CDF')
    % title(sprintf('KS=%g', ks(fi+1)))

    % subplot(2,1,2);
    % plot(x1, pdf1); hold on;
    % plot(x2, pdf2);
    % xlabel(sprintf('feature %d', fi))
    % ylabel('PDF')
    % waitforbuttonpress;
end