clc
clear all
close all

feature1 = textread('feature1.txt','%d','delimiter', ',');
feature1 = reshape(feature1,[140 1000]);
feature1 = feature1';%转置
feature1 = feature1(:,2:end);%选取特征，除去第一列为编号
%98

feature2 = textread('feature2.txt','%d','delimiter', ',');
feature2 = reshape(feature2,[73 1000]);
feature2 = feature2';%转置
feature2 = feature2(:,2:end);%选取特征，除去第一列为编号
%99.5

feature3 = textread('feature3.txt','%d','delimiter', ',');
feature3 = reshape(feature3,[279 1000]);
feature3 = feature3';%转置
feature3 = feature3(:,2:end);%选取特征，除去第一列为编号
%97

feature4 = textread('feature4.txt','%d','delimiter', ',');
feature4 = reshape(feature4,[140 1000]);
feature4 = feature4';%转置
feature4 = feature4(:,2:end);%选取特征，除去第一列为编号
%87

feature5 = textread('feature5.txt','%d','delimiter', ',');
feature5 = reshape(feature5,[277 1000]);
feature5 = feature5';%转置
feature5 = feature5(:,2:end);%选取特征，除去第一列为编号
%100

feature6 = textread('feature6.txt','%d','delimiter', ',');
feature6 = reshape(feature6,[129 1000]);
feature6 = feature6';%转置
feature6 = feature6(:,2:end);%选取特征，除去第一列为编号
%100


% feature = [feature1 feature2 feature3 feature4 feature5 10*feature6]


feature = feature3
classification_num = 13;
allclass = [10 11 12 20 22 25 26 28 30 31 32 33 34];
indexInfo = ['京' '渝' '鄂' '0'  '2' '5' '6' '8' 'A' 'B' 'C' 'D' 'Q'];
[~, class, name] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
% transform_index = zeros(1000, 1);%存储1-13类别编号
% for i = 1 : classification_num
%     transform_index( :, 1) = transform_index(:, 1) + (index == class(i)) * i; %将原来的存储编号映射到1-13上
% end
train_num = 800;
% selection_index = (randperm (1000) <= train_num);%randperm产生1-1000的随机不重复数字，小于等于800的为1，大于的为0
% save selection_index.mat selection_index;
load selection_index.mat;
model = svmtrain( class(selection_index,:),feature(selection_index,:),'-t 1 -d 1 -g 0.01 -r 0');
[predict_label, accuracy, dec_values] = svmpredict(class(~selection_index,:),feature(~selection_index,:), model);
% X = class(selection_index,:)
% Y = feature(selection_index,:)
A = class(~selection_index,:);%测试集中真实的类别
B = predict_label;%预测出的类别
err_index = A~=B;%A不等B，即分错记为1，分对记为0
C = A(err_index);%A中分错的类别
D = B(err_index);%B中分错的类别
err_name = name(~selection_index,:);%测试类别的名字
N = err_name(err_index);%分错图片的名称
for i = 1:length(C)%length是求某一矩阵所有维的最大长度，这里相当于Python中的len(C),分错的数目
    E = find(allclass == C(i));
    F = find(allclass == D(i));
    [indexInfo(E) ' 被误识别成 ' indexInfo(F)]
    figure(i);
    imshow(['/Users/mac/Deaplearning/SVM车牌识别/Feature Extraction/Char_Image/' N{i}]);
    N{i}
end




