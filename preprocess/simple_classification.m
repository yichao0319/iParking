%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% example:
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tp, tn, fp, fn, precision, recall, fscore] = simple_classification(ratio)

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
    output_dir = '../../data/sensor/';


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, ratio = 1; end


    %% --------------------
    %% Main starts
    %% --------------------

    %% --------------------
    %% read feature file
    %% --------------------
    if DEBUG2, fprintf('read feature file\n'); end

    mons = [4,5];
    for mi = 1:length(mons)
        mon = mons(mi);
        tmp = load(sprintf('%sdata_%d.mat.txt', input_dir, mon));

        if mi == 1
            features = tmp;
        else
            features = [features; tmp];
        end
    end
    % features = abs(features);
    nt = size(features, 1);
    nf = size(features, 2);

    if DEBUG2,
        fprintf('  # features =%d\n', nf);
        fprintf('  # data     =%d\n', nt);
    end


    %% --------------------
    %% read label file
    %% --------------------
    if DEBUG2, fprintf('read label file\n'); end

    for mi = 1:length(mons)
        mon = mons(mi);
        tmp = load(sprintf('%slabel_%d.txt', input_dir, mon));

        if mi == 1
            labels = tmp;
        else
            labels = [labels; tmp];
        end
    end

    if DEBUG2,
        fprintf('  #pos=%d, #neg=%d\n', length(find(labels>0)), length(find(labels<=0)));
    end


    %% --------------------
    %% Calculate feature ranges
    %% --------------------
    if DEBUG2, fprintf('Calculate feature ranges\n'); end

    % idx_pos = find(labels == 1);
    % idx_neg = find(labels == -1);
    tmp_labels = zeros(size(labels));
    tmp_labels(find(labels>0)) = 1;
    rnge = ceil(60*10/7.5);
    idx_pos = [];
    idx_neg = [];
    for ti = 1:nt
        std_idx = max(1, ti-rnge);
        end_idx = min(nt, ti+rnge);

        this_label = sum(tmp_labels(std_idx:end_idx));
        if this_label > 0
            idx_pos = [idx_pos, ti];
        else
            idx_neg = [idx_neg, ti];
        end
    end

    for ni = 1:nf
        %% positive
        avg_pos(ni) = mean(features(idx_pos,ni));
        med_pos(ni) = median(features(idx_pos,ni));
        std_pos(ni) = std(features(idx_pos,ni));
        max_pos(ni) = max(features(idx_pos,ni));
        min_pos(ni) = min(features(idx_pos,ni));

        %% negative
        avg_neg(ni) = mean(features(idx_neg,ni));
        med_neg(ni) = median(features(idx_neg,ni));
        std_neg(ni) = std(features(idx_neg,ni));
        max_neg(ni) = max(features(idx_neg,ni));
        min_neg(ni) = min(features(idx_neg,ni));
    end

    % dlmwrite(['./tmp/features.range.txt'], [avg_pos;med_pos;std_pos;max_pos;min_pos;avg_neg;med_neg;std_neg;max_neg;min_neg;]', 'delimiter', '\t');


    %% --------------------
    %% Plot feature
    %% --------------------
    % if DEBUG2, fprintf('Plot feature\n'); end

    % pos_idx = find(labels == 1);
    % fidx = 28;
    % for xi = 1:length(pos_idx)
    %     std_idx = max(1, pos_idx(xi)-100);
    %     end_idx = min(size(features,1), pos_idx(xi)+100);
    %     f_ts = features(std_idx:end_idx,fidx);
    %     l_ts = labels(std_idx:end_idx);

    %     fig_idx = fig_idx + 1;
    %     fh = figure(fig_idx); clf;

    %     plot(f_ts, '-b.');
    %     hold on;
    %     idx = find(l_ts == 1);
    %     plot(idx, f_ts(idx), 'ro');
    %     print(fh, '-dpng', sprintf('tmp/feaure28_ts%2d.png', xi));
    % end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Simple classification test
    if DEBUG2, fprintf('Simple classification test\n'); end

    gtruth = labels;
    gtruth(find(labels>0)) = 1;
    gtruth(find(labels<=0)) = 0;
    est = zeros(size(gtruth));
    est_pos_idx = [];
    % ratio = 1;
    thresh = ones(1,nf)*Inf;
    for ni = 1:nf
        if max_pos(ni) > max_neg(ni)
            % thresh(ni) = max_neg(ni);
            % idx = find(features(:,ni) > thresh(ni));
            thresh(ni) = find_max_thresh(features(idx_pos,ni), features(idx_neg,ni), ratio);
            idx = find(features(:,ni) >= thresh(ni));
            fprintf('  feautre %d: > %g, %d/%d\n', ni, thresh(ni), length(idx), length(find(labels>0)));
            est_pos_idx = [est_pos_idx; idx];
        elseif min_pos(ni) < min_neg(ni)
            % thresh(ni) = min_neg(ni);
            % idx = find(features(:,ni) < thresh(ni));
            thresh(ni) = find_min_thresh(features(idx_pos,ni), features(idx_neg,ni), ratio);
            idx = find(features(:,ni) <= thresh(ni));
            fprintf('  feautre %d: < %g, %d/%d\n', ni, thresh(ni), length(idx), length(find(labels>0)));
            est_pos_idx = [est_pos_idx; idx];
        end
    end
    est(est_pos_idx) = 1;
    evalute_est(est, gtruth);
    [tp, tn, fp, fn, precision, recall, fscore] = evalute_est2(est, gtruth, rnge, features, thresh);
    % return
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find(gtruth==1)'
    % find(est==1)'
end



function [thresh] = find_max_thresh(f_pos, f_neg, ratio);
    f_pos = unique(sort(f_pos));

    thresh = max(f_pos);
    for ni = 1:length(f_pos)
        val = f_pos(ni);
        num = length(find(f_neg < val));

        if (num/length(f_neg)) >= ratio
            thresh = val;
            break;
        end
    end


end

function [thresh] = find_min_thresh(f_pos, f_neg, ratio);
    f_pos = unique(sort(f_pos, 'descend'));

    thresh = min(f_pos);
    for ni = 1:length(f_pos)
        val = f_pos(ni);
        num = length(find(f_neg > val));

        if (num/length(f_neg)) >= ratio
            thresh = val;
            break;
        end
    end


end
