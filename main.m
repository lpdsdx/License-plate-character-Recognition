tic;
% PreProcessing();%预处理，把要处理的图像转化成二值图
% PreProcessingToCorrect();%对没有正确转化的图像进行手工校正
% b2w()%图片反转
% Feature1Extraction();%提取特征1，为每一行和每一列的白点数
% Feature2Extraction();%提取特征2，为区域密度，区域大小为8*8
% Feature3Extraction();%提取特征3，为字符左右上下与边界的距离，
% Feature4Extraction();%提取特征4，为每一行和每一列的线段数目
% Feature5Extraction();%提取特征5，为区域密度，区域大小为4*4
% Feature6Extraction();%提取特征6，为区域密度，区域大小为6*6

% Feature11Extraction();%提取特征1，为每一行和每一列的黑点数
% Feature22Extraction();%提取特征2，为区域密度，区域大小为8*8
% Feature33Extraction();%提取特征3，为字符左右上下与边界的距离，
% Feature44Extraction();%提取特征4，为每一行和每一列的线段数目
% Feature55Extraction();%提取特征5，为区域密度，区域大小为4*4
% Feature66Extraction();%提取特征6，为区域密度，区域大小为6*6

toc%计算程序运行时间