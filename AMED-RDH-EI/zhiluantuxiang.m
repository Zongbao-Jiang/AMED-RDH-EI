%置换图像
permorder = randperm(BM * BN);
PermedBlocks = cell(BM, BN);
for i = 1 : BM * BN
    PermedBlocks{i} = Blocks{permorder(i)};%块置乱后
end
miwentuxiang=zeros(M,N);%%以下为求置换密文图像，在这个函数中输出
xi=zeros(B,B);
for i=1:M%%求密文图像每一个值
    for j=1:N

if mod(i,2)==0
    i2=2;%i1j1为块数，i2j2为标志位。
i1=i/2;
else 
    i2=1;
    i1=(i+1)/2;
end
if mod(j,2)==0
    j2=2;%i1j1为块数，i2j2为标志位。
j1=j/2;
else 
    j2=1;
   j1=(j+1)/2;
end
xi=PermedBlocks{i1,j1};
miwentuxiang(i,j)=xi(i2,j2);
    end
end