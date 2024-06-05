clear
close all

j=1;
E=1;
[testY,testFs]=audioread('../elev20/H20e000a.wav');

HRTF_L=zeros(360,length(testY)/2+1);
HRTF_R=zeros(360,length(testY)/2+1);
for e=-20:10:20
    for i=0:5:180
        s1='../elev';
        s2_1=num2str(e);
        s2_2='/H';
        s2_3='e';
        s2=strcat(s2_1,s2_2,s2_1,s2_3);
        if i<10
            s3_1='00';
            s3_2=num2str(i);
            s3=strcat(s3_1,s3_2);
        elseif i<100
            s3_1='0';
            s3_2=num2str(i);
            s3=strcat(s3_1,s3_2);
        else
            s3=num2str(i);
        end
        s4='a.wav';
        s=strcat(s1,s2,s3,s4);
        [y, fs] = audioread(s);
        
        L=length(y);
        t=(1:L)/fs;
        W=hann(L);
        YL=fft(y(:,1).*W);
        YR=fft(y(:,2).*W);
        f = fs/L*(0:(L/2));
    
        P2L = YL/L;
        P1L = P2L(1:L/2+1);
        P1L(2:end-1) = 2*P1L(2:end-1);
        
        P2R = YR/L;
        P1R = P2R(1:L/2+1);
        P1R(2:end-1) = 2*P1R(2:end-1);
        
        HRTF_L(j,:)=P1L;
        HRTF_R(j,:)=P1R;
        
        j=j+1;
    end
    for k=(E*72-34):(E*72)
        HRTF_R(k,:)=HRTF_L(E*72+2-k,:);
        HRTF_L(k,:)=HRTF_R(E*72+2-k,:);
        j=j+1;
    end
    E=E+1;
end
save("../HRTF_data/K-data.mat","HRTF_L","HRTF_R")
% save("../HRTF_data/data.mat","hrtfL")