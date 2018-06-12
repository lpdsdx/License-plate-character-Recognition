function b2w()
%将黑底白字的图片进行反转为白底黑字
[input1,input2,input3] = textread('Char_Index.txt','%d %d %s',1000,'headerlines',1);
indexFileName = input3;
for k=1:1000
A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
t=graythresh(A); 
B=im2bw(A,t);
[a,b]=size(B);
% A = zeros(a,b);
for i=1:a
    for j=1:b
        B(i,j)=1-B(i,j); 
    end
end
imwrite(B,strcat('Char_Image_Binary/1',char(indexFileName(k,1))));
end

