function PreProcessingToCorrect()
[input] = textread('Char_Index_Err.txt','%s',14);
indexFileName = input;
for k=1:14
A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
t=graythresh(A); 
B=im2bw(A,t);
[a,b]=size(B);
for i=1:a
    for j=1:b
        B(i,j)=1-B(i,j);
    end
end
imwrite(B,strcat('Char_Image_Binary/',char(indexFileName(k,1))));
end

A=imread('Char_Image/20090109154704265ch1IMG.JPG');
B=im2bw(A,0.1);
imwrite(B,'Char_Image_Binary/20090109154704265ch1IMG.JPG');