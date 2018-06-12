function Feature44Extraction()
[input1, input2, input3] = textread('Char_Index_kuochong.txt','%d %d %s',2000, 'headerlines',1);%读取图片的编号，类别信息和文件名
indexFileName = input3;%获得文件名
fid=fopen('feature44.txt','w+');%打开feature4.txt，用以储存特征4的数据
for k=1001:2000 %共1000个图片
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));%读入图片
    t=graythresh(A); %取阈值
    B=im2bw(A,t);%二值化，B为二值化后的图像矩阵，每个元素的值为0或1
    [a,b]=size(B);
    C=zeros(1,a+b);%定义特征向量

    for i=1:a
        for j=1:b-1
            if(B(i,j)~=B(i,j+1) && B(i,j+1)==0)
                C(1,i)=C(1,i)+1;%若遇到线段，则增加1，最终结果为每一行的线段数
            end
        end
%         C(1,i) = C(1,i) / 4;所有图像的线段最大值为4
    end

    for j=1:b
        for i=1:a-1
            if(B(i,j)~=B(i+1,j) && B(i+1,j)==0)
                C(1,a+j)=C(1,a+j)+1;%若遇到线段，则增加1，最终结果为每一列的线段数
            end
        end
%         C(1,a+j) = C(1,a+j) / 4;
    end

    fprintf(fid,'%d',k);
    fprintf(fid,'%s','       ');
    for i=1:a+b-1
      fprintf(fid,'%d',C(1,i));%将特征向量写入文本
      fprintf(fid,'%s',',');%用逗号隔开
    end
    if k~=2000
    fprintf(fid,'%d\n',C(1,a+b));%不为最后一行，则每行末尾加回车
    else
    fprintf(fid,'%d',C(1,a+b)); %最后一行则不加
    end

end

fclose(fid);%关闭文件