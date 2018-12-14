function [Train Test]=Train_Test3(DATA,N_Sample,N_TrainSample,N_TestSample)

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
    for j = 0:d2-d1
        Train(:,j+d1)=reshape(DATA(:,:,j+tr1),[],1);
    end
    for j = 0:c2-c1
        Test(:,j+c1)=reshape(DATA(:,:,j+te1),[],1);
    end
end

