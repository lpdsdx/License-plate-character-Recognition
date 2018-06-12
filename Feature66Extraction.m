function Feature66Extraction()
[input1, input2, input3] = textread('Char_Index_kuochong.txt','%d %d %s',2000, 'headerlines',1);%读取图片的编号，类别信息和文件名
indexFileName = input3;%获得文件名
fid=fopen('feature66.txt','w+');%打开feature6.txt，用以储存特征6的数据
for k=1001:2000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,8*16);%定义特征向量
    l=1;
    for i=1:6:a
        for j=1:6:b %间隔为6，说明分区区域大小为6*6
            for m=i:min(i+5,a) %之所以取min是防止跳出图像
                for n=j:min(j+5,b)
                    if(B(m,n)==0)
                        C(1,l)=C(1,l)+1;%如果为黑点，区域密度加1，最终结果为区域密度
                    end
                end
            end
            l=l+1;%移向下一个区域
        end
    end

    fprintf(fid,'%d',k);
    fprintf(fid,'%s','       ');
    for i=1:8*16-1
      fprintf(fid,'%d',C(1,i));%将特征向量写入文本
      fprintf(fid,'%s',',');
    end
    if k~=2000
    fprintf(fid,'%d\n',C(1,8*16));%不为最后一行，则每行末尾加回车
    else
    fprintf(fid,'%d',C(1,8*16)); %最后一行则不加
    end

end

fclose(fid);%关闭文件





