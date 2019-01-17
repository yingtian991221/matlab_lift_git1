%上:1 下:2 左:3 右:4 抬手:5
load new_fusion_up_sit
load new_fusion_down_sit
load new_fusion_left_sit
load new_fusion_right_sit
load new_fusion_rise_sit

A = cat(1,new_fusion_up_sit,new_fusion_down_sit);
B = cat(1,new_fusion_left_sit,new_fusion_right_sit);
C = cat(1,A,B);
E = cat(1,C,new_fusion_rise_sit);
for i=1:320
    if(i<=64)
        label_t(i,1) = 1;
    elseif(i<=128)
        label_t(i,1) = 2;
    elseif(i<=192)
        label_t(i,1) = 3;
    elseif(i<=256)
        label_t(i,1) = 4;
    else
        label_t(i,1) = 5;
    end
end
%mdl = ClassificationKNN.fit(E,label_t,'NumNeighbors',3);
mdl = fitcknn(E,label_t,'NumNeighbors',3);
%mdl = fitcknn(E,label_t,'OptimizeHyperparameters','auto');
dirs = dir('C:\5-rise\*.txt');
dicell = struct2cell(dirs)';
filenames = dicell(:,1);

%处理传感器数据
Fs = 100;
FRoute = 'C:\5-rise\'; 
sensor_Feature_rise = [];
for i=1:48
    filenames(i);
    File = char(filenames(i));
    FName = strcat(FRoute,File);
    matrix = load(FName);
    Feature = [];
    for j=2:4
        signal = matrix(:,j);
        %滑动均值滤波
        L = length(signal);
        N = 10;
        k = 0;
        m = 0;
        for ii = 1:L
            m = m+1;
            if ii+N-1>L
                break
            else
                for jj = ii:ii+N-1
                    k = k+1;
                    z(k) = signal(jj);
                end
                filter_signal(m) = mean(z); 
                k = 0;
            end
        end
        b = 1;
        %只要前2s的数据
        for a = 1: 2*Fs
            final_signal(b) = filter_signal(a);
            b = b+1;
        end
        Feature_ = ExtractFeature(final_signal);%表示每轴数据 467列
        Feature = cat(2,Feature,Feature_);
    end
     sensor_Feature_rise  = cat(1,sensor_Feature_rise,Feature);
end
%选出属于一次数据的三个运动传感器
%1-17-33 16-32-48
num = 0;
for i=1:16
    Xnew = [];
    acc = sensor_Feature_rise(i,:);
    gyr = sensor_Feature_rise(i+16,:);
    lin = sensor_Feature_rise(i+32,:);
    fusion = cat(2,acc,gyr,lin);
    Xnew = cat(1,Xnew,fusion);
    final_label = predict(mdl,Xnew)
    if(final_label == 2)
        num = num+1;
    end
end

num

%16 16 15 14 15  
%95%
