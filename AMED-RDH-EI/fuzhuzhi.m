%求辅助量信息长度
function [zg] = fuzhuzhi(zbjt,maxmapzong) 

[M,N]=size(zbjt);
zfzt=zeros(M,N);
cdt=zeros(M,N);
xyt=zeros(M,N);
lj=0;
for i=2:M
    for j=2:N
if zbjt(i,j)==0
    zfzt(i,j)=maxmapzong(4,1);
    cdt(i,j)=maxmapzong(3,1);
    elseif zbjt(i,j)==1
    zfzt(i,j)=maxmapzong(4,2);
    cdt(i,j)=maxmapzong(3,2);
    elseif zbjt(i,j)==2
    zfzt(i,j)=maxmapzong(4,3);
    cdt(i,j)=maxmapzong(3,3);
    elseif zbjt(i,j)==3
    zfzt(i,j)=maxmapzong(4,4);
    cdt(i,j)=maxmapzong(3,4);
    elseif zbjt(i,j)==4
    zfzt(i,j)=maxmapzong(4,5);
    cdt(i,j)=maxmapzong(3,5);
    elseif zbjt(i,j)==5
    zfzt(i,j)=maxmapzong(4,6);
    cdt(i,j)=maxmapzong(3,6);
    elseif zbjt(i,j)==6
    zfzt(i,j)=maxmapzong(4,7);
    cdt(i,j)=maxmapzong(3,7);
    elseif zbjt(i,j)==7
    zfzt(i,j)=maxmapzong(4,8);
    cdt(i,j)=maxmapzong(3,8);
    elseif zbjt(i,j)==8
    zfzt(i,j)=maxmapzong(4,9);
    cdt(i,j)=maxmapzong(3,9);
else
end


    
    end
end
for i=2:M
    for j=2:N
if i==2&&j==2
    xyt(i,j)=cdt(i,j);
elseif i==2&&j==3
    xyt(i,j)=cdt(i,j)-zfzt(i,j-1);
    lj=cdt(2,2)+cdt(2,3);
else xyt(i,j)=cdt(i,j)-lj;
    lj=lj+zfzt(i,j);
end
    end
end
zg=xyt(2,2);
for i=2:M
    for j=2:N
   if xyt(i,j)>zg
       zg=xyt(i,j);
   else zg=zg;
   end
end
    end

end



