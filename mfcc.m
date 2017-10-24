function melCoefficents=mfcc(x)

%%
% initialization
M=24; %numer of bands for filter bank
FRAMELEN=256; 
%pre-computed filter bank, generated from voice tool box
load bank
% compute DCT coefficient
dctcoef=zeros(12,24);
for i=1:12
  j=0:23;
  dctcoef(i,:)=cos((2*j+1)*i*pi/(2*24));
end
% normalized enhancement for cepstrum
w=1+6*sin(pi*(1:12)./12);
w=w/max(w);
% enframe
FrameK=enframe(x,FRAMELEN,80);
% hamming window
for i=1:size(FrameK,1)
    FrameK(i,:)=(FrameK(i,:))'.*hamming(FRAMELEN);
end
%for comparison with C program
FrameK1=FrameK'.*1000;
 
%%
% compute MFCC
%get power spectrum
S=(abs(fft(FrameK1))).^2;
% filter
P=bank*S(1:129,:);
P=log(P);
D=dctcoef*P;
% enhance
m=zeros(size(D,2),size(D,1));
for i=1:size(D,2)
    m(i,:)=(D(:,i).*w')';
end
% deltas, a dynamic coefficient
dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;
%%
%combine static and dynamic coefficients
melCoefficents=[m,dtm];
%deltas of first and last frame are useless (all zeros), discard them
melCoefficents=melCoefficents(3:size(m,1)-2,:);