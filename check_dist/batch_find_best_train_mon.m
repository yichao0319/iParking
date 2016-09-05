function batch_find_best_train_mon()
    months = [201504, 201505, 201506, 201507, 201604, 201605];
    nf     = 108;
    type   = 'norm.fix';
    sensor = '';

    for mi1 = 1:length(months)
        for mi2 = 1:length(months)
            cal_ks_value(months(mi1), months(mi2), type, sensor, nf);
        end
    end
end