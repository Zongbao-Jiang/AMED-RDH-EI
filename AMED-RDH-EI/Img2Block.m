%图像分块函数
function [O] = Img2Block(I, B)
%IMG2BLOCK separate image I to blocks with block size B * B

I = double(I);
[M, N] = size(I);

blocknum = M / B;

O = mat2cell(I, B * ones(1, blocknum), B * ones(1, blocknum));%元胞数组划分。

end

