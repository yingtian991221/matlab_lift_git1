%��:1 ��:2 ��:3 ��:4 ̧��:5
load up
load down
load left
load right
load lift


A = cat(1,up,down);
B = cat(1,left,right);
C = cat(1,A,B);
E = cat(1,C,lift);
for i=1:50
    if(i<=10)
        label_t(i,1) = 1;
    elseif(i<=20)
        label_t(i,1) = 2;
    elseif(i<=30)
        label_t(i,1) = 3;
    elseif(i<=40)
        label_t(i,1) = 4;
    else
        label_t(i,1) = 5;
    end
end
disp(size(E));
mdl = ClassificationKNN.fit(E,label_t,'NumNeighbors',3);
%mdl = fitcknn(E,label_t,'NumNeighbors',3);
%mdl = fitcknn(E,label_t,'OptimizeHyperparameters','auto');
%mdl = fitcecoc(E,label_t); %�����
dirs = dir('C:\lab1\lift\test\*.csv');
dicell = struct2cell(dirs)';
filenames = dicell(:,1);
%������������
Fs = 25;    %25Hz
FRoute = 'C:\lab1\lift\test\'; 
sensor_Feature_rise = [];
for i=1:10
    File = char(filenames(i));
    FName = strcat(FRoute,File);
    Feature=[];
    %matrix = load(FName);
    disp(FName);
    [xx,yy,zz,t]=textread(FName,'%f%f%f%f','delimiter',',','emptyvalue',0,'headerlines',1);
    matrix=[xx,yy,zz];
   % disp(xx);
    avg=zeros(1,3);
    for j=1:300
        differ=abs(matrix(j+1,1)-matrix(j,1))+abs(matrix(j+1,2)-matrix(j,2))+abs(matrix(j+1,3)-matrix(j,3));
        avg(1,1)=avg(1,1)+matrix(j,1);
        avg(1,2)=avg(1,2)+matrix(j,2);
        avg(1,3)=avg(1,3)+matrix(j,3);
        if differ>=50 break;
        end
    end
    start=j;
    for i=1:3
        %avg(1,i)=avg(1,i)/start;
        avg(1,i)=0;
    end
    
    %time=start:start+2*Fs;
    %figure;
   % plot(time,matrix(time,1),'.');
        
    for j=1:3
        %��x,y,z���о�ֵ�˲�
        signal = matrix(:,j);
        %������ֵ�˲�
        filter_signal=[];
        L = length(signal);
        N = 3;
        k = 0;
        m = 0;
        z=[];
        for ii = start:start+50   %ȡ3s
            m = m+1;
            if ii+N-1>L
                break
            else
                for jj = ii:ii+N-1
                    k = k+1;
                    z(k) = signal(jj);
                end
                filter_signal(m) = mean(z)-avg(1,j); 
                k = 0;
            end
        end
        b = 1;
        %ֻҪǰ2s������
        for a = 1: 2*Fs
            final_signal(b) = filter_signal(a);
            b = b+1;
        end
        Feature_ = ExtractFeature(final_signal);%��ʾÿ������ 467��
        Feature = cat(2,Feature,Feature_);
        
    end
     sensor_Feature_rise  = cat(1,sensor_Feature_rise,Feature);
end
%disp(sensor_Feature_rise);
num = 0;
for i=1:10
    Xnew = sensor_Feature_rise(i,:);
    final_label = predict(mdl,Xnew)
    if(final_label == 5)
        num = num+1;
    end
end

num


%8  8   7   9   4
%��Ҫ��up�ֲ���
%* * 10 2 9