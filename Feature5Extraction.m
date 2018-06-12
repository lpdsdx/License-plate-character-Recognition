function Feature5Extraction()
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);%读取图片的编号，类别信息和文件名
indexFileName = input3;%获得文件名
fid=fopen('feature5.txt','w+');%打开feature5.txt，用以储存特征5的数据
for k=1:1000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,12*23);%定义特征向量
    l=1;
    for i=1:4:a
        for j=1:4:b %间隔为4，说明分区区域大小为4*4
            for m=i:min(i+3,a) %之所以取min是防止跳出图像
                for n=j:min(j+3,b)
                    if(B(m,n)==1)
                        C(1,l)=C(1,l)+1;%如果为白点，区域密度加1，最终结果为区域密度
                    end
                end
            end
            l=l+1;%移向下一个区域
        end
    end

    fprintf(fid,'%d',k);
    fprintf(fid,'%s','       ');
    for i=1:12*23-1
      fprintf(fid,'%d',C(1,i));%将特征向量写入文本
      fprintf(fid,'%s',',');
    end
    if k~=1000
    fprintf(fid,'%d\n',C(1,12*23));%不为最后一行，则每行末尾加回车
    else
    fprintf(fid,'%d',C(1,12*23));%最后一行则不加
    end

end

fclose(fid);%关闭文件





