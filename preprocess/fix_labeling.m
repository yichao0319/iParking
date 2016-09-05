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

    INVALID = 32767;


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;

    fix_rng  = 7;
    fix_base = 7;  %% feature idx used for fixing

    mons = [201504:201507 201604 201605];
    % mons = [201604 201605];
    sensors = {'data', 'lora', 'light'};
    % mons = [4];

    %% --------------------
    %% Check input
    %% --------------------
    % if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------

    %% Initialization
    for si = 1:length(sensors)
        max_feature{si} = [];
    end

    %% Start to load and get max/min
    for mi = 1:length(mons)
        mon = mons(mi);

        %% --------------------
        %% read label file
        %% --------------------
        if DEBUG2, fprintf('read %d label file\n', mon); end

        labels{mi} = load(sprintf('%slabel_%d.txt', input_dir, mon));

        if DEBUG2,
            fprintf('  #data = %d\n', length(labels{mi}));
            fprintf('  #pos=%d, #neg=%d\n', length(find(labels{mi}>0)), length(find(labels{mi}<=0)));
        end


        for si = 1:length(sensors)
            sensor = char(sensors{si});

            %% --------------------
            %% read feature file
            %% --------------------
            if DEBUG2, fprintf('read %d %s feature file\n', mon, sensor); end

            filename = sprintf('%s%s_%d.mat.txt', input_dir, sensor, mon);
            if ~exist(filename),
                if DEBUG2, fprintf('  [MISS]\n', mon, sensor); end
                features{mi}{si} = [];
                continue;
            end

            features{mi}{si} = load(filename);
            % features = abs(features);
            nf = size(features{mi}{si}, 2);
            nd{mi}{si} = size(features{mi}{si}, 1);

            if DEBUG2,
                fprintf('  #features = %d\n', nf);
                fprintf('  #data     = %d\n', nd{mi}{si});
            end


            %% --------------------
            %% Find Valid Rows
            %% --------------------
            invalid_idx = find([features{mi}{si}]' == INVALID);
            invalid_idx = unique(floor(invalid_idx / nf) + 1);
            valid_idx{mi}{si} = setxor(1:nd{mi}{si}, invalid_idx);


            %% --------------------
            %% Find max / min
            %% --------------------
            if length(max_feature{si}) == 0
                min_feature{si} = ones(1,nf) * Inf;
                max_feature{si} = ones(1,nf) * -Inf;
            end

            min_feature{si} = min([min_feature{si}; features{mi}{si}(valid_idx{mi}{si},:)]);
            max_feature{si} = max([max_feature{si}; features{mi}{si}(valid_idx{mi}{si},:)]);

        end
    end

    for si = 1:length(sensors)
        if length(max_feature{si}) == 0, continue; end

        max_feature{si} = max_feature{si} - min_feature{si};
        idx = find(max_feature{si} == 0);
        max_feature{si}(idx) = 1;
    end


    for mi = 1:length(mons)
        mon = mons(mi);
        for si = 1:length(sensors)
            sensor = char(sensors{si});

            if size(features{mi}{si},1)==0, continue; end


            %% --------------------
            %% Normalize the features
            %% --------------------
            if DEBUG2, fprintf('Normalize the features: %d %s\n', mon, sensor); end

            features{mi}{si} = features{mi}{si} - repmat(min_feature{si}, nd{mi}{si}, 1);
            features{mi}{si} = features{mi}{si} ./ repmat(max_feature{si}, nd{mi}{si}, 1);

            dlmwrite(sprintf('%s%s_%d.norm.mat.txt', output_dir, sensor, mon), features{mi}{si}, 'delimiter', ',');


            %% --------------------
            %% Clean Labels: based on the first sensor
            %% --------------------
            if si == 1
                if DEBUG2, fprintf('Clean Labels\n'); end

                idx_pos = find(labels{mi} == 1);
                idx_neg = find(labels{mi} == -1);

                fig_idx = fig_idx + 1;
                plot_num = 4;
                plot_rng = 50;
                labels_fixed = labels{mi};
                good_feature_idx = [2, 7, 8, 9, 10];
                new_idx = -1;

                for posi = 1:length(idx_pos)
                    idx = idx_pos(posi);

                    std_idx = max(1, idx-plot_rng);
                    end_idx = min(nd{mi}{si}, idx+plot_rng);

                    fix_std_idx = max(1, idx-fix_rng);
                    fix_end_idx = min(nd{mi}{si}, idx+fix_rng);

                    diffs = abs(features{mi}{si}(idx, :) - median(features{mi}{si}(std_idx:end_idx, :), 1));
                    [~,feature_rank_idx] = sort(diffs, 'descend');

                    [~,fixed_idx] = max(features{mi}{si}(fix_std_idx:fix_end_idx, fix_base));
                    fixed_idx = fixed_idx + fix_std_idx - 1;

                    if posi > 1 & (idx - idx_pos(posi-1)) <= 2
                        %% skip continuous events
                        labels_fixed(idx) = -1;
                        labels_fixed(new_idx) = 1;
                    else
                        %% find nearby peak as the new position of the event
                        labels_fixed(idx) = -1;
                        labels_fixed(fixed_idx) = 1;
                        new_idx = fixed_idx;
                    end

                    label_idx = find(labels{mi}(std_idx:end_idx) == 1);
                    fixed_label_idx = find(labels_fixed(std_idx:end_idx) == 1);


                    fh = figure(fig_idx); clf;
                    for ploti = 1:plot_num
                        % sel_feature_idx = feature_rank_idx(ploti);
                        sel_feature_idx = good_feature_idx(ploti);
                        subplot(plot_num,1,ploti);
                        plot(features{mi}{si}(std_idx:end_idx, sel_feature_idx), '-b.');
                        hold on;
                        lh = plot(label_idx, features{mi}{si}(std_idx+label_idx-1, sel_feature_idx), 'ro');
                        set(lh, 'MarkerSize', 10);
                        lh = plot(fixed_label_idx, features{mi}{si}(std_idx+fixed_label_idx-1, sel_feature_idx), 'gx');
                        set(lh, 'MarkerSize', 10);
                        lh = plot(new_idx-std_idx+1, features{mi}{si}(new_idx, sel_feature_idx), 'm^');
                        set(lh, 'MarkerSize', 15);
                        title(sprintf('%d/%d: feature %d', posi, length(idx_pos), sel_feature_idx));
                    end
                    % pause()
                    % waitforbuttonpress
                end

                dlmwrite(sprintf('%slabel_%d.fix.txt', output_dir, mon), labels_fixed, 'delimiter', '\t');
            end


            %% --------------------
            %% Remove Invalide Rows from Lora and Light
            %% --------------------
            if strcmp(sensor, 'lora') | strcmp(sensor, 'light')
                if DEBUG2, fprintf('Remove Invalide Rows from Lora and Light\n'); end

                dlmwrite(sprintf('%s%s_%d.norm.valid.mat.txt', output_dir, sensor, mon), features{mi}{si}(valid_idx{mi}{si},:), 'delimiter', ',');
                dlmwrite(sprintf('%slabel_%s_%d.fix.valid.txt', output_dir, sensor, mon), labels_fixed(valid_idx{mi}{si}), 'delimiter', '\t');
                dlmwrite(sprintf('%svalid_idx_%s_%d.txt', output_dir, sensor, mon), valid_idx{mi}{si}, 'precision', '%d', 'delimiter', '\t');
            end
        end
    end

end
