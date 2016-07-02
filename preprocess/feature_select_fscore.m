

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% example:
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function feature_select_fscore()

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
    input_dir  = '../../data/';
    output_dir = '../../data/';


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

    features = load(sprintf('%sdata_mat.txt', input_dir));
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

    labels = load(sprintf('%slabel_mat.txt', input_dir));

    if DEBUG2,
        fprintf('  #pos=%d, #neg=%d\n', length(find(labels>0)), length(find(labels<=0)));
    end


    %% --------------------
    %% Calculate feature Fscore
    %% --------------------
    if DEBUG2, fprintf('Calculate feature Fscore\n'); end

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


    gtruth = zeros(1,nt);
    gtruth(idx_pos) = 1;
    fscore = zeros(nf,1);
    for ni = 1:nf
        fscore(ni) = feature_fscore(features(:,ni), gtruth);
    end

    dlmwrite('./tmp/feature_select_fscore.txt', [fscore], 'delimiter', '\t');

end



function [fscore] = feature_fscore(features, labels)

    idx_pos = find(labels > 0);
    idx_neg = find(labels <= 0);

    n_pos = length(idx_pos);
    n_neg = length(idx_neg);

    x = mean(features);
    x_pos = mean(features(idx_pos));
    x_neg = mean(features(idx_neg));

    term1 = ((x_pos - x)^2 + (x_neg - x)^2);
    term2 = mean((features(idx_pos) - x_pos).^2);
    term3 = mean((features(idx_neg) - x_neg).^2);
    fscore = term1 / (term2 + term3);
end
