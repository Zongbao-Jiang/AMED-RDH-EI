% ����origin_I��Ԥ��ֵ
function [origin_PV_I] = Predictor_Value(origin_I,ref_x,ref_y,q1,q2,q3)  
[row,col] = size(origin_I); %����origin_I������ֵ
origin_PV_I = origin_I;  %�����洢origin_IԤ��ֵ������
for i=ref_x+1:row  %ǰref_x����Ϊ�ο����أ�����Ԥ��
    for j=ref_y+1:col  %ǰref_y����Ϊ�ο����أ�����Ԥ��
        a = origin_I(i-1,j);
        b = origin_I(i-1,j-1);
        c = origin_I(i,j-1);
        if b <= min(a,c)
            origin_PV_I(i,j) = max(a,c)+q1;
        elseif b >= max(a,c)
            origin_PV_I(i,j) = min(a,c)+q2;
       else
            origin_PV_I(i,j) = a + c - b+q3;
        end
    end
end



