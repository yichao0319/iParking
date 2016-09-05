%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% Input
%%  - nf: number of features
%%  - ntf: number of top features to select
%%
%% example:
%%  find_best_train_mon('norm.fix', '', 90, 50)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function find_best_train_mon(type, sensor, nf, ntf)

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
    input_dir = '';
    output_dir = '../../data/check_dist/feature_score/';
    months = [201504, 201505, 201506, 201507, 201604, 201605];



    font_size = 18;
    colors   = {'r', 'm', [152,78,163]/255, 'b', 'g', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    % colors   = {[228 26 28]/255, [55 126 184]/255, [77,175,74]/255, [152,78,163]/255, [255,127,0]/255, [255,255,51]/255, [166,86,40]/255, [247,129,191]/255, [153,153,153]/255};
    lines    = {'-', '--', '--', '-', '--'};
    markers  = {'+', 'x', '*', 'o', '^', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};
    % linewidths = [10,3,1,3,1];


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
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    for mi1 = 1:length(months)
        for mi2 = 1:length(months)
            [ks{mi1, mi2}, score{mi1, mi2}] = cal_ks_value(months(mi1), months(mi2), type, sensor, nf, 0);
            tmp_sorted_ks = sort(ks{mi1, mi2});
            avg_ks(mi1, mi2) = mean(tmp_sorted_ks(1:ntf));
        end
        legends{mi1} = sprintf('%d', months(mi1));
        lh(mi1) = plot(avg_ks(mi1, :));
        set(lh(mi1), 'Color', colors{mod(mi1-1,length(colors))+1});
        set(lh(mi1), 'LineStyle', char(lines{mod(mi1-1,length(lines))+1}));
        set(lh(mi1), 'LineWidth', 4);
        %% marker: +|o|*|.|x|s|d|^|>|<|p|h
        set(lh(mi1), 'marker', markers{mod(mi1-1,length(markers))+1});
        set(lh(mi1), 'MarkerSize', 10);
        hold on;

        [v,idx] = sort(avg_ks(mi1, :));
        fprintf('month %d, 1st month %d (%f), 2nd month %d (%f)\n', months(mi1), months(idx(1)), v(1), months(idx(2)), v(2));
    end
    set(gca, 'FontSize', font_size);
    legend(lh, legends, 'Location', 'Best');

    avg_ks
    % [~,tmpidx] = min(mean(avg_ks,2));
    % months(tmpidx)

end
