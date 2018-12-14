function [Train Test]=Train_Test2(DATA,N_Sample,N_TrainSample,N_TestSample)

[m n TotalSamples]=size(DATA);
Num_Class = TotalSamples/N_Sample;


for i = 1:Num_Class
    d1 = 1 + (i-1)*N_TrainSample;
    d2 = N_TrainSample + (i-1)*N_TrainSample;
    tr1 = 1+(i-1)*N_Sample;
    tr2 = N_TrainSample + (i-1)*N_Sample;
    c1 = 1 + (i-1)*N_TestSample;
    c2 = N_TestSample + (i-1)*N_TestSample;
    te1 = N_TrainSample+1+(i-1)*N_Sample;
    te2 = N_TrainSample+N_TestSample+(i-1)*N_Sample;
    Train(:,:,d1:d2)=DATA(:,:,tr1:tr2);
    Test(:,:,c1:c2)=DATA(:,:,te1:te2);
end

