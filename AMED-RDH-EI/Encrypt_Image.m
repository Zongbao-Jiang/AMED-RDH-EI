%对图像origin_I进行bit级异或加密
function [encrypt_I] = Encrypt_Image(origin_I,Image_key)
[row,col] = size(origin_I); %计算origin_I的行列值
encrypt_I = origin_I;  %构建存储加密图像的容器
%% 根据密钥生成与origin_I大小相同的随机矩阵
rand('seed',Image_key); %设置种子
E = round(rand(row,col)*255); %随机生成row*col矩阵
%% 根据E对图像origin_I进行bit级加密
for i=1:row
    for j=1:col
        encrypt_I(i,j) = bitxor(origin_I(i,j),E(i,j));
    end
end
end