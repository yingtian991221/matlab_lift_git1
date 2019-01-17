dirs = dir('C:\lab1\lift\*.csv');
dicell = struct2cell(dirs)';
filenames = dicell(:,1);
filenames

FRoute='C:\lab1\lift\';
x=zeros(10,50);
y=zeros(10,50);
z=zeros(10,50);

sensor_Feature_rise = [];
for i=1:10
    
%matrix = load(char(filenames(1)));
    FileName=char(filenames(i));
    Fname=strcat(FRoute,FileName);
    [fid, message] = fopen(Fname,'r');
    %lines=get_lines(fid);


% 
%     [xx,yy,zz,t]=textread(Fname,'%d%d%d%d',50,'delimiter',',','headerlines',1);
% 
%     x(i,:)=xx;
%     y(i,:)=yy;
%     z(i,:)=zz;
    
    Fs = 25;    %25Hz
    File = char(filenames(i));
    FName = strcat(FRoute,File);
    %matrix = load(FName);
    [xx,yy,zz,t]=textread(Fname,'%f%f%f%f','delimiter',',','emptyvalue',0,'headerlines',1);
    matrix=[xx,yy,zz];
    Feature = [];
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
    for j=1:3
        %对x,y,z进行均值滤波
        signal = matrix(:,j);
        %滑动均值滤波
        filter_signal=[];
        L = length(signal);
        N = 3;
        k = 0;
        m = 0;
        z=[];
        for ii = start:start+50   %取3s
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

lift=sensor_Feature_rise;
disp(size(lift));
save('lift','lift');