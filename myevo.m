% read csv & data
%csv = csvread('/media/zhaonan/Dataset/euroc/MH_05_easy/mav0/state_groundtruth_estimate0/data.csv',1);
clc;close all;clear all
mono = load('lidar.txt');
csv = load('camera.txt');

%两个文件的时间小数点一致
%csv(:,1)=csv(:,1)*10^-9;

idx=[];
[m,n]=size(mono);
for i=1:m 
           TimeS=mono(i,1)*ones(size(csv,1),1);%guiding diyihang diyilie de shuju 
           [error,idxx]=min(abs(csv(:,1)-TimeS));%na csv zhong suoyou de shuju yu ta bijiao 
    
           idx=[idx,idxx]; %time yiyang duiying de hang shu

end
csv_dq=csv(idx,:);%baocun tiqu hou de shuju

csv_dq_x=csv_dq(:,2); csv_dq_y=csv_dq(:,3); csv_dq_z=csv_dq(:,4);
monox=mono(:,2); monoy=mono(:,3); monoz=mono(:,4);

gtx=csv_dq_x-csv_dq_x(1);
gty=csv_dq_y-csv_dq_y(1);
gtz=csv_dq_z-csv_dq_z(1);


gt = [gtx,gty,gtz]; gt=gt';
ours = [monox,monoy,monoz]; ours=ours';

%保存时间戳对齐的文件
%gt_t=csv(:,1);gt_x=csv(:,2);gt_y=csv(:,3);gt_z=csv(:,4);gt_w=csv(:,5);gt_q_x=csv(:,6);gt_q_y=csv(:,7);gt_q_z=csv(:,8);
%gt_o=[gt_t,gt_x,gt_y,gt_z,gt_w,gt_q_x,gt_q_y,gt_q_z];
%dlmwrite('/home/zhaonan/ORB_Slam_map/VI_ORB_SLAM2/run_result/mono_VI/imu.txt',imu,'precision',15,'delimiter',' ','newline','pc')
%dlmwrite('/media/zhaonan/Dataset/euroc/MH_05_easy/mav0/state_groundtruth_estimate0/groundtruth.txt',gt_o,'precision',15,'delimiter',' ','newline','pc')
% ini plot
figure(1);
plot3(gtx,gty,gtz,'ro');
grid on;
hold on;
plot3(monox,monoy,monoz,'b*');
%figure
%plot(monoy,monoz,'b*');
grid on;
hold on;
legend('r--ground truth','b--ours');

[R, t] = umeyama(ours, gt);
trans_ours=(R*ours)';
trans_x1=trans_ours(:,1);
trans_y1=trans_ours(:,2);
trans_z1=trans_ours(:,3);

% after R plot
figure(2);
% plot3(csv_dq_x,csv_dq_y,csv_dq_z,'r');
plot3(gtx,gty,gtz,'ro');
grid on;
hold on;
plot3(trans_x1',trans_y1',trans_z1','b*');
grid on;
hold on;
legend('r--ground truth','b--trans_ours');

error=abs(trans_ours'-gt);
[maxx,idmaxx]=max(error(1,:));


[m,n]=size(error);
idx=ones(1,n);
dis=zeros(1,n);
sum_dis=zeros(1,n);
APE=zeros(1,n);
med=zeros(1,n);
m=zeros(1,n);
s=zeros(1,n);
rmse=zeros(1,n);

error_x=error(1,:);
error_y=error(2,:);
error_z=error(3,:);

for i = 2:n
   idx(i)=i;
   dis(i)=sqrt((error(1,i)-error(1,i-1))^2+(error(2,i)-error(2,i-1))^2+((error(3,i)-error(3,i-1))^2));
   sum_dis(i)=sum_dis(i-1)+dis(i);
   APE(i)=sqrt(error(1,i)^2+error(2,i)^2+error(3,i)^2);
end

for i = 1:n
   med(i)=median(APE,2);
   m(i)=mean(APE);
   s(i)=std(APE); % range ???
   rmse(i)=sqrt(sum(APE.^2)/n);
end

% by distance -------
figure(3);grid on; hold on;
plot(sum_dis,error_x,'r'); hold on;
plot(sum_dis,error_y,'g'); hold on;
plot(sum_dis,error_z,'b'); hold on;
legend('r--error_x','g--error_y','b--error_z');
xlabel('Distance [m]');
ylabel('Error  [m]');
title('Variation of error along track length');

figure(4);grid on; hold on;
plot(sum_dis,APE,'r'); hold on;
plot(sum_dis,med,'g'); hold on;
plot(sum_dis,m,'b'); hold on;
plot(sum_dis,s,'y'); hold on;
plot(sum_dis,rmse,'w'); hold on;
legend('r--APE','g--median','b--mean','y--std','--rmse');
xlabel('Distance [m]');
ylabel('APE  [m]');
title('Variation of error along track length');

% by index -------
figure(5);grid on; hold on;
plot(idx,error_x,'r'); hold on;
plot(idx,error_y,'g'); hold on;
plot(idx,error_z,'b'); hold on;
legend('r--error_x','g--error_y','b--error_z');
xlabel('index');
ylabel('Error  [m]');
title('Variation of error along track index');

figure(6);grid on; hold on;
plot(idx,APE,'r'); hold on;
plot(idx,med,'g'); hold on;
plot(idx,m,'b'); hold on;
plot(idx,s,'y'); hold on;
plot(idx,rmse,'w'); hold on;
legend('r--APE','g--median','b--mean','y--std','w--rmse');
xlabel('index');
ylabel('APE  [m]');
title('Variation of error along track index');