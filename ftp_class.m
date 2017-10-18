%ftp as library fun
classdef ftp_class
    properties 
        dataim;
        refim;
        widthHeight;
        L = 1465;
        D = 380;
        f = 111/(45*10*2*pi); 
        xmin = 2000;
        ymin = 1500;
    end
    methods
        function obj = ftp_class(addr1,addr2)
            obj.refim = im2double(rgb2gray(imread(addr1)));
            obj.dataim = im2double(rgb2gray(imread(addr2)));
        end
        function [r1,r2] = crop(obj)
            rim = imcrop(obj.refim,[obj.xmin obj.ymin obj.widthHeight obj.widthHeight]);
            dim = imcrop(obj.dataim,[obj.xmin obj.ymin obj.widthHeight obj.widthHeight]);

            rim = adapthisteq(rim,'clipLimit',0.02,'Distribution','rayleigh');
            dim = adapthisteq(dim,'clipLimit',0.02,'Distribution','rayleigh');
            
            [r1,r2] = filterIMG(rim,dim);
        end

        function transform(obj)

            [refimFilt,dataimFilt] = obj.crop();
            dp = ones(obj.widthHeight+1,obj.widthHeight+1);
            for ii = 1:(obj.widthHeight+1)
                dp(ii,:) = (1/2)*(-angle(ifft(fft(hilbert(refimFilt(ii,:)))))...
                    + angle(ifft(fft(hilbert(dataimFilt(ii,:))))));
            end
            tol = 1;
            for jj = 1:(obj.widthHeight+1)
                for ii = 1:obj.widthHeight
                    if abs(dp(ii + 1,jj) - dp(ii,jj)) > tol
                        dp(ii+1:end,jj) = dp(ii+1:end,jj)...
                            -  (dp(ii + 1,jj) - dp(ii,jj));
                    end
                end
            end
            disp('median filtering....')
            dp = medfilt2(dp,[20,20]);
            
            dp = -dp;
            % figure;
            % surf(dp, 'edgecolor', 'none');

            
            h = -flipud(dp * obj.L .* (dp - 2*pi*obj.D*obj.f).^-1);
            %h = h;
            % 
            % [vdim, hdim] = size(h);
            
            xPlot = linspace(0,obj.widthHeight/111,obj.widthHeight+1); % The 111 is the same as from the numerator on f.
            figure;
            %disp('test')
            %pause
            surf(xPlot,xPlot,h,'edgecolor','none');
        end 
    end
end