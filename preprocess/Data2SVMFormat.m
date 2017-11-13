function Data2SVMFormat( month )

filepath = '../../data/sensor/';
output_filepath = '../../data/sensor/';

fid_feature = fopen(sprintf('%sdata_%d.txt', filepath, month), 'r');
fid_label = fopen(sprintf('%slabel_%d.txt', filepath, month), 'r');
fid_SVM = fopen(sprintf('%sSVMData_%d.txt', filepath, month), 'w');


while ~feof(fid_feature)
    line_feature = fgetl(fid_feature);
    line_label = fgetl(fid_label);
    line_SVM = horzcat(line_label, ' ', line_feature);
    fprintf(fid_SVM, '%s\n', line_SVM);
end

