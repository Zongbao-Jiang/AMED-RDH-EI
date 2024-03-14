clear
clc
kuaic=256;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);
for i=1:kuais%%开始求最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
%B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('lena4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=256;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('airplane4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=512;
kuais=1024/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
  I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=16376-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/1048576;
save('man4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=256;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
 I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('jetplan4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=256;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
 I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('baboon4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=256;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
 I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('tiffi4.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('lena16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('airplane16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
 I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('jetplan16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
 I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('baboon16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
 I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('tiff16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=256;
kuais=1024/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
  I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=16376-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/1048576;
save('main16.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('lena64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('airplane64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
 I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('jetplan64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
 I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('baboon64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
 I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('tiff64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=128;
kuais=1024/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
  I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=16376-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/1048576;
save('man64.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('lena256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('airplan256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
 I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('jetplan256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
 I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('baboon256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
 I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('tiff256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=64;
kuais=1024/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
  I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=16376-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/1048576;
save('man256.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=16;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('lena1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=16;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('airplan1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=16;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
 I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('jetplan1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=16;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
 I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('baboon1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=16;
kuais=512/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
 % I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
 I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=8184-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/262144;
save('tiff1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
kuaic=32;
kuais=1024/kuaic;
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数产生秘密
%% 设置图像加密密钥及数据加密密钥
Image_key = 1; 
Data_key = 2;
%% 设置参数(方便实验修改)
ref_x = 1; %用来作为参考像素的行数
ref_y = 1; %用来作为参考像素的列数
%% 图像加密及数据嵌入&&&&&改I11（一个图像4次）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Lena.tiff');
  I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
[M,N] = size(origin_I);
I11=zeros(kuaic,kuaic);
I12=zeros(kuaic,kuaic+1);
I13=zeros(kuaic+1,kuaic);
I14=zeros(kuaic+1,kuaic+1);
maxmapzong=zeros(5,9);%%每个标记的数量
maxmapzong2=zeros(5,9);
A=cell(kuais,kuais);
B=cell(kuais,kuais);
qianrulu=0;
for i=1:kuais
    for j=1:kuais%这一级是分块矩阵
        for i1=1:kuaic
            for j1=1:kuaic
                I11(i1,j1)=origin_I(i1+(i-1)*kuaic,j1+(j-1)*kuaic);
            end
        end
       
        if i==1&&j>1%分成四个部分
            for i2=1:kuaic
                for j2=1:kuaic
                    I12(i2,j2+1)=I11(i2,j2);
                    A{i,j}=I12;
                end
            end
        elseif i>1&&j==1
            for i2=1:kuaic
                for j2=1:kuaic
                    I13(i2+1,j2)=I11(i2,j2);
                    A{i,j}=I13;
                end
            end
        elseif i>1&&j>1
            for i2=1:kuaic
                for j2=1:kuaic
                    I14(i2+1,j2+1)=I11(i2,j2);
                    A{i,j}=I14;
                end
            end
        else A{i,j}=I11;
        end

    end
end
k11_1=0;
k11_3=0;
k11_2=0;
zongweizhitu=zeros(M,N);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:kuais%%开始求那个最大原始嵌入率
    for j=1:kuais
maxemD11=[1];
        for q3=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,0,q3);%%%%%%%%%%%%%%%%%%改多了一个输出参数
if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_3=q3;
end
        end
           for q2=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,0,q2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
   maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_2=q2;
end
           end
             for q1=-3:1:4
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,q1,k11_2,k11_3);

if size(emD, 2)>size(maxemD11, 2)
    maxemD11=emD;
    maxhist_Map_origin_I11=hist_Map_origin_I;
    k11_1=q1;
end
             end
            % B{i,j}=size(maxemD11, 2)+52;最大原始嵌入率
qianrulu=size(maxemD11, 2)+52+qianrulu;
[encrypt_I,stego_I,emD,hist_Map_origin_I,Map_origin_I] = Encrypt_Embed(A{i,j},D,Image_key,Data_key,ref_x,ref_y,k11_1,k11_2,k11_3);
if i==1&&j==1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加的那个数
    for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja)=zx(ia,ja);
        end
    end
elseif i==1&&j>1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia,ja+(j-1)*kuaic)=zx(ia,ja+1);
        end
     end
     elseif i>1&&j==1
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja)=zx(ia+1,ja);
        end
     end
else
     for ia=1:kuaic
        for ja=1:kuaic
            zx=Map_origin_I;
        zongweizhitu(ia+(i-1)*kuaic,ja+(j-1)*kuaic)=zx(ia+1,ja+1);
        end
     end
end
[M2,N2]=size(maxhist_Map_origin_I11)
 for i4=1:M2
     if maxhist_Map_origin_I11(i4,1)==0
       maxmapzong(1,1)=maxmapzong(1,1)+maxhist_Map_origin_I11(i4,2);
     elseif maxhist_Map_origin_I11(i4,1)==1
       maxmapzong(1,2)=maxmapzong(1,2)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==2
       maxmapzong(1,3)=maxmapzong(1,3)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==3
       maxmapzong(1,4)=maxmapzong(1,4)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==4
       maxmapzong(1,5)=maxmapzong(1,5)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==5
       maxmapzong(1,6)=maxmapzong(1,6)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==6
       maxmapzong(1,7)=maxmapzong(1,7)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==7
       maxmapzong(1,8)=maxmapzong(1,8)+maxhist_Map_origin_I11(i4,2);
        elseif maxhist_Map_origin_I11(i4,1)==8
       maxmapzong(1,9)=maxmapzong(1,9)+maxhist_Map_origin_I11(i4,2);
     end
 end
 end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为求总嵌入量（是在不算辅助信息的情况下）
maxmapzong(2,1)=1;
maxmapzong(2,2)=2;
maxmapzong(2,3)=3;
maxmapzong(2,4)=4;
maxmapzong(2,5)=5;
maxmapzong(2,6)=6;
maxmapzong(2,7)=7;
maxmapzong(2,8)=8;
maxmapzong(2,9)=8;
maxmapzong(5,1)=0;
maxmapzong(5,2)=1;
maxmapzong(5,3)=2;
maxmapzong(5,4)=3;
maxmapzong(5,5)=4;
maxmapzong(5,6)=5;
maxmapzong(5,7)=6;
maxmapzong(5,8)=7;
maxmapzong(5,9)=8;
for kl1=2:8
    kl3=10-kl1;
   for kl2=1:kl3
       if maxmapzong(1,kl2)>maxmapzong(1,kl2+1)
       kl4=maxmapzong(1,kl2+1);
       maxmapzong(1,kl2+1)=maxmapzong(1,kl2);
       maxmapzong(1,kl2)=kl4;
       kl4=maxmapzong(2,kl2+1);
       maxmapzong(2,kl2+1)=maxmapzong(2,kl2);
       maxmapzong(2,kl2)=kl4;
       kl4=maxmapzong(5,kl2+1);
       maxmapzong(5,kl2+1)=maxmapzong(5,kl2);
       maxmapzong(5,kl2)=kl4;
       else
       end
   end
end
if maxmapzong(1,1)>maxmapzong(1,2)
       kl4=maxmapzong(1,2);
       maxmapzong(1,2)=maxmapzong(1,1);
       maxmapzong(1,1)=kl4;
       kl4=maxmapzong(2,2);
       maxmapzong(2,2)=maxmapzong(2,1);
       maxmapzong(2,1)=kl4;
       kl4=maxmapzong(5,2);
       maxmapzong(5,2)=maxmapzong(5,1);
       maxmapzong(5,1)=kl4;
end
maxmapzong(3,1)=5;
maxmapzong(3,2)=5;
maxmapzong(3,3)=4;
maxmapzong(3,4)=4;
maxmapzong(3,5)=4;
maxmapzong(3,6)=3;
maxmapzong(3,7)=3;
maxmapzong(3,8)=2;
maxmapzong(3,9)=2;
maxmapzong(4,1)=maxmapzong(2,1)-maxmapzong(3,1);
maxmapzong(4,2)=maxmapzong(2,2)-maxmapzong(3,2);
maxmapzong(4,3)=maxmapzong(2,3)-maxmapzong(3,3);
maxmapzong(4,4)=maxmapzong(2,4)-maxmapzong(3,4);
maxmapzong(4,5)=maxmapzong(2,5)-maxmapzong(3,5);
maxmapzong(4,6)=maxmapzong(2,6)-maxmapzong(3,6);
maxmapzong(4,7)=maxmapzong(2,7)-maxmapzong(3,7);
maxmapzong(4,8)=maxmapzong(2,8)-maxmapzong(3,8);
maxmapzong(4,9)=maxmapzong(2,9)-maxmapzong(3,9);
zongqianruliang=0;
for jkl=1:9
zongqianruliang=zongqianruliang+maxmapzong(1,jkl)*maxmapzong(4,jkl);
end


for i=1:9
    if maxmapzong(5,i)==0
         maxmapzong2(1,1)=maxmapzong(1,i);
         maxmapzong2(2,1)=maxmapzong(2,i);
         maxmapzong2(3,1)=maxmapzong(3,i);
         maxmapzong2(4,1)=maxmapzong(4,i);
         maxmapzong2(5,1)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==1
         maxmapzong2(1,2)=maxmapzong(1,i);
         maxmapzong2(2,2)=maxmapzong(2,i);
         maxmapzong2(3,2)=maxmapzong(3,i);
         maxmapzong2(4,2)=maxmapzong(4,i);
         maxmapzong2(5,2)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==2
         maxmapzong2(1,3)=maxmapzong(1,i);
         maxmapzong2(2,3)=maxmapzong(2,i);
         maxmapzong2(3,3)=maxmapzong(3,i);
         maxmapzong2(4,3)=maxmapzong(4,i);
         maxmapzong2(5,3)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==3
         maxmapzong2(1,4)=maxmapzong(1,i);
         maxmapzong2(2,4)=maxmapzong(2,i);
         maxmapzong2(3,4)=maxmapzong(3,i);
         maxmapzong2(4,4)=maxmapzong(4,i);
         maxmapzong2(5,4)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==4
         maxmapzong2(1,5)=maxmapzong(1,i);
         maxmapzong2(2,5)=maxmapzong(2,i);
         maxmapzong2(3,5)=maxmapzong(3,i);
         maxmapzong2(4,5)=maxmapzong(4,i);
         maxmapzong2(5,5)=maxmapzong2(5,i);
    elseif maxmapzong(5,i)==5
         maxmapzong2(1,6)=maxmapzong(1,i);
         maxmapzong2(2,6)=maxmapzong(2,i);
         maxmapzong2(3,6)=maxmapzong(3,i);
         maxmapzong2(4,6)=maxmapzong(4,i);
         maxmapzong2(5,6)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==6
         maxmapzong2(1,7)=maxmapzong(1,i);
         maxmapzong2(2,7)=maxmapzong(2,i);
         maxmapzong2(3,7)=maxmapzong(3,i);
         maxmapzong2(4,7)=maxmapzong(4,i);
         maxmapzong2(5,7)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==7
         maxmapzong2(1,8)=maxmapzong(1,i);
         maxmapzong2(2,8)=maxmapzong(2,i);
         maxmapzong2(3,8)=maxmapzong(3,i);
         maxmapzong2(4,8)=maxmapzong(4,i);
         maxmapzong2(5,8)=maxmapzong(5,i);
    elseif maxmapzong(5,i)==8
         maxmapzong2(1,9)=maxmapzong(1,i);
         maxmapzong2(2,9)=maxmapzong(2,i);
         maxmapzong2(3,9)=maxmapzong(3,i);
         maxmapzong2(4,9)=maxmapzong(4,i);
         maxmapzong2(5,9)=maxmapzong(5,i);
    else
    end
end
fuzhu=fuzhuzhi(zongweizhitu,maxmapzong2);
fz1=0;
for i=1:9
fz1=fz1+maxmapzong2(1,i)*maxmapzong2(3,i);
end
fz=log2(fz1);
kuais2=kuais^2;
lpp=16376-32-9*kuais2-fuzhu;
zongqianruliangdayue=zongqianruliang-32-9*kuais2;
zongqianruludayue=zongqianruliangdayue/1048576;
save('man1024.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
