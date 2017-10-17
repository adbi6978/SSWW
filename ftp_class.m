%ftp as library fun
classdef ftp_class
    properties 
        dataim;
        refim;
        widthHeight;
        L = 1465;
        D = 380;
        f = 111/(45*10*2*pi);
    end
    methods
        function obj = ftp_class(arg1,arg2)
            obj.refim = im2double(rgb2gray(imread(arg1)));
            obj.dataim = im2double(rgb2gray(imread(arg2)));
        end

        function transform(obj)
            rim = imcrop(obj.refim,[2000 1500 obj.widthHeight obj.widthHeight]);
            dim = imcrop(obj.dataim,[2000 1500 obj.widthHeight obj.widthHeight]);

            rim = adapthisteq(rim,'clipLimit',0.02,'Distribution','rayleigh');
            dim = adapthisteq(dim,'clipLimit',0.02,'Distribution','rayleigh');

            [refimFilt,dataimFilt] = filterIMG(rim,dim);

            dp = ones(obj.widthHeight+1,obj.widthHeight+1);
            for ii = 1:size(rim,2)
                dp(ii,:) = (1/2)*(-angle(ifft(fft(hilbert(refimFilt(ii,:)))))...
                    + angle(ifft(fft(hilbert(dataimFilt(ii,:))))));
            end
            tol = 1;
            for jj = 1:size(rim,2)
                for ii = 1:length(rim)-1
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
            
            xPlot = linspace(0,1500/111,1501);
            figure;
            %disp('test')
            %pause
            surf(xPlot,xPlot,h,'edgecolor','none');
        end 
    end
end