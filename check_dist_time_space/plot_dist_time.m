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

function plot_dist_time(rerun)
    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results

    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    % colors   = {[228 26 28]/255, [55 126 184]/255, [77,175,74]/255, [152,78,163]/255, [255,127,0]/255, [255,255,51]/255, [166,86,40]/255, [247,129,191]/255, [153,153,153]/255};
    lines    = {'-', '--', '-.', ':'};
    markers  = {'+', 'o', '*', '.', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};



    %% --------------------
    %% Constant
    %% --------------------
    input_dir     = '../../data/sensor/';
    output_dir    = '../../data/check_dist_time_space/';
    plot_data_dir = '../plot/percom2017/data/feature_dist/';
    fig_dir       = './tmp/';

    months = {'201504', '201505', '201506', '201507', '201508', '201509', '201510', '201511', '201512', '201601', '201604', '201605', '201608'};
    % months = {'201504', '201505'};
    % months = {'201608'};
    features = [28:30, 64:66, 93, 106];
    % features = 1:108;


    %% --------------------
    %% Input Parameters
    %% --------------------
    if nargin < 1, rerun = 0; end


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
    nf = 108;

    if rerun
        %% --------------------
        %% Read Raw Data
        %% --------------------
        if DEBUG2, fprintf('Read Raw Data\n'); end

        for mi = 1:length(months)
            mon = months{mi};
            if DEBUG2, fprintf('  mon=%s\n', mon); end

            % data  = load(sprintf('%s.txt', filename));
            data = load_gz(sprintf('%sdata_%s.mat.txt.gz', input_dir, mon));
            label = load(sprintf('%slabel_%s.txt', input_dir, mon));
            nf = size(data, 2);
            fprintf('    data size = %dx%d, label size = %dx%d\n', size(data), size(label));

            for fi = 1:nf
                [cdfs{mi}{fi},xs{mi}{fi}] = ecdf(data(:,fi));
                pdfs{mi}{fi} = [cdfs{mi}{fi}(1); cdfs{mi}{fi}(2:end) - cdfs{mi}{fi}(1:end-1)];

                dlmwrite(sprintf('%smon%s.f%d.dist.txt', output_dir, mon, fi), [xs{mi}{fi}, cdfs{mi}{fi}, pdfs{mi}{fi}], 'delimiter', '\t');
                gzip(  sprintf('%smon%s.f%d.dist.txt', output_dir, mon, fi));
                delete(sprintf('%smon%s.f%d.dist.txt', output_dir, mon, fi));
            end

        end

    else
        %% --------------------
        %% Read CDF
        %% --------------------
        if DEBUG2, fprintf('Read CDF\n'); end

        for mi = 1:length(months)
            mon = months{mi};
            if DEBUG2, fprintf('mon=%s\n', mon); end

            % for fi = 1:nf
            for i = 1:length(features)
                fi = features(i);
                % tmp = load(sprintf('%smon%s.f%d.dist.txt', output_dir, mon, fi));
                tmp = load_gz(sprintf('%smon%s.f%d.dist.txt.gz', output_dir, mon, fi));
                xs{mi}{fi} = tmp(:,1);
                cdfs{mi}{fi} = tmp(:,2);
                pdfs{mi}{fi} = tmp(:,3);
            end
        end
    end

    plot_fig1(xs, pdfs, features, months, plot_data_dir);
    % pause
    plot_fig2(xs, pdfs, features, months, plot_data_dir);
    % pause
    plot_fig3(xs, pdfs, features, months, plot_data_dir);
    % pause

    %% --------------------
    %% Plot
    %% --------------------
    if DEBUG2, fprintf('Plot\n'); end

    % for fi = 1:nf
    for i = 1:length(features)
        fi = features(i);

        if DEBUG2, fprintf('  feature %d\n', fi); end

        fh = figure(1); clf;

        lh = [];
        legends = {};
        for mi = 1:length(months)
            % lh(mi) = plot(xs{mi}{fi}, cdfs{mi}{fi}, '-b.');
            lh(mi) = plot(xs{mi}{fi}, pdfs{mi}{fi}, '-b.');
            set(lh(mi), 'Color', colors{mod(mi-1,length(colors))+1});
            set(lh(mi), 'LineStyle', char(lines{mod(mi-1,length(lines))+1}));
            set(lh(mi), 'LineWidth', mod(mi*2, 7)+1);
            legends{mi} = months{mi};
            hold on;
        end
        legend(lh, legends, 'Location', 'Best');

        % print(fh, '-dpng', sprintf('%sf%d.dist.png', fig_dir, fi));
        % pause
    end

end


%% load_gz: function description
function [data] = load_gz(filename)
    rand_filename = gen_rand_name();
    copyfile(filename, sprintf('%s.gz', rand_filename));
    gunzip(sprintf('%s.gz', rand_filename));
    delete(sprintf('%s.gz', rand_filename));
    data = load(rand_filename);
    delete(rand_filename);
end


function plot_fig1(xs, pdfs, features, months, plot_data_dir)
    sel_f  = 28;
    sel_ms = {'201504', '201512', '201601', '201608'};

    fh = figure(1); clf;
    for mi = 1:length(sel_ms)
        sel_m = sel_ms{mi};
        [~,idx_m] = ismember(sel_m, months);

        ax = xs{idx_m}{sel_f};
        apdf = pdfs{idx_m}{sel_f};

        apdf = lrpf(apdf, 0.3);
        plot(ax, apdf, '-o'); hold on;

        dlmwrite(sprintf('%stime_dist.%s.f%d.txt', plot_data_dir, sel_m, sel_f), [ax, apdf], 'delimiter', '\t');
    end
    legend(sel_ms);

end

function plot_fig2(xs, pdfs, features, months, plot_data_dir)
    sel_f  = 64;
    sel_ms = {'201504', '201512', '201601', '201608'};

    fh = figure(1); clf;
    for mi = 1:length(sel_ms)
        sel_m = sel_ms{mi};
        [~,idx_m] = ismember(sel_m, months);

        ax = xs{idx_m}{sel_f};
        apdf = pdfs{idx_m}{sel_f};

        apdf = lrpf(apdf, 0.3);
        plot(ax, apdf, '-o'); hold on;

        dlmwrite(sprintf('%stime_dist.%s.f%d.txt', plot_data_dir, sel_m, sel_f), [ax, apdf], 'delimiter', '\t');
    end
    legend(sel_ms);
end

function plot_fig3(xs, pdfs, features, months, plot_data_dir)
    sel_f  = 93;
    sel_ms = {'201504', '201512', '201601', '201608'};

    fh = figure(1); clf;
    for mi = 1:length(sel_ms)
        sel_m = sel_ms{mi};
        [~,idx_m] = ismember(sel_m, months);

        ax = xs{idx_m}{sel_f};
        apdf = pdfs{idx_m}{sel_f};

        apdf = lrpf(apdf, 0.3);
        plot(ax, apdf, '-o'); hold on;

        dlmwrite(sprintf('%stime_dist.%s.f%d.txt', plot_data_dir, sel_m, sel_f), [ax, apdf], 'delimiter', '\t');
    end
    legend(sel_ms);
end
