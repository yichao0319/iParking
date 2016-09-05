%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% Input
%%  - nf: number of features
%%
%% example:
%%  cal_ks_value(201504, 201505, 'norm.fix', '', 108)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ks, score] = cal_ks_value(mon1, mon2, type, sensor, nf, PLOT)

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
    input_dir  = '../../data/feature_dist/';
    output_dir = '../../data/check_dist/feature_score/';
    months = [201504, 201505, 201506, 201507, 201604, 201605];
    bad_features = [13:15,28:30,34:36,49,64:69,73:84,88:93,103:108]; %% manually selected bad features


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


    for fi = 0:(nf-1)
        filename = sprintf('%smonths_%s.%s.s0.f%d.txt', input_dir, sensor, type, fi);
        data = load(filename);

        x1   = data(:, (idx1-1)*2+1);
        pdf1 = data(:, idx1*2);
        x2   = data(:, (idx2-1)*2+1);
        pdf2 = data(:, idx2*2);

        ks(fi+1) = cal_ks_pdf(x1, pdf1, x2, pdf2);


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

        ks_mon1(fi+1) = cal_ks_pdf(x_pos_1, pdf_pos_1, x_neg_1, pdf_neg_1);
        ks_mon2(fi+1) = cal_ks_pdf(x_pos_2, pdf_pos_2, x_neg_2, pdf_neg_2);
    end

    % idx = find(ks > 0);
    % score = zeros(size(ks));
    % score(idx) = ks_mon1(idx) ./ ks(idx) + ks_mon2(idx) ./ ks(idx);
    score = ks_mon1 ./ (ks+0.1) + ks_mon2 ./ (ks+0.1);
    [score_sorted, score_idx] = sort(score, 'descend');

    [ks_sorted, ks_idx] = sort(ks, 'ascend');

    dlmwrite(sprintf('%s%d.%d.%s.%s.combine.txt', output_dir, mon1, mon2, sensor, type), [score_idx', score_sorted'], 'delimiter', '\t');
    dlmwrite(sprintf('%s%d.%d.%s.%s.stable.txt', output_dir, mon1, mon2, sensor, type), [ks_idx', ks_sorted'], 'delimiter', '\t');



    if PLOT
        fh = figure(2); clf;
        subplot(2,1,1);
        plot(ks, '-ro');
        hold on;
        plot(ks_mon1, '--b+');
        plot(ks_mon2, ':g^');
        xlim([1 nf]);
        legend(sprintf('%d-%d', mon1, mon2), sprintf('%d pos-neg', mon1), sprintf('%d pos-neg', mon2));
        grid();

        subplot(2,1,2);
        plot(score, '-ro');
        hold on;
        if length(bad_features) > 0
            plot(bad_features, score(bad_features), 'bo');
        end
        xlim([1 nf]);
        grid();
    end
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