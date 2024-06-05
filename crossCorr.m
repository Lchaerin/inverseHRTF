function [corr,lags] = crossCorr(sig1,sig2,fs)
%CROSSCORR 매트랩의 xcorr(상호상관)와 동일 기능
%   stereo audio 분석용, sig1과 sig2의 length는 같아야 함    
    
    n=2*length(sig1)-1; %신호 전범위의 상호상관을 확인하는 경우
    corr=zeros(n,1);
    for i=(n+1)/2:n
        m=i-(n+1)/2;
        for j=1:length(sig1)-m
            corr(i)=corr(i)+(sig2(j)*sig1(j+m));
        end
    end
    for i=1:(n+1)/2-1
        m=-(i-(n+1)/2);
        for j=1:length(sig1)-m
            corr(i)=corr(i)+(sig2(j+m)*sig1(j));
        end
    end
    lags=((-(n+1)/2+1):((n+1)/2-1))/fs;
end

