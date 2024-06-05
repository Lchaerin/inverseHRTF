clear
close all

[y, fs] = audioread('../audio/hrtf_test.mp3');
load('K-data.mat')
t=(1:length(y(:,1)))/fs;
frametime = 0.04;
NFFT = 2^(round(log(fs*frametime)/log(2)));
frametime=NFFT/fs;
distance=22;
df=zeros(size(HRTF_L,1),1);
framelength=NFFT;
shifttime=frametime/2;
shiftlength=floor(fs*shifttime);
i=0;
delays=zeros(floor((length(y(:,1))-framelength)/shiftlength+1),1);
azimuths=zeros(floor((length(y(:,1))-framelength)/shiftlength+1),1);
maxs=zeros(floor((length(y(:,1))-framelength)/shiftlength+1),1);
amps=zeros(floor((length(y(:,1))-framelength)/shiftlength+1),1);
n=framelength;
W = hann(n);  
rmsThr=-70;

while framelength+i*shiftlength<=length(y(:,1))
    start=i*shiftlength+1;
    last=start+framelength-1;
    YL = fft(y(start:last,1).*W);
    YR = fft(y(start:last,2).*W);
    L=length(YL);
    f = fs/n*(0:(n/2));

    P2L = YL/L;
    P1L = P2L(1:L/2+1);
    P1L(2:end-1) = 2*P1L(2:end-1);
    
    P2R = YR/L;
    P1R = P2R(1:L/2+1);
    P1R(2:end-1) = 2*P1R(2:end-1);

    maxCorr=0;
    maxCorrIndex=0;
    ratio=(length(f)-1)/(size(HRTF_L,2)-1);
    P1L_new=P1L(1:ratio:length(P1L));
    P1R_new=P1R(1:ratio:length(P1R));
    
    for j=1:size(HRTF_L,1)        
        sig1=P1L_new.*(transpose(HRTF_R(j,:)));
        sig2=P1R_new.*(transpose(HRTF_L(j,:)));
        % temp=crossCorr0(sig1,sig2);
        temp=xcorr(sig1,sig2,0,'coeff');
        if temp>maxCorr
            maxCorr=temp;
            maxCorrIndex=j;
        end
    end
    azimuths(i+1)=rem(maxCorrIndex-1,24)*15;
    maxs(i+1)=maxCorrIndex;
    i=i+1;
end



% figure;
tDelay=frametime-shifttime+(1:length(delays))*shifttime;
% plot(delays/fs*1000)
% xlabel('play time(s)')
% ylabel('delay between left&right audio(ms)')
% 
% figure;
% plot(tDelay,delays/fs*340*100)
% xlabel('play time(s)')
% ylabel('distance between left&right audio(cm)')

figure;
plot(tDelay,azimuths)
xlabel('play time(s)')
ylabel('azimuth(degree)')

% figure
% plot(maxs)
% 
% figure
% plot(df)

% figure;
% plot(tDelay,amps)
% xlabel('play time(s)')
% ylabel('amplitude')
% 
% figure;
% plot(tDelay,motor(:,1:4))
% legend('line1','line2','line3','line4')
% xlabel('play time(s)')
% ylabel('amplitude')
