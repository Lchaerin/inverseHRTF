function delay = corrDelay(sig1,sig2,fs)
%CORRDELAY 매트랩의 finddelay(신호 간의 지연 추정)와 동일 기능
%   자세한 설명 위치
    
    [corr,lags] = crossCorr(sig1,sig2,fs);
    [M,argmax]=max(corr);
    if M>0.1  %상관관계의 유의미성 판단
        delay=lags(argmax);
    else
        delay=0;
    end
end

