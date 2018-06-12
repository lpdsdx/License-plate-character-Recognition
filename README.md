# 基于Matlab的车牌字符识别

# 文件说明：

### 无数据扩充程序：Featrue1.m-Featrue6.m，test.m，Char_Index.txt

### 有数据扩充程序：Featrue11.m-Featrue66.m，test1.m，Char_Index_kuochong.txt

### main.m为主程序，Char_Index_Err.txt为需要人工校正的字符名称列表



## 使用工具：Matlab，libsvm3.2.2

本文主要通过以下几个方面进行介绍：

- **数据预处理**
- **特征提取**
- **模型训练与测试**
- **模型优化**

本案例是通过SVM分类器对样本进行训练与测试，达到识别车牌字母、数字及汉字的目的。关于SVM的原理这里就不多赘述了，想了解的同学可以看下陈老师的SVM讲解，写的细致且易懂。

[耳东陈：零基础学SVM—Support Vector Machine(一)](https://zhuanlan.zhihu.com/p/24638007) 

数据集是已经分割好的车牌字符，共有1000张车牌字符图片，大小均为47*92，两个txt文本文件分别包含所有字符和需要手工校正的字符图片的名字及对应的类别。

### 1.数据预处理

将字符图像进行二值化操作，将图像上的像素点的灰度值设置为0或255，也就是将整个图像呈现出明显的黑白效果的过程，而在Matlab中，一幅二值图像是一个取值只有0和1的逻辑数组。通常做法是先把彩色图像转化为灰度图像，再转化为呈现黑白的二值图像，此处我是直接将彩色RGB图转化为二值图，因为与后面的手工校正相关联。当转化完你会发现，大部分字符图像变为黑底白字，但是还有小部分为白底黑字，所以还需将此部分的图像进行反转处理，代码如下：

```
%读取文件
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
indexFileName = input3;
for k=1:1000
    A=imread(strcat('Char_Image/',char(indexFileName(k,1))));
    t=graythresh(A);%设置阈值
    B=im2bw(A,t);%将灰度图转化为二值图
%以图像左上角为原点，向下为x轴，向右为y轴，四个角的值大于等于2，即有2及以上为白点的，进行反转
    [a,b]=size(B);
    if(B(1,1)+B(1,b)+B(a,1)+B(a,b)>=2)
        for i=1:a
            for j=1:b
                B(i,j)=1-B(i,j);
            end
        end
    end
    imwrite(B,strcat('Char_Image_Binary/',char(indexFileName(k,1))));
end
```

经过上述步骤（二值化，反转），大部分字符已经转为黑底白字，但仍有小部分顽固字符宁死不屈，这里便进行人工校正。你可能会认为人工参与成本高，仅限于小数据量样本，并且项目上线后会不断地产生同样问题，所以这并完美，那么设想下，如果能实现全自动不就解决此问题了吗？该采取什么方法？这里先卖个关子，后面优化部分会跟大家分享。下图为人工筛选出的白底黑字部分字符名称。


这里要做的，仅仅是将这14张字符进行图片反转即可，最终得到全部的黑底白字的车牌字，代码如下：

```
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
```

### 2.特征提取

### 2.1 每一行和每一列的白点数

读取1000张图片，并将每一行和每一列的白点计数存于featrue1.txt中，代码如下：

```
[input1, input2, input3] = textread('Char_Index_kuochong.txt','%d %d %s',1000, 'headerlines',1);
indexFileName = input3;
fid=fopen('feature1.txt','w+');
for k=1:1000 
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,a+b); 
    for i=1:a
        for j=1:b
            if(B(i,j)==1)
                C(1,i)=C(1,i)+1;
            end
        end
    end
 
    for j=1:b
        for i=1:a
            if(B(i,j)==1)
                C(1,a+j)=C(1,a+j)+1;
            end
        end
    end
end
fclose(fid);
```

得到的feature1.txt部分内容如下图：


### 2.2 区域密度，大小为8*8

顾名思义，将图像分割成n块区域，每块区域的大小为8*8。注意n的取值，因为原图像大小为47*92，会有除不尽的情况，为了保证图像所有元素均被取到，故要采取进一法，代码如下：

```
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
indexFileName = input3;
fid=fopen('feature2.txt','w+');
for k=1:1000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,6*12);
    l=1;
    for i=1:8:a  
        for j=1:8:b  
            for m=i:min(i+7,a)
                for n=j:min(j+7,b)
                    if(B(m,n)==1)
                        C(1,l)=C(1,l)+1;
                    end
                end
            end
            l=l+1;
        end
    end
end
fclose(fid);
```

### 2.3 字符左右上下与边界的距离

从边界开始走，当碰到字符时则返回所走过的距离（步数），假如某行或某列没有字符元素，则返回最大值，代码如下：

```
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
indexFileName = input3;
fid=fopen('feature3.txt','w+');
for k=1:1000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,a*2+b*2);
    for i=1:a
        for j=1:b
            if(B(i,j)==1)
                C(1,i)=j-1;
                break;
            end
            if(j==b && B(i,j)==0)
                C(1,i)=b;
            end
        end
    end 
    for i=1:a
        for j=b:-1:1 
            if(B(i,j)==1)
                C(1,a+i)=b-j;
                break;
            end
            if(j==1 && B(i,j)==0)
                C(1,a+i)=b;
            end
        end
    end
    for j=1:b
        for i=1:a
            if(B(i,j)==1)
                C(1,a*2+j)=i-1;
                break;
            end
            if(i==a && B(i,j)==0)
                C(1,a*2+j)=a;
            end
        end
    end
    for j=1:b
        for i=a:-1:1
            if(B(i,j)==1)
                C(1,a*2+b+j)=a-i;
                break;
            end
            if(i==1 && B(i,j)==0)
                C(1,a*2+b+j)=a;
            end
        end
    end
end
fclose(fid);
```

### 2.4 每一行和每一列的线段数目

此处的线段数目指的是白色线段，注意判断条件为第n步元素颜色与第n+1步元素不同且由黑转白，代码如下：

```
[input1, input2, input3] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
indexFileName = input3;
fid=fopen('feature4.txt','w+');
for k=1:1000
    A=imread(strcat('Char_Image_Binary/',char(indexFileName(k,1))));
    t=graythresh(A); 
    B=im2bw(A,t);
    [a,b]=size(B);
    C=zeros(1,a+b);
    for i=1:a
        for j=1:b-1
            if(B(i,j)~=B(i,j+1) && B(i,j+1)==1)
                C(1,i)=C(1,i)+1;
            end
        end
    end 
    for j=1:b
        for i=1:a-1
            if(B(i,j)~=B(i+1,j) && B(i+1,j)==1)
                C(1,a+j)=C(1,a+j)+1;
            end
        end
    end 
end 
fclose(fid);
```

### 2.5 区域密度，大小为4*4/6*6

原理同2.2，只不过大小改为4*4和6*6，代码就不上了，感兴趣的同学可以自己动手写下，有问题留言，大家一起讨论。

### 3.训练模型与测试

这里用的是SVM算法，而且还要用到台湾大学林智仁(Lin Chih-Jen)教授等开发设计的一个简单、易于使用和快速有效的SVM模式识别与回归的libsvm3.2.2软件包。该软件包的安装及用法我就不多做介绍了，利用好Google可以自己解决。然后读取之前提取的任一种特征作为数据集，随机选取800个数据为训练集，剩下的200个数据为测试集。注意，当选完训练集和测试集后，记得存储，以便保证后面调参的有效性。

接下来选取核函数，当我们不知道那种核函数效果好的时候，通常采用交叉验证法，来试用不同的核函数，误差最小的即为效果最好的核函数。我分别测试了多项式核函数、高斯径向基核函数、sigmoid核函数三种，最终结果是多项式核函数效果最好，代码如下：

```
feature = textread('feature2.txt','%d','delimiter', ','); 
feature = reshape(feature,[73 1000]);
feature = feature';
feature = feature(:,2:end);

classification_num = 13;
allclass = [10 11 12 20 22 25 26 28 30 31 32 33 34];
indexInfo = ['京' '渝' '鄂' '0'  '2' '5' '6' '8' 'A' 'B' 'C' 'D' 'Q'];
[~, class, name] = textread('Char_Index.txt','%d %d %s',1000, 'headerlines',1);
train_num = 800;
selection_index = (randperm (1000) <= train_num);
save selection_index.mat selection_index;

model = svmtrain( class(selection_index,:),feature(selection_index,:),'-t 1 -d 3 -g 0.01 -r 2');
[predict_label, accuracy, dec_values] = svmpredict(class(~selection_index,:),feature(~selection_index,:), model);
```

### 4.模型优化

当测试完6个特征后发现准确率最高为99.5%，此时你会心想到底能否达到100%？该采取什么方法来优化模型？这里便引入特征融合的概念，本案例用的也是其中最简单的一种，即将前面提取的6种特征拼接在一起，实现特征互补，降低单一特征固有缺陷的影响。实验证明，该方法是有效果的，最后识别准确率100%。

前文还提到人工校正能否改为全自动的问题，其实思路很简单，人工校正的目的就是将车牌字符全部成为黑底白字，便于模型识别正确分类，那如果将模型稍微改进下，能将黑底白字和白底黑字的字符都能识别并正确分类不就解决了？感兴趣的同学可以自己试试。

### 5.总结

- **前期的数据处理和特征工程很重要，套用一句广泛流传的名言：数据和特征决定了机器学习的上限，而模型和算法只是逼近这个上限而已**

- **SVM为二分类器，因此本案例是将多分类问题转换为二分类问题，即一个字符与其他字符**

- **特征融合可以有效解决单一特征固有缺陷的影响，提高准确率**

- **本案例还需改善，例如对数据归一化，这对无论ML还是DL都是很重要的思想**
