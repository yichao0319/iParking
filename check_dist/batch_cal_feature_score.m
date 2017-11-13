function batch_cal_feature_score()
    months = [201504, 201505, 201506, 201507, 201508, 201509, 201510, 201511, 201512, 201601, 201604, 201605, 201608];
    nf     = 108;
    type   = 'norm.fix';
    sensor = '';

    for mi1 = 1:length(months)
        for mi2 = 1:length(months)
            fprintf('%d-%d\n', months(mi1), months(mi2));
            cal_feature_score(months(mi1), months(mi2), type, sensor, nf);
        end
    end
end