clear

month = [201510 201511 201512 201601 201602 201603];

filepath = '../../data/sensor/';
%filepath = '../../';
output_filepath = '../../data2/sensor/';

for i = 1: size(month, 2)
    mon = month(1, i);
    disp('=======');
    disp(mon);
    disp('=======');
    feature_file = load(sprintf('%sdata_%d.txt', filepath, mon));

    fid_r = fopen(sprintf('%sdata_%d.txt', filepath, mon), 'r');
    fid_w = fopen(sprintf('%sdata_%d.txt', output_filepath, mon), 'w');


    feature_index = cell(size(feature_file));
    feature_value = cell(size(feature_file));

    j = 1;
    counter_index = 1;
    counter_value = 1;

    while ~feof(fid_r)
        line = fgetl(fid_r);
        line = strsplit(line, {':', ' '});
        %line = cell2mat(line);
        for i = 1: size(line, 2);
            if(rem(i, 2) == 1)
                feature_index(j, counter_index) = {str2double(line(1, i))};
                counter_index = counter_index+1;
            elseif(rem(i, 2) == 0)
                feature_value(j, counter_value) = {str2double(line(1, i))};
                counter_value = counter_value+1;
            end
        end
    
        %disp(j);
        j = j+1;
        counter_index = 1;
        counter_value = 1;    
    end

    feature_value = cell2mat(feature_value);
    feature_index = cell2mat(feature_index);

    for i = 1: size(feature_value, 1)
        for j = 1: size(feature_value, 2)
            formatSpec = '%u:%f ';
            fprintf(fid_w, formatSpec, feature_index(i, j), feature_value(i, j));
        end
        fprintf(fid_w, '\n');
    end
end
