function [TrainLable TestLable]=LebelSamples(Num_Class, N_TrainSample, N_TestSample)
TrainLable1=[]; TestLable1=[];
for i=1: Num_Class
    Ltrain=repmat(i,N_TrainSample); Ltest=repmat(i,N_TestSample);
    Ltrain1=Ltrain(1,:); Ltest1=Ltest(1,:);
    TrainLable1=[TrainLable1 Ltrain1]; TestLable1=[TestLable1 Ltest1];
end
TrainLable=TrainLable1';
TestLable=TestLable1';
