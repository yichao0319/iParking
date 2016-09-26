%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% Input
%%  - nf: number of features
%%
%% example:
%%  cal_feature_score(201504, 201505, 'norm.fix', '', 108)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ks, score] = cal_feature_score(mon1, mon2, type, sensor, nf, PLOT)

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
    input_dir     = '../../data/feature_dist/';
    input_raw_dir = '../../data/sensor/';
    output_dir    = '../../data/check_dist/feature_score/';

    %% [NOTE] the order needs to be the same as that in "preprocess/feature_dist.py"
    months = [201504, 201505, 201506, 201507, 201508, 201509, 201510, 201511, 201512, 201601, 201604, 201605, 201608];
    bad_features = [13:15,28:30,34:36,49,64:69,73:84,88:93,103:108]; %% manually selected bad features to be ploted


    font_size = 18;
    colors   = {'r', 'm', [152,78,163]/255, 'b', 'g', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    % colors   = {[228 26 28]/255, [55 126 184]/255, [77,175,74]/255, [152,78,163]/255, [255,127,0]/255, [255,255,51]/255, [166,86,40]/255, [247,129,191]/255, [153,153,153]/255};
    lines    = {'-', '--', '--', '-', '--'};
    markers  = {'+', 'x', '*', 'o', '^', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};
    linewidths = [10,3,1,3,1];


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 6, PLOT = 0; end


    %% --------------------
    %% Main starts
    %% --------------------
    idx1 = find(months == mon1);
    idx2 = find(months == mon2);
    if length(idx1) > 1,
        error(sprintf('[ERROR] multiple month %d', mon1));
    end
    if length(idx2) > 1,
        error(sprintf('[ERROR] multiple month %d', mon2));
    end

    %% read raw data
    data1  = load(sprintf('%sdata_%d.mat.txt', input_raw_dir, mon1));
    label1 = load(sprintf('%slabel_%d.txt', input_raw_dir, mon1));

    data2  = load(sprintf('%sdata_%d.mat.txt', input_raw_dir, mon2));
    label2 = load(sprintf('%slabel_%d.txt', input_raw_dir, mon2));

    for fi = 0:(nf-1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Across Months
        filename = sprintf('%smonths_%s.%s.s0.f%d.txt', input_dir, sensor, type, fi);
        data = load(filename);

        x1   = data(:, (idx1-1)*2+1);
        pdf1 = data(:, idx1*2);
        x2   = data(:, (idx2-1)*2+1);
        pdf2 = data(:, idx2*2);

        %% KS
        method = 1;
        score(fi+1,method) = cal_ks_pdf(x1, pdf1, x2, pdf2);
        method = method + 1;
        score(fi+1,method) = kstest2(data1(:,fi+1), data2(:,fi+1));

        %% KW
        method = method + 1;
        score(fi+1,method) = cal_kw(data1(:,fi+1), data2(:,fi+1));
        % method = method + 1;
        % len = min([size(data1,1), size(data2,1)]);
        % score(fi+1,method) = kruskalwallis([data1(1:len,fi+1), data2(1:len,fi+1)]);

        %% Hellinger
        method = method + 1;
        score(fi+1,method) = cal_hellinger(data1(:,fi+1), data2(:,fi+1));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% positive v.s. negative events
        filename = sprintf('%smonths_%s.%s.s1.f%d.txt', input_dir, sensor, type, fi);
        data = load(filename);

        x_pos_1   = data(:, (idx1-1)*2+1);
        pdf_pos_1 = data(:, idx1*2);
        x_pos_2   = data(:, (idx2-1)*2+1);
        pdf_pos_2 = data(:, idx2*2);

        filename = sprintf('%smonths_%s.%s.s2.f%d.txt', input_dir, sensor, type, fi);
        data = load(filename);

        x_neg_1   = data(:, (idx1-1)*2+1);
        pdf_neg_1 = data(:, idx1*2);
        x_neg_2   = data(:, (idx2-1)*2+1);
        pdf_neg_2 = data(:, idx2*2);

        idx1_pos = find(label1 >= 0);
        idx1_neg = find(label1 < 0);
        idx2_pos = find(label2 >= 0);
        idx2_neg = find(label2 < 0);

        %% KS
        method = 1;
        score_mon1(fi+1,method) = cal_ks_pdf(x_pos_1, pdf_pos_1, x_neg_1, pdf_neg_1);
        score_mon2(fi+1,method) = cal_ks_pdf(x_pos_2, pdf_pos_2, x_neg_2, pdf_neg_2);

        method = method + 1;
        score_mon1(fi+1,method) = kstest2(data1(idx1_pos,fi+1), data1(idx1_neg,fi+1));
        score_mon2(fi+1,method) = kstest2(data2(idx2_pos,fi+1), data2(idx2_neg,fi+1));

        %% KW
        method = method + 1;
        score_mon1(fi+1,method) = cal_kw(data1(idx1_pos,fi+1), data1(idx1_neg,fi+1));
        score_mon2(fi+1,method) = cal_kw(data2(idx2_pos,fi+1), data2(idx2_neg,fi+1));

        % method = method + 1;
        % len1 = min([size(data1(idx1_pos,:),1), size(data1(idx1_neg,:),1)]);
        % len2 = min([size(data2(idx2_pos,:),1), size(data2(idx2_neg,:),1)]);
        % score_mon1(fi+1,method) = kruskalwallis([data1(idx1_pos(1:len1),fi+1), data1(idx1_neg(1:len1),fi+1)]);
        % score_mon2(fi+1,method) = kruskalwallis([data2(idx2_pos(1:len2),fi+1), data2(idx2_neg(1:len2),fi+1)]);

        %% Hellinger
        method = method + 1;
        score_mon1(fi+1,method) = cal_hellinger(data1(idx1_pos,fi+1), data1(idx1_neg,fi+1));
        score_mon2(fi+1,method) = cal_hellinger(data2(idx2_pos,fi+1), data2(idx2_neg,fi+1));
    end

    % idx = find(ks > 0);
    % score = zeros(size(ks));
    % score(idx) = ks_mon1(idx) ./ ks(idx) + ks_mon2(idx) ./ ks(idx);
    for si = 1:size(score,2)
        [score_sorted, score_idx] = sort(score(:,si), 'ascend');
        dlmwrite(sprintf('%s%d.%d.%s.%s.s%d.stable.txt', output_dir, mon1, mon2, sensor, type, si), [score_sorted, score_idx], 'delimiter', '\t');


        score_comb = (score_mon1(:,si) + score_mon2(:,si)) ./ (score(:,si)+0.1);
        [score_sorted, score_idx] = sort(score_comb, 'descend');
        dlmwrite(sprintf('%s%d.%d.%s.%s.s%d.combine.txt', output_dir, mon1, mon2, sensor, type, si), [score_idx, score_sorted], 'delimiter', '\t');

    end



    % if PLOT
    %     fh = figure(2); clf;
    %     subplot(2,1,1);
    %     plot(ks, '-ro');
    %     hold on;
    %     plot(ks_mon1, '--b+');
    %     plot(ks_mon2, ':g^');
    %     xlim([1 nf]);
    %     legend(sprintf('%d-%d', mon1, mon2), sprintf('%d pos-neg', mon1), sprintf('%d pos-neg', mon2));
    %     grid();

    %     subplot(2,1,2);
    %     plot(score, '-ro');
    %     hold on;
    %     if length(bad_features) > 0
    %         plot(bad_features, score(bad_features), 'bo');
    %     end
    %     xlim([1 nf]);
    %     grid();
    % end
end


function [ks] = cal_ks_pdf(x1, pdf1, x2, pdf2)
    N = 1000;

    cdf1 = cumsum(pdf1);
    cdf2 = cumsum(pdf2);

    %% interpolate to get common x
    x_min = min([x1;x2]);
    x_max = max([x1;x2]);
    x_step = (x_max-x_min)/N;
    x = x_min:x_step:(x_max+x_step);
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