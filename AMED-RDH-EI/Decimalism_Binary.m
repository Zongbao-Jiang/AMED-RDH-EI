% 将十进制灰度像素值转换成8位二进制数组
function [bin2_8] = Decimalism_Binary(value)
bin2_8 = dec2bin(value)-'0';
if length(bin2_8) < 8
    len = length(bin2_8);
    B = bin2_8;
    bin2_8 = zeros(1,8);
    for i=1:len
        bin2_8(8-len+i) = B(i); %不足8位前面补充0
    end 
end