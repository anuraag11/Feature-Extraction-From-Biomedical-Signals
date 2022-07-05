ppg=highpass(val,1,125);
[peaks, locs]=findpeaks(ppg,1:7500,'MinPeakDistance',60);
[fpeaks, flocs]=findpeaks(-ppg,1:7500,'MinPeakDistance',60);
m1=[0 flocs];
m2=[flocs 0];
interval=[m1; m2];
interval=interval(:,2:end-1);
int_dur=(m2-m1)/125;
int_dur=int_dur(:,2:end-1);
n=length(interval(1,:));
areas=zeros(1,n);

fd=gradient(ppg);
sd=gradient(fd);

for i=1:n
    areas(i)=trapz(interval(1,i):interval(2,i),ppg(interval(1,i):interval(2,i))); 
end

sdf=bandpass(sd,[1 10],125);

wt=modwt(sdf,6,'sym7');
wtrec=zeros(size(wt));
wtrec(3:6,:)=wt(3:6,:);
y=imodwt(wtrec,'sym7');
y=y.^3;
[apeaks, alocs]=findpeaks(y,1:7500,'MinPeakDistance',60);
[bpeaks, blocs]=findpeaks(-y,1:7500,'MinPeakDistance',60);
[derpeaks, derlocs]=findpeaks(-fd,1:7500,'MinPeakDistance',60);

nd=length(derlocs);
dicro=zeros(1,nd);
j1=0;
for i=1:nd
    g=derlocs(i)+1; j1=0;
    while j1~=1 && g<=7500
        if sdf(g)<=0
            j1=1; break;
        else
            if g<7500
                g=g+1;
            else
                j1=1; break;
            end
        end
    end
    dicro(i)=g;
end

nb=length(blocs);
clocs=zeros(1,nb);
j1=0;
td=gradient(sdf);
for i=1:nb
    g=blocs(i)+1; j1=0;
    while j1~=1 && g<=7500
        if td(g)<0
            j1=1; break;
        else
            if g<7500
                g=g+1;
            else
                j1=1; break;
            end
        end
    end
    clocs(i)=g;
end

cpeaks=sdf(clocs);
m1=[0 dicro];
m2=[dicro 0];
peak_to_notch=(m2-m1)/125;
peak_to_notch=peak_to_notch(:,2:end-1);
feattable=table(peaks,int_dur,areas,peak_to_notch,apeaks,bpeaks,cpeaks);

hold on
plot(sdf);
plot(zeros(7500,1));
plot(alocs, sdf(alocs),'ro');
plot(blocs, sdf(blocs),'go');
plot(clocs, sdf(clocs),'ko');
hold off

hold on
plot(ppg);
plot(dicro, ppg(dicro),'ro');
hold off
hold on
plot(ppg);
plot(flocs, ppg(flocs),'bo');
plot(locs, ppg(locs),'ko');
hold off
