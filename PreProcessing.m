function PreProcessing()
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);%读取文件，前面[A,B,C]内容必须要与文件中内容格式对应上，
                                                                                        %读取1000行(次)，headerlines表头第一行，可以不读取
indexFileName = input3;%将input赋值给indexFileName
for k=1:1000 %for循环，1~1000，必须要以end结尾
    A=imread(strcat('Char_Image/',char(indexFileName(k,1))));%char将indexFileName中的每个名称转化为字符串，
                                                             %strcat将路径和名字两个字符串合并，
                                                             %imread读取图像，格式为：imread('filename')，注意括号里有单引号
%     figure(1);
%     imshow(A);
%     A = rgb2gray(A);%转灰度图
%     A = medfilt2(A,[5 5])；%中值滤波
%     A = imfilter(A,h)
    t=graythresh(A); %graythresh给每一幅图像设置阈值，每幅图阈值不同，所以函数根据每幅图的灰度直方图自动设置
    B=im2bw(A,t);%im2bw将灰度图转化为二值图，通过t阈值来实现，将输入图像中亮度值大于t的像素替换为值1 (白色)，其他替换为值0(黑色)。
%     figure(2);
%     imshow(B);
    [a,b]=size(B);
% 多行注释快捷键cmd+/，取消多行注释快捷键cmd+t
    if(B(1,1)+B(1,b)+B(a,1)+B(a,b)>=2)%以图像左上角为原点，向下为x轴，向右为y轴，四个角的值大于等于2，即有2及以上为白点的，进行反转
        for i=1:a
            for j=1:b
                B(i,j)=1-B(i,j);
            end
        end
    end
    imwrite(B,strcat('Char_Image_Binary/',char(indexFileName(k,1))));
end