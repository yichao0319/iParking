
function batch_simple_classification()
    % ratios = [0.9990:0.0001:1]';
    ratios = [0.9990:0.0001:0.9996 0.9997:0.00002:1]';
    % ratios = [0.9990:0.0005:1]';

    tp = zeros(size(ratios));
    tn = zeros(size(ratios));
    fp = zeros(size(ratios));
    fn = zeros(size(ratios));
    precision = zeros(size(ratios));
    recall = zeros(size(ratios));
    fscore = zeros(size(ratios));
    for ri = 1:length(ratios)
        ratio = ratios(ri);
        [tp(ri), tn(ri), fp(ri), fn(ri), precision(ri), recall(ri), fscore(ri)] = simple_classification(ratio);
    end

    dlmwrite('./tmp/batch_simple_class.result.txt', [ratios tp tn fp fn precision recall fscore], 'delimiter', '\t');

end