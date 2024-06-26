%%%%%%%%%%%%%%%
clear all;close all;clc
addpath(genpath('E:\ROMSѧϰ\download_data_process\submeso\analysis\GSW\seawater\seawater'));
addpath('F:\TWS_Acrobat\TWS_Acrobat\TWS_Acrobat\')
load('data_D_E_horizontal_interval_100m.mat');


%%

load('data_D_E_horizontal_interval_100m.mat');

[Ds,De]=meshgrid(DAT.distance_0,-DAT.P_0);
Ds1=(Ds(1:end-1,1:end-1)+Ds(1:end-1,2:end))./2;
De1=(De(1:end-1,1:end-1)+De(2:end,1:end-1))./2;

PotDen=sw_dens(DAT.SA_0,DAT.pt_0,0);

ds_low=0:.1:max(DAT.distance_0);
de_low=-(0:.5:max(DAT.P_0));
[Ds_low,De_low]=meshgrid(ds_low,de_low);
Ds_low1=(Ds_low(1:end-1,1:end-1)+Ds_low(1:end-1,2:end))./2;
De_low1=(De_low(1:end-1,1:end-1)+De_low(2:end,1:end-1))./2;

PotDen_low=griddata(Ds,De,PotDen,Ds_low,De_low);
PotDen_low=fliplr(PotDen_low-1000);

PotTemp_low=griddata(Ds,De,DAT.pt_0,Ds_low,De_low);
PotTemp_low=fliplr(PotTemp_low);

PotSalt_low=griddata(Ds,De,DAT.SA_0,Ds_low,De_low);
PotSalt_low=fliplr(PotSalt_low);


Buo_low=(-9.8/1025).*(PotDen_low-1000);
N2_low=(Buo_low(2:end,:)-Buo_low(1:end-1,:))./...
    (De_low(2:end,:)-De_low(1:end-1,:));
N2_low=(N2_low(:,1:end-1)+N2_low(:,2:end))./2;
M2_low=(Buo_low(:,2:end)-Buo_low(:,1:end-1))./...
    (Ds_low(:,2:end)-Ds_low(:,1:end-1))./1000;
M2_low=(M2_low(1:end-1,:)+M2_low(2:end,:))./2;
f=sw_f(24.5);
Rib_low=((f.^2).*N2_low)./((M2_low).^2);
Rib_index=Rib_low;
Rib_index(Rib_index>=1)=1;
Rib_index(Rib_index>=0 & Rib_index<1)=2;
Rib_index(Rib_index>=-1 & Rib_index<0)=3;
Rib_index(Rib_index<-1)=4;

figure(1)
clf

f1=subplot(5,2,1)
pcolor(Ds_low,De_low,PotDen_low);
shading interp
hold on
contour(Ds_low,De_low,PotDen_low,[23.7,23.9,24],'k','LineWidth',2);
colorbar;
caxis([23.4,24.2]);
colormap("jet");
xticks(0:5:40);
yticks(-50:10:0);
ylabel('Depth (m)');
A1=get(f1,'pos');
A1(1)=A1(1)-0.05;
A1(2)=A1(2)+0.035;
A1(3)=A1(3)-0.00;
A1(4)=A1(4)+0.03;
set(f1,'pos',A1);
set(gca,'fontsize',12,'fontweight','bold');

lon=DAT.lon;lat=DAT.lat;
lon0=DAT.lon_0;lat0=DAT.lat_0;


[a,b]=meshgrid(lon,lat);
[lona,lonb,lata,latb]=m_range_zsm(a,b);


m_proj('mercator','lon',[117,122],'lat',[22,25]);
hold on;
m_line(lon,lat,'color','r','linewi',1.2);
m_line(lon0,lat0,'color','b')
m_gshhs_f('patch',[.7 .7 .7]);
% m_coast('patch',[.7 .7 .7]);
m_grid

% lon1=lon(2:end)-lon(1:end-1);
% lat1=lat(2:end)-lat(1:end-1);
xxx=[0:250:40e3];
u=DAT.u;v=DAT.v;
[xddd2,u2]=avg_alongtrack(lon,lat,xxx,u);
[xddd2,v2]=avg_alongtrack(lon,lat,xxx,v);


save('mvppos.mat','lon','lat','lon0','lat0','Ds_low','De_low','PotTemp_low','PotSalt_low','PotDen_low');




% PotDen=sw_pden(DAT.SA_0,DAT.pt_0,De,0);

PotDen=fliplr(PotDen);
Buo=(-9.8/1025).*PotDen;
N2=(Buo(2:end,:)-Buo(1:end-1,:))./...
    (De(2:end,:)-De(1:end-1,:));
N2=(N2(:,1:end-1)+N2(:,2:end))./2;
M2=(Buo(:,2:end)-Buo(:,1:end-1))./...
    (Ds(:,2:end)-Ds(:,1:end-1))./1000;
M2=(M2(1:end-1,:)+M2(2:end,:))./2;
f=sw_f(24.5);
Rib=((f.^2).*N2)./((M2).^2);

figure(2)
clf

subplot(2,2,1)
pcolor(Ds,-De,PotDen);
shading interp
hold on
contour(Ds,-De,PotDen,[1023.6,1023.9,1024],'k');
colorbar;
caxis([1023,1024.3]);
colormap("jet");

subplot(2,2,2)
% Rib(Rib<0)=1e-2;
% contourf(Ds1,-De1,N2,50,'linestyle','none');
% contourf(Ds1,-De1,log10(Rib),50,'linestyle','none');
pcolor(Ds1,-De1,N2);
shading interp
hold on
contour(Ds,-De,PotDen,[1023.6,1023.9,1024],'k');
colorbar;
caxis([-50e-3,50e-3]);
colormap("jet");

subplot(2,2,3)
% Rib(Rib<0)=1e-2;
% contourf(Ds1,-De1,N2,50,'linestyle','none');
% contourf(Ds1,-De1,log10(Rib),50,'linestyle','none');
pcolor(Ds1,-De1,M2);
shading interp
hold on
contour(Ds,-De,PotDen,[1023.6,1023.9,1024],'k');
colorbar;
caxis([-10e-2,10e-2]);
colormap("jet");

subplot(2,2,4)
Rib(Rib<0)=1e-2;
% contourf(Ds1,-De1,N2,50,'linestyle','none');
% contourf(Ds1,-De1,log10(Rib),50,'linestyle','none');
pcolor(Ds1,-De1,log10(1./Rib));
shading interp
hold on
contour(Ds,-De,PotDen,[1023.6,1023.9,1024],'k');
colorbar;
caxis([-3,3]);
colormap("jet");
%%

ds_low=0:.2:max(DAT.distance_0);
de_low=-(0:.5:max(DAT.P_0));
[Ds_low,De_low]=meshgrid(ds_low,de_low);
Ds_low1=(Ds_low(1:end-1,1:end-1)+Ds_low(1:end-1,2:end))./2;
De_low1=(De_low(1:end-1,1:end-1)+De_low(2:end,1:end-1))./2;
PotDen_low=griddata(Ds,De,PotDen,Ds_low,De_low);
PotDen_low=fliplr(PotDen_low-1000);
Buo_low=(-9.8/1025).*(PotDen_low-1000);
N2_low=(Buo_low(2:end,:)-Buo_low(1:end-1,:))./...
    (De_low(2:end,:)-De_low(1:end-1,:));
N2_low=(N2_low(:,1:end-1)+N2_low(:,2:end))./2;
M2_low=(Buo_low(:,2:end)-Buo_low(:,1:end-1))./...
    (Ds_low(:,2:end)-Ds_low(:,1:end-1))./1000;
M2_low=(M2_low(1:end-1,:)+M2_low(2:end,:))./2;
f=sw_f(24.5);
Rib_low=((f.^2).*N2_low)./((M2_low).^2);
Rib_index=Rib_low;
Rib_index(Rib_index>=1)=1;
Rib_index(Rib_index>=0 & Rib_index<1)=2;
Rib_index(Rib_index>=-1 & Rib_index<0)=3;
Rib_index(Rib_index<-1)=4;

figure(2)
clf

f1=subplot(2,2,1)
pcolor(Ds_low,De_low,PotDen_low);
shading interp
hold on
contour(Ds_low,De_low,PotDen_low,[23.6,23.9,24],'k');
colorbar;
caxis([23.5,24.2]);
colormap("jet");

f2=subplot(2,2,2)
pcolor(Ds_low1,De_low1,N2_low);
shading interp
hold on
contour(Ds_low,De_low,PotDen_low,[23.6,23.9,24],'k');
colorbar;
caxis([-1e-3,1e-3]);
colormap(f2,GMT_polar);

f3=subplot(2,2,3)
pcolor(Ds_low1,De_low1,M2_low);
shading interp
hold on
contour(Ds_low,De_low,PotDen_low,[23.6,23.9,24],'k');
colorbar;
caxis([-2e-6,2e-6]);
colormap(f3,GMT_polar);

f3=subplot(2,2,3)
pcolor(Ds_low1,De_low1,Rib_low);
shading interp
hold on
contour(Ds_low,De_low,PotDen_low,[23.7,23.9,24],'b','LineWidth',2);
% contour(Ds_low1,De_low1,Rib_low,[.25,1],'g','LineWidth',2);
colorbar;
caxis([-2,4]);
% colormap(f4,flipud(WhiteBlue));
colormap(f3,hsv);
% colormap(f3,(cool));
% colormap(f4,dia_color);

f4=subplot(2,2,4)

map=[1,0,0;1,1,0;0,1,0;0,0,1];
scatter(reshape(Ds_low1,[],1),reshape(De_low1,[],1),10,reshape(Rib_index,[],1),'s','filled');
c=colorbar;
caxis([1,4]);
colormap(f4,flipud(map));
set(c,'ticks',1:4,'ticklabels',{'BCI&stable','SI','GI&SI','GI'});
hold on
contour(Ds_low,De_low,PotDen_low,[23.7,23.9,24],'k','LineWidth',2);
box on

%%

figure(1)
clf

subplot(2,1,1)
pcolor(Ds,-De,fliplr(DAT.pt_0));
shading interp
hold on
contour(Ds,-De,fliplr(DAT.pt_0),[17,20],'k');
caxis([15,22]);
colormap("jet");

subplot(2,1,2)
pcolor(Ds,-De,fliplr(DAT.SA_0));
shading interp
hold on
contour(Ds,-De,fliplr(DAT.SA_0),[33,34],'k');
caxis([31,35]);
colormap("jet");

figure(2)
clf

scatter(DAT.lon,DAT.lat);
