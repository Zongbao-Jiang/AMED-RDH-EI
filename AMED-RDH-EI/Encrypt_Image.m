%��ͼ��origin_I����bit��������
function [encrypt_I] = Encrypt_Image(origin_I,Image_key)
[row,col] = size(origin_I); %����origin_I������ֵ
encrypt_I = origin_I;  %�����洢����ͼ�������
%% ������Կ������origin_I��С��ͬ���������
rand('seed',Image_key); %��������
E = round(rand(row,col)*255); %�������row*col����
%% ����E��ͼ��origin_I����bit������
for i=1:row
    for j=1:col
        encrypt_I(i,j) = bitxor(origin_I(i,j),E(i,j));
    end
end
end