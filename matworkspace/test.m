dirs = dir('C:\lab\down\*.csv');
dicell = struct2cell(dirs)';
filenames = dicell(:,1);
filenames

FRoute='C:\lab\down\';
x=zeros(10,50);
y=zeros(10,50);
z=zeros(10,50);
for i=1:10
    
%matrix = load(char(filenames(1)));
    FileName=char(filenames(i));
    Fname=strcat(FRoute,FileName);
    [fid, message] = fopen(Fname,'r');
    lines=get_lines(fid);
Fname


    [xx,yy,zz,t]=textread(Fname,'%d%d%d%d',50,'delimiter',',','headerlines',1);

    x(i,:)=xx;
    y(i,:)=yy;
    z(i,:)=zz;
end
A=cat(2,x,y);
down=cat(2,A,z);
save('down','down');