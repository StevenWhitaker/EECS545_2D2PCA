function [CorrectRate, EigVect1,EigVect,PrinCom] = PCA( ORLData, N_TrainSample, N_TestSample, DIM, plot_flag, wanttest,Inp_EigVect1,EigVal1,Num_Class,N_Sample )


% Loading face dataset. ORL consists of 40 classes, each comprising 10 samples
% load ORL_FaceDataSet;  
% ORLData=double(ORL_FaceDataSet);

%------------- set parameters --------------------------
% Num_Class=40;
% N_Sample=10;
% N_TrainSample=5;
% N_TestSample=5;
% DIM=2;    % dimention of principle component
% plot_flag = 0;

%-------------- prepare training and test data ----------------------------
[TrainData, TestData]=Train_Test3(ORLData,N_Sample,N_TrainSample,N_TestSample);
[n,TotalTrainSamples] = size(TrainData);
[~,TotalTestSamples] = size(TestData);
[TrainLabel,TestLabel]=LebelSamples(Num_Class, N_TrainSample, N_TestSample);

tic
if ~exist('Inp_EigVect1') || isempty(Inp_EigVect1)
    %-------------- sample covariance matrix Gt ---------------------------
    TrainMean = mean(TrainData,2); % Total mean of the training set
    Gt=zeros([ n n]);
    for i=1:TotalTrainSamples
        Temp = TrainData(:,i)- TrainMean;
        Gt = Gt + Temp*Temp';
    end
    Gt=Gt/TotalTrainSamples; 

    %-------------- find eigen vectors --------------------------
    [EigVect1,EigVal1]=eig_decomp(Gt);
else
    EigVect1 = Inp_EigVect1;
end
findEvectime=toc

if DIM==0
    d = length(EigVal1);
    s_sum = tril(ones(d,d))*EigVal1';
    s_95 = s_sum - s_sum(end)*0.95;
    DIM = min(find(s_95 > 0));
end
% DIM=2;
EigVect=EigVect1(:,1:DIM); 

%------------ principle components -----------------------------
% PrinCom_train = zeros(n,DIM,TotalTrainSamples);
for i=1:TotalTrainSamples
    Ytrain(:,i)=EigVect'*TrainData(:,i);
    % PrinCom_train(:,:,i) = Ytrain(:,i);
end
PrinCom_train = Ytrain;
%------------ Classification ----------------------
TestResult = zeros(TotalTestSamples,1);

if wanttest
    for i=1:TotalTestSamples

        Distance = zeros(TotalTrainSamples,1);

        Ytest = EigVect'* TestData(:,i); % Deriving test feature matrix
        PrinCom_test(:,i) = Ytest;
        for j=1:TotalTrainSamples
            Distance(j) = Distance(j) + norm(Ytest(:)-Ytrain(:,j)); % Measuring the distances between test and training feature matrices 
        end

        [MINDIST ID] = min(Distance); % Returning Min distance
        TestResult(i) = TrainLabel(ID);
        if plot_flag ==1
            subplot 221; imshow(TestData(:,:,i),[]);title(['Tested Face = ' num2str(i)]);
            subplot 222; imshow(TrainData(:,:,ID),[]);title(['Recognized Face = ' num2str(ID)]);
            subplot(2,2,[3 4]); 
            plot(Distance,'-o','MarkerFaceColor','blue','MarkerSize',5);title(['Min Distance = ' num2str(MINDIST),' ID = ' num2str(ID)]);
            xlabel('Training Samples') 
            ylabel('Distance') 
            grid on
            grid minor
            pause (0.1)
        end
    end
    Result = (TestResult == TestLabel);

    CorrectRate = 100*(sum(Result/TotalTestSamples));
    disp(['With DIM= ' num2str(DIM) ', the CorrectRate is ' num2str(CorrectRate) '%.'])
    disp(' --------------------------------------------------')
else
    CorrectRate = -1;
end
PrinCom={PrinCom_train;PrinCom_test};