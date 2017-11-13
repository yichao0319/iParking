function [name] = gen_rand_name()
    SET = char(['a':'z' '0':'9']) ;
    NSET = length(SET) ;

    N = 32; % pick N numbers
    i = ceil(NSET*rand(1,N)) ; % with repeat
    name = SET(i) ;
end