function data = lrpf(data, alpha)
    %data = zeros(size(data));
    for y=1:size(data,2)
        for x=2:size(data,1)-1
            data(x,y) = data(x,y)*alpha + data(x-1,y)*(1-alpha)/2 + data(x+1,y)*(1-alpha)/2;
        end
    end
end