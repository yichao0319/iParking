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
%%  visualize_err_toconfirm(4, 105353)
%%  visualize_err_toconfirm(4, 29279)
%%  visualize_err_toconfirm(4, 38857)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_err_toconfirm(mon, plot_idx)
    % addpath('../utils');

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
    input_dir = '../../data/sensor/';
    fig_dir   = '../../data/ml_weka/err/';



    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    plot_rng = 100;


    %% --------------------
    %% Check input
    %% --------------------
    % if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------
    features = load(sprintf('%sData_%d.mat.txt', input_dir, mon));
    labels   = load(sprintf('%slabel_%d.txt', input_dir, mon));
    nd = size(features, 1);
    nf = size(features, 2);

    fprintf('  #data=%d\n', nd);
    fprintf('  #features=%d\n', nf);

    std_idx = max(1, plot_idx-plot_rng);
    end_idx = min(nd, plot_idx+plot_rng);

    h = 4;
    w = 3;
    nfig = ceil(nf/h/w);

    for i = 1:nfig
        fig_idx = fig_idx + 1;
        fh = figure(fig_idx); clf;

        for hi = 1:h
            for wi = 1:w
                subfig_idx = (i-1)*h*w + (hi-1)*w + wi;
                if subfig_idx > nf; break; end

                subplot(h,w,(hi-1)*w+wi);
                plot(features(std_idx:end_idx, subfig_idx), '-b');
                hold on;
                idx = find(labels > 0);
                idx = idx(find(idx>=std_idx & idx<=end_idx));
                if length(idx) > 0
                    plot(idx-std_idx+1, features(idx, subfig_idx), 'ro');
                end
                set(gca, 'XLim', [1 2*plot_rng]);
            end
        end
        print(fh, '-dpsc', sprintf('%sdata_%d.%d.%d.eps', fig_dir, mon, plot_idx, i));
        % print(fh, '-dpng', sprintf('%sdata_%d.%d.%d.png', fig_dir, mon, plot_idx, i));
        break
    end
end