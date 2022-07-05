sig=val;

for i=1:23
    sig(i,:)=bandstop(sig(i,:),[59.9 60.1],256);
end

maximum=max(sig,[],2);
minimum=min(sig,[],2);
avg=mean(sig,2);
stdev=sqrt(var(sig,0,2));
med=median(sig,2);
modeval=mode(sig,2);
interq=iqr(sig,2);

delta=zeros(23,2560);
alpha=zeros(23,2560);
beta=zeros(23,2560);
theta=zeros(23,2560);
gamma=zeros(23,2560);

for i=1:23
    delta(i,:)=bandpass(sig(i,:),[0.1 4],256);
    theta(i,:)=bandpass(sig(i,:),[4 8],256);
    alpha(i,:)=bandpass(sig(i,:),[8 12],256);
    beta(i,:)=bandpass(sig(i,:),[12 30],256);
    gamma(i,:)=highpass(sig(i,:),30,256);
end

deltamax=max(delta,[],2);
thetamax=max(theta,[],2);
alphamax=max(alpha,[],2);
betamax=max(beta,[],2);
gammamax=max(gamma,[],2);

feat=[maximum;minimum;avg;stdev;med;modeval;interq;deltamax;thetamax;alphamax;betamax;gammamax]';

%For plotting the various wave components for visualization
j=9;

subplot(511)
plot(delta(j,:));
subplot(512)
plot(theta(j,:));
subplot(513)
plot(alpha(j,:));
subplot(514)
plot(beta(j,:));
subplot(515)
plot(gamma(j,:));


