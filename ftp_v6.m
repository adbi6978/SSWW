%Fourier Transform Profilometry
close all;
clear; 
%==========Experimental Parameters===========
L = 1465;
D = 390; %dBest = 390
f = 10.8/116*.20;
% f = 10;

%==========Read in Images===========
refim = im2double(rgb2gray(imread('IMG_0055.CR2')));
dataim = im2double(rgb2gray(imread('IMG_0060.CR2')));

refim = imcrop(refim,[2300 1400 1500 1500]);
dataim = imcrop(dataim,[2300 1400 1500 1500]);

% refim = adapthisteq(refim,'clipLimit',0.02,'Distribution','rayleigh');
% dataim = adapthisteq(dataim,'clipLimit',0.02,'Distribution','rayleigh');

tic
% 
% refim = medfilt2(refim,[10,10]);
% dataim = medfilt2(dataim,[10,10]);

[refimFilt,dataimFilt] = filterIMG(refim,dataim);

dp = ones(size(refim));
for ii = 1:size(refim,2)
    dp(ii,:) = (1/2)*(-angle(ifft(fft(hilbert(refimFilt(ii,:)))))...
        + angle(ifft(fft(hilbert(dataimFilt(ii,:))))));
end

% dp = dp';

% tol = 0.9*pi;
% for jj = 2:size(refim,2)
%     for ii = 1:size(refim,2)
%         deltaDp = dp(ii,jj)-dp(ii,jj-1);
%         if abs(deltaDp) >= 0.9*tol
%             if deltaDp < 0
%                 dp(ii,jj) = dp(ii,jj) + deltaDp;
%             else
%                 dp(ii,jj) = dp(ii,jj) - deltaDp;
%             end
%         end
%     end
% end


tol = pi*1.5;
for jj = 1:size(refim,2)
    for ii = 1:length(refim)-1
        if abs(dp(ii + 1,jj) - dp(ii,jj)) > tol
            dp(ii+1:end,jj) = dp(ii+1:end,jj)...
                -  (dp(ii + 1,jj) - dp(ii,jj));
        end
    end
end


tol = pi/1.5;
for ii = 1:size(refim,2)
    for jj = 1:length(refim)-1
        if abs(dp(ii,jj+1) - dp(ii,jj)) > tol
            dp(ii,jj+1:end) = dp(ii,jj+1:end)...
                -  (dp(ii,jj+1) - dp(ii,jj));
        end
    end
end
% disp('median filtering....')
dp = medfilt2(dp,[10,10]);
toc
dp = -dp;
figure;
surf(dp, 'edgecolor', 'none');

% xPlot = linspace(500,1000,1001);
% yPlot = linspace(0,1000,1001);
% 
% surf(xPlot,yPlot,dp,'edgecolor','none');
% 
% h = -flipud(dp * L .* (dp - 2*pi*D*f).^-1);
% h = 2*h;
% [1:length(h(:,1000))]/10.8;


% [vdim, hdim] = size(h);
% xPlot = linspace(0,1400/111,1401);
% % figure;
% % surf(xPlot,xPlot,h,'edgecolor','none')
% 
% xList1 = linspace(0,71/2);
% yFunc1 = xList1*(76/71);
% figure;
% plot(xList1+11,yFunc1,'b','linewidth',2);
% hold on
% 
% xList2 = linspace(71/2,71);
% yFunc2 = xList2*(-76/71)+76;
% plot(xList2+11,yFunc2,'b','linewidth',2);
% 
% plot([1:length(h(:,1000))]/10.8,h(:,1000),'k');
% plot([1:length(h(:,500))]/10.8,h(:,500),'g');
% plot([1:length(h(:,1200))]/10.8,h(:,1200),'r');


% plot(dp(:,1000),'k');

% figure;
% surf(1:vdim, 1:hdim, h, 'edgecolor', 'none')
% figure;
% contour(1:vdim, 1:hdim, h)
% colorbar;

% min1 = min(refim(1000,1040:1060));
% min2 = min(refim(1000,1140:1190));
% 
% for ii = 1040:1060
%     if refim(1000,ii) == min1
%         xmin = ii;
%     end
% end
% 
% for ii = 1140:1190
%     if refim(1000,ii) == min2
%         xmax = ii;
%     end
% end
% 
% x = xmax-xmin;
% for i = 1:size(dp,1)
%     if (dp(i) > 1.5)
%         dp(i) = 0;
%     end
% end
% 
% for jj = 1:size(refim,2)
%     for ii = 1:length(refim)
%         if dp(ii,jj) > 1.5
%             dp(ii,jj) = inf
%         end
%     end
% end
 
% plot([1:length(h(:,1000))]/10.8,h(:,1000),'k');

% a = (flipud(dp(:,600)));
% for ii = 624:633
%     if abs(a(ii)) > 0.6
%         a(ii) = a(624);
%     end
% end

h = -flipud(dp * L .* (dp - 2*pi*D*f).^-1);
surf([1:length(h(:,1000))]/10.8,[1:length(h(:,1000))]/10.8,h,'edgecolor','none')

a = (h(:,600));
for ii = 624:633
    if abs(a(ii)) > 0.6
        a(ii) = a(624);
    end
end

figure; plot(a);


