%Fourier Transform Profilometry
close all;
clear; 
%==========Experimental Parameters===========
L = 1435;
D = 380;
f = 2.8;

%==========Read in Images===========
refim = im2double(rgb2gray(imread('IMG_0001.CR2')));
dataim = im2double(rgb2gray(imread('IMG_0002.CR2')));

refim = imcrop(refim,[2000 1000 1500 1500]);
dataim = imcrop(dataim,[2000 1000 1500 1500]);

refim = adapthisteq(refim,'clipLimit',0.02,'Distribution','rayleigh');
dataim = adapthisteq(dataim,'clipLimit',0.02,'Distribution','rayleigh');

tic
[refimFilt,dataimFilt] = filterIMG(refim,dataim);

for ii = 1:size(refim,2)
    dp(ii,:) = (1/2)*(-angle(ifft(fft(hilbert(refimFilt(ii,:)))))...
        + angle(ifft(fft(hilbert(dataimFilt(ii,:))))));
end

tol = pi;
for ii = 1:size(refim,2)
    for jj = 2:size(refim,2)
        deltaDp = dp(ii,jj)-dp(ii,jj-1);
        if abs(deltaDp) >= 0.9*tol
            if deltaDp < 0
                dp(ii,jj) = dp(ii,jj) + tol;
            else
                dp(ii,jj) = dp(ii,jj) - tol;
            end
        end
    end
end

disp('median filtering....')
dp = medfilt2(dp,[20,20]);
toc
figure;
surf(dp, 'edgecolor', 'none');

% h = -flipud(dp * L .* (dp - 2*pi*D*f).^-1);
% 
% [vdim, hdim] = size(h);
% 
% figure;
% surf(1:vdim, 1:hdim, h, 'edgecolor', 'none')
% figure;
% contour(1:vdim, 1:hdim, h)
% colorbar;