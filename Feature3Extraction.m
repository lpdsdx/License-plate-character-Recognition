function Feature3Extraction()
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);%读取图片的编号，类别信息和文件名
indexFileName = input3;%获得文件名
fid=fopen('feature3.txt','w+');%打开feature3.txt，用以储存特征3的数据
for k=1:1000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));%读入图片
    t=graythresh(A); 
    B=im2bw(A,t);%二值化，B为二值化后的图像矩阵，每个元素的值为0或1
    [a,b]=size(B);
    C=zeros(1,a*2+b*2);%定义特征向量

    for i=1:a
        for j=1:b
            if(B(i,j)==1)
                C(1,i)=j-1;%由左边起，遇到白点，-1则计算出字符与左边距离
                break;
            end
            if(j==b && B(i,j)==0)
                C(1,i)=b;%若这一行不存在字符元素，距离为最大，取b
            end
        end
%         C(1,i) = C(1,i) / b;
    end

    for i=1:a
        for j=b:-1:1 %从右向左
            if(B(i,j)==1)
                C(1,a+i)=b-j;%由右边起，遇到白点，计算出字符与右边距离
                break;
            end
            if(j==1 && B(i,j)==0)
                C(1,a+i)=b;%若这一行不存在字符元素，距离为最大，取b
            end
        end
%         C(1,a+i) = C(1,a+i) / a;
    end

    for j=1:b
        for i=1:a
            if(B(i,j)==1)
                C(1,a*2+j)=i-1;%由上边起，遇到白点，计算出字符与右边距离
                break;
            end
            if(i==a && B(i,j)==0)
                C(1,a*2+j)=a;%若这一列不存在字符元素，距离为最大，取a
            end
        end
%         C(1,a*2+j) = C(1,a*2+j) / a;
    end

    for j=1:b
        for i=a:-1:1
            if(B(i,j)==1)
                C(1,a*2+b+j)=a-i;%由下边起，遇到白点，计算出字符与右边距离
                break;
            end
            if(i==1 && B(i,j)==0)
                C(1,a*2+b+j)=a;%若这一列不存在字符元素，距离为最大，取a
            end
        end
%         C(1,a*2+b+j) = C(1,a*2+b+j) / a;
    end

    fprintf(fid,'%d',k);
    fprintf(fid,'%s','       ');
    for i=1:a*2+b*2-1
      fprintf(fid,'%d',C(1,i));%将特征向量写入文本
      fprintf(fid,'%s',',');
    end
    if k~=1000
    fprintf(fid,'%d\n',C(1,a*2+b*2));%不为最后一行，则每行末尾加回车
    else
    fprintf(fid,'%d',C(1,a*2+b*2)); %最后一行则不加
    end

end

fclose(fid);%关闭文件