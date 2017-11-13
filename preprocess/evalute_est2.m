function [tp, tn, fp, fn, precision, recall, fscore] = evalute_est2(est, gtruth, rnge, features, thresh)
    nt = length(est);
    nf = size(features, 2);

    gt_pos_idx = find(gtruth > 0);
    tp = 0;
    fn = 0;
    for ni = 1:length(gt_pos_idx)
        idx = gt_pos_idx(ni);
        std_idx = max(1, idx-rnge);
        end_idx = min(nt, idx+rnge);

        if sum(est(std_idx:end_idx)) > 0
            tp = tp + 1;
        else
            fn = fn + 1;

            % for ni = 1:nf
            %     if isinf(thresh(ni)), continue; end

            %     figname = sprintf('tmp/feature_ts.fn.%d.f%d.png', idx, ni);
            %     plot_nearby_features(features(:,ni), est, gtruth, thresh(ni), idx, figname);
            % end
        end
    end

    est_pos_idx = find(est > 0);
    fp = 0;
    for ni = 1:length(est_pos_idx)
        idx = est_pos_idx(ni);
        std_idx = max(1, idx-rnge);
        end_idx = min(nt, idx+rnge);

        if sum(gtruth(std_idx:end_idx)) <= 0
            fp = fp + 1;
        end
    end

    tn = nt - tp - fn - fp;


    precision = tp / (tp + fp);
    recall    = tp / (tp + fn);
    fscore    = 2 * precision * recall / (precision+recall);

    fprintf('  TP=%.2f, TN=%.2f, FP=%.2f, FN=%.2f\n', tp, tn, fp, fn);
    fprintf('  Prec=%.2f, Recall=%.2f, F1-Score=%.2f\n', precision, recall, fscore);
end


function plot_nearby_features(ts, est, gtruth, thresh, idx, figname);
    fh = figure(1); clf;

    nt = length(ts);
    rnge = 100;
    std_idx = max(1, idx-rnge);
    end_idx = min(nt, idx+rnge);

    ts_seg = ts(std_idx:end_idx);
    plot(ts_seg, '-b.');
    hold on;
    plot([0, 2*rnge+1], [thresh thresh], '-r');
    gt_idx = find(gtruth(std_idx:end_idx) > 0);
    plot(gt_idx, ts_seg(gt_idx), 'ro');
    est_idx = find(est(std_idx:end_idx) > 0);
    plot(est_idx, ts_seg(est_idx), 'g*');
    xlim([0, 2*rnge+1]);

    print(fh, '-dpng', figname);
end
