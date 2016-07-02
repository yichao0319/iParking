function [tp, tn, fp, fn, precision, recall, fscore] = evalute_est(est, gtruth)
    tp = length(find(est == 1 & gtruth == 1));
    tn = length(find(est == 0 & gtruth == 0));
    fp = length(find(est == 1 & gtruth == 0));
    fn = length(find(est == 0 & gtruth == 1));
    precision = tp / (tp + fp);
    recall    = tp / (tp + fn);
    fscore    = 2 * precision * recall / (precision+recall);

    fprintf('  TP=%.2f, TN=%.2f, FP=%.2f, FN=%.2f\n', tp, tn, fp, fn);
    fprintf('  Prec=%.2f, Recall=%.2f, F1-Score=%.2f\n', precision, recall, fscore);
end
