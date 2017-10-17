%Fourier Transform Profilometry
close all;
clear; 
%==========Experimental Parameters===========
L = 1465+146;
D = 380;
f = 111/(45*10);

%==========Read in Images===========
refim = im2double(rgb2gray(imread('IMG_0002b.CR2')));
dataim = im2double(rgb2gray(imread('IMG_0001b.CR2')));

refim = imcrop(refim,[1500 1500 1500 1500]);
dataim = imcrop(dataim,[1500 1500 1500 1500]);

refim = adapthisteq(refim,'clipLimit',0.02,'Distribution','rayleigh');
dataim = adapthisteq(dataim,'clipLimit',0.02,'Distribution','rayleigh');

tic
[refimFilt,dataimFilt] = filterIMG(refim,dataim);

dp = ones(size(refim));
for ii = 1:size(refim,2)
    dp(ii,:) = (1/2)*(-angle(ifft(fft(hilbert(refimFilt(ii,:)))))...
        + angle(ifft(fft(hilbert(dataimFilt(ii,:))))));
end

% dp = dp';

% tol = 0.9*1;
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
tol = 1;
for jj = 1:size(refim,2)
    for ii = 1:length(refim)-1
        if abs(dp(ii + 1,jj) - dp(ii,jj)) > tol
            dp(ii+1:end,jj) = dp(ii+1:end,jj)...
                -  (dp(ii + 1,jj) - dp(ii,jj));
        end
    end
end
disp('median filtering....')
dp = medfilt2(dp,[20,20]);
toc
dp = -dp;
% figure;
% surf(dp, 'edgecolor', 'none');

h = -flipud(dp * L .* (dp - 2*pi*D*f).^-1);
h = 2*h;
% 
% [vdim, hdim] = size(h);
xPlot = linspace(0,1500/111,1501);
figure;
surf(xPlot,xPlot,h,'edgecolor','none')
% 
% figure;
% surf(1:vdim, 1:hdim, h, 'edgecolor', 'none')
% figure;
% contour(1:vdim, 1:hdim, h)
% colorbar;