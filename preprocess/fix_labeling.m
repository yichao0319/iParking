%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% example:
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fix_labeling

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

    fix_rng  = 7;
    fix_base = 7;  %% feature idx used for fixing

    mons = [201504:201507, 201605];
    % mons = [4];

    %% --------------------
    %% Check input
    %% --------------------
    % if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------


    for mi = 1:length(mons)
        mon = mons(mi);
        %% --------------------
        %% read feature file
        %% --------------------
        if DEBUG2, fprintf('read feature file\n'); end

        features{mon} = load(sprintf('%sdata_%d.mat.txt', input_dir, mon));
        % features = abs(features);
        nf = size(features{mon}, 2);
        nd{mon} = size(features{mon}, 1);

        if mi == 1
            min_feature = ones(1,nf) * Inf;
            max_feature = ones(1,nf) * -Inf;
        end


        if DEBUG2,
            fprintf('  #features = %d\n', nf);
            fprintf('  #data     = %d\n', nd{mon});
        end

        %% --------------------
        %% Find max / min
        %% --------------------
        min_feature = min([min_feature; features{mon}(:, 1:nf)]);
        max_feature = max([max_feature; features{mon}(:, 1:nf)]);


        %% --------------------
        %% read label file
        %% --------------------
        if DEBUG2, fprintf('read label file\n'); end

        labels{mon} = load(sprintf('%slabel_%d.txt', input_dir, mon));

        if DEBUG2,
            fprintf('  #data = %d\n', length(labels{mon}));
            fprintf('  #pos=%d, #neg=%d\n', length(find(labels{mon}>0)), length(find(labels{mon}<=0)));
        end
    end

    max_feature = max_feature - min_feature;
    idx = find(max_feature == 0);
    max_feature(idx) = 1;


    for mi = 1:length(mons)
        mon = mons(mi);
        %% --------------------
        %% Normalize the features
        %% --------------------
        if DEBUG2, fprintf('Normalize the features\n'); end

        % features(:, 1:nf) = features(:, 1:nf) - repmat(min(features(:, 1:nf)), nd, 1);
        % features(:, 1:nf) = features(:, 1:nf) ./ repmat(max(features(:, 1:nf)), nd, 1);
        features{mon}(:, 1:nf) = features{mon}(:, 1:nf) - repmat(min_feature, nd{mon}, 1);
        features{mon}(:, 1:nf) = features{mon}(:, 1:nf) ./ repmat(max_feature, nd{mon}, 1);
        features_norm = features{mon};


        %% --------------------
        %% Clean Labels
        %% --------------------
        if DEBUG2, fprintf('Clean Labels\n'); end

        idx_pos = find(labels{mon} == 1);
        idx_neg = find(labels{mon} == -1);

        fig_idx = fig_idx + 1;
        plot_num = 4;
        plot_rng = 50;
        labels_fixed = labels{mon};
        good_feature_idx = [2, 7, 8, 9, 10];

        for posi = 1:length(idx_pos)
            idx = idx_pos(posi);
            std_idx = max(1, idx-plot_rng);
            end_idx = min(nd{mon}, idx+plot_rng);

            fix_std_idx = max(1, idx-fix_rng);
            fix_end_idx = min(nd{mon}, idx+fix_rng);

            diffs = abs(features{mon}(idx, :) - median(features{mon}(std_idx:end_idx, :), 1));
            [~,feature_rank_idx] = sort(diffs, 'descend');

            [~,fixed_idx] = max(features{mon}(fix_std_idx:fix_end_idx, fix_base));
            fixed_idx = fixed_idx + fix_std_idx - 1;
            if fixed_idx ~= idx
                labels_fixed(idx) = -1;
                labels_fixed(fixed_idx) = 1;
            end

            label_idx = find(labels{mon}(std_idx:end_idx) == 1);
            fixed_label_idx = find(labels_fixed(std_idx:end_idx) == 1);

            fh = figure(fig_idx); clf;
            for ploti = 1:plot_num
                % sel_feature_idx = feature_rank_idx(ploti);
                sel_feature_idx = good_feature_idx(ploti);
                subplot(plot_num,1,ploti);
                plot(features{mon}(std_idx:end_idx, sel_feature_idx), '-b.');
                hold on;
                plot(label_idx, features{mon}(std_idx+label_idx-1, sel_feature_idx), 'ro');
                plot(fixed_label_idx, features{mon}(std_idx+fixed_label_idx-1, sel_feature_idx), 'gx');
                title(sprintf('%d/%d: feature %d', posi, length(idx_pos), sel_feature_idx));
            end
            % pause()
        end

        dlmwrite(sprintf('%slabel_%d.fix.txt', output_dir, mon), labels_fixed, 'delimiter', '\t');
        dlmwrite(sprintf('%sdata_%d.norm.mat.txt', output_dir, mon), features_norm, 'delimiter', ',');
    end

end
