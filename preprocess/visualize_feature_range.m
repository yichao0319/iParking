%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% example:
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_feature_range()

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
    % output_dir = '../../data/';


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

    %% --------------------
    %% read feature file
    %% --------------------
    if DEBUG2, fprintf('read feature file\n'); end

    features = load(sprintf('%sdata_mat.txt', input_dir));
    % features = abs(features);
    nf = size(features, 2);

    if DEBUG2,
        fprintf('  # features =%d\n', nf);
        fprintf('  # data     =%d\n', size(features,1));
    end


    %% --------------------
    %% read label file
    %% --------------------
    if DEBUG2, fprintf('read label file\n'); end

    labels = load(sprintf('%slabel_mat.txt', input_dir));

    if DEBUG2,
        fprintf('  #pos=%d, #neg=%d\n', length(find(labels>0)), length(find(labels<=0)));
    end


    %% --------------------
    %% Calculate feature ranges
    %% --------------------
    if DEBUG2, fprintf('Calculate feature ranges\n'); end

    idx_pos = find(labels == 1);
    idx_neg = find(labels == -1);

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

    dlmwrite(['./tmp/features.range.txt'], [avg_pos;med_pos;std_pos;max_pos;min_pos;avg_neg;med_neg;std_neg;max_neg;min_neg;]', 'delimiter', '\t');



    % fig_idx = fig_idx + 1;
    % fh = figure(fig_idx); clf;
    % bar([avg_pos' avg_neg'])
    % hold on
    % lh = errorbar([1:nf]-0.1, avg_pos, std_pos, 'b.');
    % lh = errorbar([1:nf]+0.1, avg_neg, std_neg, 'r.');
    % xlim([0 nf+1]);


    %% --------------------
    %% Plot feature
    %% --------------------
    if DEBUG2, fprintf('Plot feature\n'); end

    PLOT_FEATURE = 1;

    if PLOT_FEATURE
        pos_idx = find(labels == 1);
        fidx = 28;
        % for xi = 1:length(pos_idx)
        for xi = 1:65
            if xi > 1
                if pos_idx(xi)-pos_idx(xi-1) == 1
                    continue;
                end
            end

            std_idx = max(1, pos_idx(xi)-100);
            end_idx = min(size(features,1), pos_idx(xi)+100);
            f_ts = features(std_idx:end_idx,fidx);
            l_ts = labels(std_idx:end_idx);

            fig_idx = fig_idx + 1;
            fh = figure(fig_idx); clf;

            plot(f_ts, '-b.');
            hold on;
            idx = find(l_ts == 1);
            plot(idx, f_ts(idx), 'ro');
            print(fh, '-dpng', sprintf('tmp/feaure28_ts%2d.png', pos_idx(xi)));
            % pause
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Simple classification test
    if DEBUG2, fprintf('Simple classification test\n'); end

    gtruth = labels;
    gtruth(find(labels>0)) = 1;
    gtruth(find(labels<=0)) = 0;
    est = zeros(size(gtruth));
    est_pos_idx = [];
    for ni = 1:nf
        if max_pos(ni) > max_neg(ni)
            idx = find(features(:,ni) > max_neg(ni));
            fprintf('  feautre %d: >, %d/%d\n', ni, length(idx), length(find(labels>0)));
            est_pos_idx = [est_pos_idx; idx];
        elseif min_pos(ni) < min_neg(ni)
            idx = find(features(:,ni) < min_neg(ni));
            fprintf('  feautre %d: <, %d/%d\n', ni, length(idx), length(find(labels>0)));
            est_pos_idx = [est_pos_idx; idx];
        end
    end
    est(est_pos_idx) = 1;
    evalute_est(est, gtruth);
    evalute_est2(est, gtruth, 10, features, 10);
    % return
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find(gtruth==1)'
    % find(est==1)'
end
