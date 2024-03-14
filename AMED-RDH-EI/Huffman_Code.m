%用变长编码(多位0/1编码)表示像素值的标记类别
function [Code,Code_Bin] = Huffman_Code(num_Map_origin_I)
%% 求其映射编码关系
Code = [-1,0;-1,1;-1,4;-1,5;-1,12;-1,13;-1,14;-1,30;-1,31];
for i=1:9
    drder=1;
    for j=1:9
        if num_Map_origin_I(i,2) < num_Map_origin_I(j,2)
            drder = drder + 1;
        end
    end
    while Code(drder) ~= -1 %防止两种标记类别中像素的个数相等
        drder = drder + 1; 
    end
    Code(drder,1) = num_Map_origin_I(i,1);
end
%% 将Map映射关系用二进制比特流表示
Code_Bin = zeros();
t = 0; %计数
for i=0:8
    for j=1:9
        if Code(j,1) == i
            value = Code(j,2);
        end
    end
    if value == 0
        Code_Bin(t+1) = 0;
        Code_Bin(t+2) = 0;
        t = t+2;
    elseif value == 1
        Code_Bin(t+1) = 0;
        Code_Bin(t+2) = 1;
        t = t+2;
    else 
        add = ceil(log2(value+1)); %表示标记编码的长度
        Code_Bin(t+1:t+add) = dec2bin(value)-'0'; %将value转换成二进制数组
        t = t + add;
    end     
end
end
