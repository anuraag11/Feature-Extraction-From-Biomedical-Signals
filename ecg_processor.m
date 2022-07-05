ecg=bandpass(signals, [5 26], fs);
wt=modwt(ecg,5,'sym4');
wtrec=zeros(size(wt));
wtrec(4:5,:)=wt(4:5,:);
y=imodwt(wtrec,'sym4');
y=abs(y).^2;
avg=mean(y);
[rpeaks, locs]=findpeaks(y,1:21600,'MinPeakHeight',8*avg,'MinPeakDistance',50);

n=length(locs);
qpoints=zeros(1,n);
spoints=zeros(1,n);
fx=gradient(ecg);
j1=0; j2=0;
for k=1:n
    gp1=locs(k)-1;
    gp2=locs(k)+1;
    j1=0; j2=0;
    while j1~=1 && gp1>0
        if fx(gp1)<=0
            j1=1;
        else
            if(gp1>1)
                gp1=gp1-1;
            else
                j1=1;
            end
        end 
        qpoints(k)=gp1;
    end
    while j2~=1 && gp2<21601
        if fx(gp2)>=0
            j2=1;
        else
            if(gp2<21600)
                gp2=gp2+1;
            else
                j2=1;
            end
        end  
        spoints(k)=gp2;
    end
end

qampl=ecg(qpoints);
sampl=ecg(spoints);
duration_qrs=(spoints-qpoints)/fs;
rr_int=[locs 0]-[0 locs];
rr_int=rr_int(2:end-1);
rr_int=[rr_int NaN];
feat=[rpeaks; qampl'; sampl'; duration_qrs; rr_int]';
feat=[feat; zeros(1,5); zeros(1,5)];

% hold on
% plot((1:21600),signals);
% plot(qpoints, signals(qpoints), 'ro');
% plot(spoints, signals(spoints), 'go');
% hold off
    