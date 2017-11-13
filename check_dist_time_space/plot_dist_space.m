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

function plot_dist_space(rerun)
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
    input_dir  = '../../data/check_dist_time_space/mat_space/';
    output_dir = '../../data/check_dist_time_space/';
    plot_data_dir = '../plot/percom2017/data/feature_dist/';
    fig_dir    = './tmp/';

    spots = {'201504.408_103', '201504.410_107', '201504.412_108', '201504.414_114', '201504.416_115', '201504.417_110', '201504.424_109'};
    % features = [13:15, 28:36, 64:69, 79:83, 88, 93:94, 106:107];
    features = [66 79:83];


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

        for si = 1:length(spots)
            spot = spots{si};
            if DEBUG2, fprintf('  spot=%s\n', spot); end

            data  = load_gz(sprintf('%s%s.mat.txt.gz', input_dir, spot));
            label = load(sprintf('%s%s.label.txt', input_dir, spot));
            nf = size(data, 2);
            fprintf('    data size = %dx%d, label size = %dx%d\n', size(data), size(label));

            for fi = 1:nf
                [cdfs{si}{fi},xs{si}{fi}] = ecdf(data(:,fi));
                pdfs{si}{fi} = [cdfs{si}{fi}(1); cdfs{si}{fi}(2:end) - cdfs{si}{fi}(1:end-1)];

                dlmwrite(sprintf('%s%s.f%d.dist.txt', output_dir, spot, fi), [xs{si}{fi}, cdfs{si}{fi}, pdfs{si}{fi}], 'delimiter', '\t');
                gzip(  sprintf('%s%s.f%d.dist.txt', output_dir, spot, fi));
                delete(sprintf('%s%s.f%d.dist.txt', output_dir, spot, fi));
            end

        end

    else
        %% --------------------
        %% Read CDF
        %% --------------------
        if DEBUG2, fprintf('Read CDF\n'); end

        for si = 1:length(spots)
            spot = spots{si};
            if DEBUG2, fprintf('  spot=%s\n', spot); end

            % for fi = 1:nf
            for i = 1:length(features)
                fi = features(i);

                tmp = load_gz(sprintf('%s%s.f%d.dist.txt.gz', output_dir, spot, fi));
                xs{si}{fi} = tmp(:,1);
                cdfs{si}{fi} = tmp(:,2);
                pdfs{si}{fi} = tmp(:,3);
            end
        end
    end


    plot_fig1(xs, pdfs, features, spots, plot_data_dir);
    % pause;
    plot_fig2(xs, pdfs, features, spots, plot_data_dir);
    % pause;

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
        for si = 1:length(spots)
            % lh(si) = plot(xs{si}{fi}, cdfs{si}{fi}, '-b.');
            lh(si) = plot(xs{si}{fi}, pdfs{si}{fi}, '-b.');

            set(lh(si), 'Color', colors{mod(si-1,length(colors))+1});
            set(lh(si), 'LineStyle', char(lines{mod(si-1,length(lines))+1}));
            set(lh(si), 'LineWidth', mod(si*2, 7)+1);
            hold on;
        end
        legend(spots);
        % pause
        % print(fh, '-dpng', sprintf('%sspace.f%d.dist.png', fig_dir, fi));
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

function plot_fig1(xs, pdfs, features, spots, plot_data_dir)
    sel_f  = 66;
    sel_ss = {'201504.412_108', '201504.414_114', '201504.417_110', '201504.424_109'};

    fh = figure(1); clf;
    for mi = 1:length(sel_ss)
        sel_s = sel_ss{mi};
        [~,idx_m] = ismember(sel_s, spots);

        ax = xs{idx_m}{sel_f};
        apdf = pdfs{idx_m}{sel_f};

        apdf = lrpf(apdf, 0.3);
        plot(ax, apdf, '-o'); hold on;

        dlmwrite(sprintf('%sspace_dist.%s.f%d.txt', plot_data_dir, sel_s, sel_f), [ax, apdf], 'delimiter', '\t');
    end
    legend(sel_ss);
end

function plot_fig2(xs, pdfs, features, spots, plot_data_dir)
    sel_f  = 79;
    sel_ss = {'201504.412_108', '201504.414_114', '201504.417_110', '201504.424_109'};
    % sel_ss = {'201504.408_103', '201504.410_107', '201504.412_108', '201504.414_114', '201504.416_115', '201504.417_110', '201504.424_109'};

    fh = figure(1); clf;
    for mi = 1:length(sel_ss)
        sel_s = sel_ss{mi};
        [~,idx_m] = ismember(sel_s, spots);

        ax = xs{idx_m}{sel_f};
        apdf = pdfs{idx_m}{sel_f};

        % min_x = min(ax);
        % max_x = max(ax);
        % stp = 10;
        % new_x = min_x:stp:(max_x+stp/2);
        % new_pdf = [];
        % for xi = 1:length(new_x)
        %     if xi == length(new_x)
        %         idx = find(ax >= new_x(xi));
        %     else
        %         idx = find(ax >= new_x(xi) & ax < new_x(xi+1));
        %     end
        %     new_pdf(xi) = sum(apdf(idx));
        % end

        apdf = lrpf(apdf, 0.3);
        plot(ax, apdf, '-o'); hold on;
        % apdf = lrpf(new_pdf, 0.3);
        % plot(new_x, new_pdf, '-o'); hold on;
        dlmwrite(sprintf('%sspace_dist.%s.f%d.txt', plot_data_dir, sel_s, sel_f), [ax, apdf], 'delimiter', '\t');
    end
    legend(sel_ss);
end
