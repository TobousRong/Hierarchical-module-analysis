function [Fre,DIn,DSe,In_time,Se_time] = Flexible(HB,TR)
%%============================strength
DIn=sum(HB(find(HB>0)));
DSe=sum(HB(find(HB<0)));
%%============================time
In_time=length(find(HB>=0))/4717;
Se_time=length(find(HB<0))/4717;
%%============================transition frequency
HB(HB<0)=-1;
HB(HB>0)=1;
Fre=length(find(abs(diff(HB))>0))/(4717*TR);
end   

