classdef tucil1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        HistogramTab                 matlab.ui.container.Tab
        ShowHistogramButton          matlab.ui.control.Button
        UploadButton                 matlab.ui.control.Button
        Histb                        matlab.ui.control.UIAxes
        Histg                        matlab.ui.control.UIAxes
        Histr                        matlab.ui.control.UIAxes
        imgdisplay                   matlab.ui.control.UIAxes
        EnhancingTab                 matlab.ui.container.Tab
        PowerFormulaScrpowerLabel    matlab.ui.control.Label
        LogFormulaSclog1rLabel       matlab.ui.control.Label
        pvalue                       matlab.ui.control.NumericEditField
        constantvalueLabel_2         matlab.ui.control.Label
        cvalue                       matlab.ui.control.NumericEditField
        constantvalueLabel           matlab.ui.control.Label
        BrighteningFormulaSarbLabel  matlab.ui.control.Label
        bvalue                       matlab.ui.control.NumericEditField
        bvalueEditFieldLabel         matlab.ui.control.Label
        avalue                       matlab.ui.control.NumericEditField
        avalueEditFieldLabel         matlab.ui.control.Label
        EnhancingOptionsLabel        matlab.ui.control.Label
        ContrastStretchingButton     matlab.ui.control.Button
        PowerButton                  matlab.ui.control.Button
        LogarithmButton              matlab.ui.control.Button
        BrighteningButton            matlab.ui.control.Button
        UploadButton_2               matlab.ui.control.Button
        Histb_2                      matlab.ui.control.UIAxes
        Histg_2                      matlab.ui.control.UIAxes
        Histr_2                      matlab.ui.control.UIAxes
        imgdisplay3                  matlab.ui.control.UIAxes
        imgdisplay2                  matlab.ui.control.UIAxes
        HistogramEqualizationTab     matlab.ui.container.Tab
        EqualizeButton               matlab.ui.control.Button
        UploadButton_3               matlab.ui.control.Button
        Histb_3                      matlab.ui.control.UIAxes
        Histg_3                      matlab.ui.control.UIAxes
        Histr_3                      matlab.ui.control.UIAxes
        imgdisplay5                  matlab.ui.control.UIAxes
        imgdisplay4                  matlab.ui.control.UIAxes
        HistogramSpecificationTab    matlab.ui.container.Tab
        ModifyButton                 matlab.ui.control.Button
        UploadGambarAcuButton        matlab.ui.control.Button
        UploadGambar1Button          matlab.ui.control.Button
        Histb_4                      matlab.ui.control.UIAxes
        Histg_4                      matlab.ui.control.UIAxes
        Histr_4                      matlab.ui.control.UIAxes
        imgdisplay8                  matlab.ui.control.UIAxes
        imgdisplay7                  matlab.ui.control.UIAxes
        imgdisplay6                  matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        img; % Image File
        imgspec; % Image Specification File
        figcounter = 0;
    end
    
    methods (Access = private)
        
        function [xax,imghist] = proccHistogram(app,img,rows,cols,rgb)
            if isa(img,"double") % ada hasil image enhancing yang isi imgnya range [0..1] sehingga harus diubah dahulu
                img = img*256;
            end
            imghist = zeros(1,256); % inisialisasi histogram
            xax = 1:256; % x axis dari histogram
            if (rgb>1) % jika merupakan gambar berwarna, histogram ada 3 layer
                imghist(:,:,2) = 0;
                imghist(:,:,3) = 0;
            end
            for i = 1:rgb  % looping dilakukan per layer     
                for c = 1:cols
                    for r = 1:rows
                        pixval = img(r,c,i); % pixel value
                        if pixval > 256
                            pixval = 256;
                        elseif pixval < 1
                            pixval = 1;
                        end
                        % tiap index(yang menggambarkan nilai pixel) bertambah jumlah(elemen)nya
                        imghist(:,int64(pixval),i) = imghist(:,int64(pixval),i) + 1; 
                    end
                end
            end   
        end

         function showHistogram(app,axis,freq,rgb)
            for i=1:rgb
                figure(app.figcounter + i);
                bar(axis, freq(:,:,i));
                xlabel('Grayscale');
                ylabel('Frequency');
                grid on;
            end
            app.figcounter = app.figcounter + rgb;
        end

        function newimg = enhImage(app,img,rows,cols,rgb,type)
            if type == 1 % image brightening
                a = app.avalue.Value; % nilai a dari GUI
                b = app.bvalue.Value; % nilai b dari GUI
                newimg = img; % placeholder citra baru, speknya sama dengan citra lama
                for i = 1:rgb % rumus brightening diaplikasikan pada tiap-tiap pixel
                    for c = 1:cols
                        for r = 1:rows
                            newimg(r,c,i) = img(r,c,i)*a+b; % pengaplikasian rumus a*r+b
                            if newimg(r,c,i) > 255
                                newimg(r,c,i) = 255;
                            elseif newimg(r,c,i) < 0
                                newimg(r,c,i) = 0;
                            end
                        end
                    end
                end
            elseif type == 2 % logarithmic transformation
                constant = app.cvalue.Value; % nilai c atau konstanta dari GUI
                newimg = img; % placeholder citra baru, speknya sama dengan citra lama
                var = log1p(mat2gray(img)); % operasi logaritma, log(1+r)
                for i = 1:rgb % operasi logaritma dilakukan pada tiap-tiap pixel
                    for c = 1:cols
                        for r = 1:rows
                            newimg(r,c,i) = constant*var(r,c,i); % pengaplikasian rumus c*log(1+r)
                            if newimg(r,c,i) > 255 
                                newimg(r,c,i) = 255;
                            elseif newimg(r,c,i) < 0
                                newimg(r,c,i) = 0;
                            end
                        end
                    end
                end
            elseif type == 3 % power transformation
                constant = app.cvalue.Value; % nilai c atau konstanta dari GUI
                pow = app.pvalue.Value; % nilai power atau pangkat dari GUI (power atau gamma)
                var = im2double(img);
                newimg = constant * (var.^pow); % pengaplikasian rumus c*r^p
            elseif type == 4 % contrast stretching
                min = 257; % nilai grayscale terkecil 
                max = 0; % nilai grayscale terbesar 
                for i = 1:rgb
                    for c = 1:cols
                        for r = 1:rows
                            if min > img(r,c,i)
                                min = img(r,c,i);
                            elseif max < img(r,c,i)
                                max = img(r,c,i);
                            end
                        end
                    end
                    newimg(:,:,i) = (img(:,:,i) - min)*(256/(max - min)); % pengaplikasian rumus jarak antar titik (dari PPT)
                end
            end
        end

        function newimg = equalizeHistogram(app, img, imghist, rows, cols, rgb)
            % secara umum modifikasi yang ada di PPT dengan variabel dan informasi yang dimiliki
            newxax = 1:256; % placeholder nilai derajat keabuan (x axis pada histogram) yang baru
            if (rgb>1)
                newxax(:,:,2) = 1:256;
                newxax(:,:,3) = 1:256;
            end
            for i = 1:rgb
                inc = 0;
                for j=1:256
                    inc = inc + imghist(1,j,i);
                    newxax(1,j,i) = (inc/(rows*cols))*256;
                    % nilai derajat keabuan yang baru diperbarui dengan nilai perbandingan relatif
                    % antara nilai derajat keabuan sekarang dengan jumlah seluruh pixel
                end
            end
            newxax = int64(newxax); % nilai derajat keabuan (x axis pada histogram) yang baru harus bulat
            newimg = img;
            for i = 1:rgb
                for c = 1:cols
                    for r = 1:rows
                        if(img(r,c,i) == 0)
                            continue
                        end
                        newimg(r,c,i) = newxax(1,img(r,c,i),i);
                        % nilai derajat keabuan per pixelnya diganti dengan yang baru
                        % ingat placeholder nilai derajat keabuan yang baru juga memiliki indeks sebanyak 256
                        % maka dari itu, dapat dibayangkan bahwa [indeks] merupakan derajat keabuan lama
                        % dan [elemen dari indeks] merupakan derajat keabuan yang baru
                    end
                end
            end
        end

        function newimg = specificationHistogram(app, img, imgspec, rows, cols, rgb)
            % secara umum modifikasi yang ada di PPT dengan variabel dan informasi yang dimiliki
            [xax, imghist] = app.proccHistogram(img,rows,cols,rgb); % bentuk histogram citra awal
            newxax = 1:256; % placeholder nilai derajat keabuan (x axis pada histogram) yang baru untuk citra awal
            if rgb>1
                newxax(:,:,2) = 1:256;
                newxax(:,:,3) = 1:256;
            end
            % lakukan perataan histogram
            for layer=1:rgb
                inc = 0;
                for i=1:256
                    inc = inc + imghist(1,i,layer);
                    newxax(1,i,layer) = (inc/(rows*cols))*256;
                end
                newxax = int64(newxax);
                newimg = img;
            end
            newxax = int64(newxax);
        
            [xax, imghist1] = app.proccHistogram(imgspec,rows,cols,rgb); % bentuk histogram citra acu
            newxax1 = 1:256; % placeholder nilai derajat keabuan (x axis pada histogram) yang baru untuk citra acu
            if rgb>1
                newxax1(:,:,2) = 1:256;
                newxax1(:,:,3) = 1:256;
            end
            % lakukan perataan histogram
            for layer=1:rgb
                inc = 0;
                for i=1:256
                    inc = inc + imghist1(1,i,layer);
                    newxax1(1,i,layer) = (inc/(rows*cols))*256;
                end
                newxax1 = int64(newxax1);
                newimg = img;
            end
            
            invxax = 1:256; % placeholder pemetaan nilai derajat keabuan (x axis pada histogram) dari citra awal ke citra acu
            if rgb>1
                invxax(:,:,2) = 1:256;
                invxax(:,:,3) = 1:256;
            end
            
            % pencocokan histogram menggunakan transformasi balikan
            % xax adalah x axis [indeks derajat keabuan 1-256]
            for layer=1:rgb
                for i=1:256
                    for j=1:256
                        % jika nilai derajat keabuannya antara elemen dari index xax citra awal dan citra acu sama
                        % maka nilai derajat keabuan untuk xax citra awal adalah indeks dari elemen citra acu tersebut
                        if newxax(1,i,layer) == newxax1(1,j,layer)
                            invxax(1,i,layer) = j;
                        end
                    end
                end
            end
            
            for layer=1:rgb
                for c = 1:cols
                    for r = 1:rows
                        if img(r,c,layer) == 0
                            continue
                        end
                        newimg(r,c,layer) = invxax(1,img(r,c,layer),layer);
                        % nilai derajat keabuan per pixelnya diganti dengan yang baru
                        % ingat placeholder nilai derajat keabuan yang baru juga memiliki indeks sebanyak 256
                        % maka dari itu, dapat dibayangkan bahwa [indeks] merupakan derajat keabuan lama
                        % dan [elemen dari indeks] merupakan derajat keabuan yang baru
                    end
                end
            end
        end

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadButton
        function UploadButtonPushed(app, event)
           [filename,filepath] = uigetfile({'*.*;*.jpg;*.png;*.bmp;*.oct'}, 'Select File to Open');
           fullname = [filepath, filename];
           ImageFile = imread(fullname);
           app.img = ImageFile;
           I = imshow(ImageFile, 'Parent', app.imgdisplay, ...
               'XData', [1 app.imgdisplay.Position(3)], ...
               'YData', [1 app.imgdisplay.Position(4)]);
           app.imgdisplay.XLim = [0 I.XData(2)];
           app.imgdisplay.YLim = [0 I.YData(2)];
        end

        % Button pushed function: ShowHistogramButton
        function ShowHistogramButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            [xax,imghist] = app.proccHistogram(app.img,rows,cols,rgb);
            bar(app.Histr, xax, imghist(:,:,1));
            app.Histr.Visible = 'on';
            if rgb>1
                bar(app.Histg, xax, imghist(:,:,2));
                bar(app.Histb, xax, imghist(:,:,3));
                app.Histg.Visible = 'on';
                app.Histb.Visible = 'on';
            end
            grid on;
        end

        % Button pushed function: UploadButton_2
        function UploadButton_2Pushed(app, event)
           [filename,filepath] = uigetfile({'*.*;*.jpg;*.png;*.bmp;*.oct'}, 'Select File to Open');
           fullname = [filepath, filename];
           ImageFile = imread(fullname);
           app.img = ImageFile;
           I = imshow(ImageFile, 'Parent', app.imgdisplay2, ...
               'XData', [1 app.imgdisplay2.Position(3)], ...
               'YData', [1 app.imgdisplay2.Position(4)]);
           app.imgdisplay2.XLim = [0 I.XData(2)];
           app.imgdisplay2.YLim = [0 I.YData(2)];
           [rows, cols, rgb] = size(app.img);
           [xax, imghist] = app.proccHistogram(app.img,rows,cols,rgb);
           app.showHistogram(xax,imghist,rgb);
        end

        % Button pushed function: BrighteningButton
        function BrighteningButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            newimg = app.enhImage(app.img,rows,cols,rgb,1);
            I = imshow(newimg, 'Parent', app.imgdisplay3, ...
               'XData', [1 app.imgdisplay3.Position(3)], ...
               'YData', [1 app.imgdisplay3.Position(4)]);
            app.imgdisplay3.XLim = [0 I.XData(2)];
            app.imgdisplay3.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_2, xax, imghist(:,:,1));
            app.Histr_2.Visible = 'on';
            if rgb>1
                bar(app.Histg_2, xax, imghist(:,:,2));
                bar(app.Histb_2, xax, imghist(:,:,3));
                app.Histg_2.Visible = 'on';
                app.Histb_2.Visible = 'on';
            end
        end

        % Button pushed function: LogarithmButton
        function LogarithmButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            newimg = app.enhImage(app.img,rows,cols,rgb,2);
            I = imshow(newimg, 'Parent', app.imgdisplay3, ...
               'XData', [1 app.imgdisplay3.Position(3)], ...
               'YData', [1 app.imgdisplay3.Position(4)]);
            app.imgdisplay3.XLim = [0 I.XData(2)];
            app.imgdisplay3.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_2, xax, imghist(:,:,1));
            app.Histr_2.Visible = 'on';
            if rgb>1
                bar(app.Histg_2, xax, imghist(:,:,2));
                bar(app.Histb_2, xax, imghist(:,:,3));
                app.Histg_2.Visible = 'on';
                app.Histb_2.Visible = 'on';
            end
        end

        % Button pushed function: PowerButton
        function PowerButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            newimg = app.enhImage(app.img,rows,cols,rgb,3);
            I = imshow(newimg, 'Parent', app.imgdisplay3, ...
               'XData', [1 app.imgdisplay3.Position(3)], ...
               'YData', [1 app.imgdisplay3.Position(4)]);
            app.imgdisplay3.XLim = [0 I.XData(2)];
            app.imgdisplay3.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_2, xax, imghist(:,:,1));
            app.Histr_2.Visible = 'on';
            if rgb>1
                bar(app.Histg_2, xax, imghist(:,:,2));
                bar(app.Histb_2, xax, imghist(:,:,3));
                app.Histg_2.Visible = 'on';
                app.Histb_2.Visible = 'on';
            end
        end

        % Button pushed function: ContrastStretchingButton
        function ContrastStretchingButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            newimg = app.enhImage(app.img,rows,cols,rgb,4);
            I = imshow(newimg, 'Parent', app.imgdisplay3, ...
               'XData', [1 app.imgdisplay3.Position(3)], ...
               'YData', [1 app.imgdisplay3.Position(4)]);
            app.imgdisplay3.XLim = [0 I.XData(2)];
            app.imgdisplay3.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_2, xax, imghist(:,:,1));
            app.Histr_2.Visible = 'on';
            if rgb>1
                bar(app.Histg_2, xax, imghist(:,:,2));
                bar(app.Histb_2, xax, imghist(:,:,3));
                app.Histg_2.Visible = 'on';
                app.Histb_2.Visible = 'on';
            end
        end

        % Button pushed function: UploadButton_3
        function UploadButton_3Pushed(app, event)
           [filename,filepath] = uigetfile({'*.*;*.jpg;*.png;*.bmp;*.oct'}, 'Select File to Open');
           fullname = [filepath, filename];
           ImageFile = imread(fullname);
           app.img = ImageFile;
           I = imshow(ImageFile, 'Parent', app.imgdisplay4, ...
               'XData', [1 app.imgdisplay4.Position(3)], ...
               'YData', [1 app.imgdisplay4.Position(4)]);
           app.imgdisplay4.XLim = [0 I.XData(2)];
           app.imgdisplay4.YLim = [0 I.YData(2)];
           [rows, cols, rgb] = size(app.img);
           [xax, imghist] = app.proccHistogram(app.img,rows,cols,rgb);
           app.showHistogram(xax,imghist,rgb);
        end

        % Button pushed function: EqualizeButton
        function EqualizeButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            [xax, imghist] = app.proccHistogram(app.img,rows,cols,rgb);
            newimg = app.equalizeHistogram(app.img, imghist, rows, cols, rgb);
            I = imshow(newimg, 'Parent', app.imgdisplay5, ...
               'XData', [1 app.imgdisplay5.Position(3)], ...
               'YData', [1 app.imgdisplay5.Position(4)]);
            app.imgdisplay5.XLim = [0 I.XData(2)];
            app.imgdisplay5.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_3, xax, imghist(:,:,1));
            app.Histr_3.Visible = 'on';
            if rgb>1
                bar(app.Histg_3, xax, imghist(:,:,2));
                bar(app.Histb_3, xax, imghist(:,:,3));
                app.Histg_3.Visible = 'on';
                app.Histb_3.Visible = 'on';
            end
        end

        % Button pushed function: UploadGambar1Button
        function UploadGambar1ButtonPushed(app, event)
           [filename,filepath] = uigetfile({'*.*;*.jpg;*.png;*.bmp;*.oct'}, 'Select File to Open');
           fullname = [filepath, filename];
           ImageFile = imread(fullname);
           app.img = ImageFile;
           I = imshow(ImageFile, 'Parent', app.imgdisplay6, ...
               'XData', [1 app.imgdisplay6.Position(3)], ...
               'YData', [1 app.imgdisplay6.Position(4)]);
           app.imgdisplay6.XLim = [0 I.XData(2)];
           app.imgdisplay6.YLim = [0 I.YData(2)];
           [rows, cols, rgb] = size(app.img);
           [xax, imghist] = app.proccHistogram(app.img,rows,cols,rgb);
           app.showHistogram(xax,imghist,rgb);
        end

        % Button pushed function: UploadGambarAcuButton
        function UploadGambarAcuButtonPushed(app, event)
           [filename,filepath] = uigetfile({'*.*;*.jpg;*.png;*.bmp;*.oct'}, 'Select File to Open');
           fullname = [filepath, filename];
           ImageFile = imread(fullname);
           app.imgspec = ImageFile;
           I = imshow(ImageFile, 'Parent', app.imgdisplay7, ...
               'XData', [1 app.imgdisplay7.Position(3)], ...
               'YData', [1 app.imgdisplay7.Position(4)]);
           app.imgdisplay7.XLim = [0 I.XData(2)];
           app.imgdisplay7.YLim = [0 I.YData(2)];
           [rowspec, colspec, rgbspec] = size(app.imgspec);
           [xax, imghist] = app.proccHistogram(app.imgspec,rowspec,colspec,rgbspec);
           app.showHistogram(xax,imghist,rgbspec);
        end

        % Button pushed function: ModifyButton
        function ModifyButtonPushed(app, event)
            [rows, cols, rgb] = size(app.img);
            newimg = app.specificationHistogram(app.img, app.imgspec, rows, cols, rgb);
            I = imshow(newimg, 'Parent', app.imgdisplay8, ...
               'XData', [1 app.imgdisplay8.Position(3)], ...
               'YData', [1 app.imgdisplay8.Position(4)]);
           app.imgdisplay8.XLim = [0 I.XData(2)];
           app.imgdisplay8.YLim = [0 I.YData(2)];
            [xax, imghist] = app.proccHistogram(newimg,rows,cols,rgb);
            bar(app.Histr_4, xax, imghist(:,:,1));
            app.Histr_4.Visible = 'on';
            if rgb>1
                bar(app.Histg_4, xax, imghist(:,:,2));
                bar(app.Histb_4, xax, imghist(:,:,3));
                app.Histg_4.Visible = 'on';
                app.Histb_4.Visible = 'on';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1281 811];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [0 0 1282 812];

            % Create HistogramTab
            app.HistogramTab = uitab(app.TabGroup);
            app.HistogramTab.Title = 'Histogram';

            % Create imgdisplay
            app.imgdisplay = uiaxes(app.HistogramTab);
            app.imgdisplay.XTickLabel = '';
            app.imgdisplay.YTickLabel = '';
            colormap(app.imgdisplay, 'gray')
            app.imgdisplay.Visible = 'off';
            app.imgdisplay.Position = [49 500 296 255];

            % Create Histr
            app.Histr = uiaxes(app.HistogramTab);
            title(app.Histr, 'Image Histogram')
            xlabel(app.Histr, 'Grayscale')
            ylabel(app.Histr, 'Frequency')
            app.Histr.Visible = 'off';
            app.Histr.Position = [49 75 381 289];

            % Create Histg
            app.Histg = uiaxes(app.HistogramTab);
            title(app.Histg, 'Image Histogram')
            xlabel(app.Histg, 'Grayscale')
            ylabel(app.Histg, 'Frequency')
            app.Histg.Visible = 'off';
            app.Histg.Position = [458 75 390 289];

            % Create Histb
            app.Histb = uiaxes(app.HistogramTab);
            title(app.Histb, 'Image Histogram')
            xlabel(app.Histb, 'Grayscale')
            ylabel(app.Histb, 'Frequency')
            app.Histb.Visible = 'off';
            app.Histb.Position = [865 77 383 287];

            % Create UploadButton
            app.UploadButton = uibutton(app.HistogramTab, 'push');
            app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
            app.UploadButton.Position = [138 451 118 24];
            app.UploadButton.Text = 'Upload';

            % Create ShowHistogramButton
            app.ShowHistogramButton = uibutton(app.HistogramTab, 'push');
            app.ShowHistogramButton.ButtonPushedFcn = createCallbackFcn(app, @ShowHistogramButtonPushed, true);
            app.ShowHistogramButton.FontSize = 24;
            app.ShowHistogramButton.Position = [882 599 196 58];
            app.ShowHistogramButton.Text = 'Show Histogram';

            % Create EnhancingTab
            app.EnhancingTab = uitab(app.TabGroup);
            app.EnhancingTab.Title = 'Enhancing';

            % Create imgdisplay2
            app.imgdisplay2 = uiaxes(app.EnhancingTab);
            app.imgdisplay2.XTickLabel = '';
            app.imgdisplay2.YTickLabel = '';
            colormap(app.imgdisplay2, 'gray')
            app.imgdisplay2.Visible = 'off';
            app.imgdisplay2.Position = [49 500 296 255];

            % Create imgdisplay3
            app.imgdisplay3 = uiaxes(app.EnhancingTab);
            app.imgdisplay3.XTickLabel = '';
            app.imgdisplay3.YTickLabel = '';
            colormap(app.imgdisplay3, 'gray')
            app.imgdisplay3.Visible = 'off';
            app.imgdisplay3.Position = [909 500 296 255];

            % Create Histr_2
            app.Histr_2 = uiaxes(app.EnhancingTab);
            title(app.Histr_2, 'Image Histogram')
            xlabel(app.Histr_2, 'Grayscale')
            ylabel(app.Histr_2, 'Frequency')
            app.Histr_2.Visible = 'off';
            app.Histr_2.Position = [49 75 381 289];

            % Create Histg_2
            app.Histg_2 = uiaxes(app.EnhancingTab);
            title(app.Histg_2, 'Image Histogram')
            xlabel(app.Histg_2, 'Grayscale')
            ylabel(app.Histg_2, 'Frequency')
            app.Histg_2.Visible = 'off';
            app.Histg_2.Position = [458 75 390 289];

            % Create Histb_2
            app.Histb_2 = uiaxes(app.EnhancingTab);
            title(app.Histb_2, 'Image Histogram')
            xlabel(app.Histb_2, 'Grayscale')
            ylabel(app.Histb_2, 'Frequency')
            app.Histb_2.Visible = 'off';
            app.Histb_2.Position = [865 77 383 287];

            % Create UploadButton_2
            app.UploadButton_2 = uibutton(app.EnhancingTab, 'push');
            app.UploadButton_2.ButtonPushedFcn = createCallbackFcn(app, @UploadButton_2Pushed, true);
            app.UploadButton_2.Position = [138 451 118 24];
            app.UploadButton_2.Text = 'Upload';

            % Create BrighteningButton
            app.BrighteningButton = uibutton(app.EnhancingTab, 'push');
            app.BrighteningButton.ButtonPushedFcn = createCallbackFcn(app, @BrighteningButtonPushed, true);
            app.BrighteningButton.Position = [496 656 76 24];
            app.BrighteningButton.Text = 'Brightening';

            % Create LogarithmButton
            app.LogarithmButton = uibutton(app.EnhancingTab, 'push');
            app.LogarithmButton.ButtonPushedFcn = createCallbackFcn(app, @LogarithmButtonPushed, true);
            app.LogarithmButton.Position = [498 585 73 24];
            app.LogarithmButton.Text = 'Logarithm';

            % Create PowerButton
            app.PowerButton = uibutton(app.EnhancingTab, 'push');
            app.PowerButton.ButtonPushedFcn = createCallbackFcn(app, @PowerButtonPushed, true);
            app.PowerButton.Position = [498 521 73 24];
            app.PowerButton.Text = 'Power';

            % Create ContrastStretchingButton
            app.ContrastStretchingButton = uibutton(app.EnhancingTab, 'push');
            app.ContrastStretchingButton.ButtonPushedFcn = createCallbackFcn(app, @ContrastStretchingButtonPushed, true);
            app.ContrastStretchingButton.Position = [498 451 118 24];
            app.ContrastStretchingButton.Text = 'Contrast Stretching';

            % Create EnhancingOptionsLabel
            app.EnhancingOptionsLabel = uilabel(app.EnhancingTab);
            app.EnhancingOptionsLabel.FontSize = 24;
            app.EnhancingOptionsLabel.Position = [540 697 209 31];
            app.EnhancingOptionsLabel.Text = 'Enhancing Options';

            % Create avalueEditFieldLabel
            app.avalueEditFieldLabel = uilabel(app.EnhancingTab);
            app.avalueEditFieldLabel.HorizontalAlignment = 'right';
            app.avalueEditFieldLabel.Position = [601 657 48 22];
            app.avalueEditFieldLabel.Text = 'a value';

            % Create avalue
            app.avalue = uieditfield(app.EnhancingTab, 'numeric');
            app.avalue.Position = [655 656 26 23];

            % Create bvalueEditFieldLabel
            app.bvalueEditFieldLabel = uilabel(app.EnhancingTab);
            app.bvalueEditFieldLabel.HorizontalAlignment = 'right';
            app.bvalueEditFieldLabel.Position = [699 657 48 22];
            app.bvalueEditFieldLabel.Text = 'b value';

            % Create bvalue
            app.bvalue = uieditfield(app.EnhancingTab, 'numeric');
            app.bvalue.Position = [753 656 26 23];

            % Create BrighteningFormulaSarbLabel
            app.BrighteningFormulaSarbLabel = uilabel(app.EnhancingTab);
            app.BrighteningFormulaSarbLabel.Position = [498 631 174 22];
            app.BrighteningFormulaSarbLabel.Text = 'Brightening Formula S = a*r + b';

            % Create constantvalueLabel
            app.constantvalueLabel = uilabel(app.EnhancingTab);
            app.constantvalueLabel.HorizontalAlignment = 'right';
            app.constantvalueLabel.Position = [656 554 44 22];
            app.constantvalueLabel.Text = 'c value';

            % Create cvalue
            app.cvalue = uieditfield(app.EnhancingTab, 'numeric');
            app.cvalue.Position = [706 553 26 23];

            % Create constantvalueLabel_2
            app.constantvalueLabel_2 = uilabel(app.EnhancingTab);
            app.constantvalueLabel_2.HorizontalAlignment = 'right';
            app.constantvalueLabel_2.Position = [672 523 70 22];
            app.constantvalueLabel_2.Text = 'power value';

            % Create pvalue
            app.pvalue = uieditfield(app.EnhancingTab, 'numeric');
            app.pvalue.Position = [748 522 26 23];

            % Create LogFormulaSclog1rLabel
            app.LogFormulaSclog1rLabel = uilabel(app.EnhancingTab);
            app.LogFormulaSclog1rLabel.Position = [498 554 150 22];
            app.LogFormulaSclog1rLabel.Text = 'Log Formula S = c*log(1+r)';

            % Create PowerFormulaScrpowerLabel
            app.PowerFormulaScrpowerLabel = uilabel(app.EnhancingTab);
            app.PowerFormulaScrpowerLabel.Position = [496 487 173 22];
            app.PowerFormulaScrpowerLabel.Text = 'Power Formula S = c*(r^power)';

            % Create HistogramEqualizationTab
            app.HistogramEqualizationTab = uitab(app.TabGroup);
            app.HistogramEqualizationTab.Title = 'Histogram Equalization';

            % Create imgdisplay4
            app.imgdisplay4 = uiaxes(app.HistogramEqualizationTab);
            app.imgdisplay4.XTickLabel = '';
            app.imgdisplay4.YTickLabel = '';
            colormap(app.imgdisplay4, 'gray')
            app.imgdisplay4.Visible = 'off';
            app.imgdisplay4.Position = [49 500 296 255];

            % Create imgdisplay5
            app.imgdisplay5 = uiaxes(app.HistogramEqualizationTab);
            app.imgdisplay5.XTickLabel = '';
            app.imgdisplay5.YTickLabel = '';
            colormap(app.imgdisplay5, 'gray')
            app.imgdisplay5.Visible = 'off';
            app.imgdisplay5.Position = [909 500 296 255];

            % Create Histr_3
            app.Histr_3 = uiaxes(app.HistogramEqualizationTab);
            title(app.Histr_3, 'Image Histogram')
            xlabel(app.Histr_3, 'Grayscale')
            ylabel(app.Histr_3, 'Frequency')
            app.Histr_3.Visible = 'off';
            app.Histr_3.Position = [49 75 381 289];

            % Create Histg_3
            app.Histg_3 = uiaxes(app.HistogramEqualizationTab);
            title(app.Histg_3, 'Image Histogram')
            xlabel(app.Histg_3, 'Grayscale')
            ylabel(app.Histg_3, 'Frequency')
            app.Histg_3.Visible = 'off';
            app.Histg_3.Position = [458 75 390 289];

            % Create Histb_3
            app.Histb_3 = uiaxes(app.HistogramEqualizationTab);
            title(app.Histb_3, 'Image Histogram')
            xlabel(app.Histb_3, 'Grayscale')
            ylabel(app.Histb_3, 'Frequency')
            app.Histb_3.Visible = 'off';
            app.Histb_3.Position = [865 77 383 287];

            % Create UploadButton_3
            app.UploadButton_3 = uibutton(app.HistogramEqualizationTab, 'push');
            app.UploadButton_3.ButtonPushedFcn = createCallbackFcn(app, @UploadButton_3Pushed, true);
            app.UploadButton_3.Position = [138 451 118 24];
            app.UploadButton_3.Text = 'Upload';

            % Create EqualizeButton
            app.EqualizeButton = uibutton(app.HistogramEqualizationTab, 'push');
            app.EqualizeButton.ButtonPushedFcn = createCallbackFcn(app, @EqualizeButtonPushed, true);
            app.EqualizeButton.FontSize = 24;
            app.EqualizeButton.Position = [560 598 164 53];
            app.EqualizeButton.Text = 'Equalize';

            % Create HistogramSpecificationTab
            app.HistogramSpecificationTab = uitab(app.TabGroup);
            app.HistogramSpecificationTab.Title = 'Histogram Specification';

            % Create imgdisplay6
            app.imgdisplay6 = uiaxes(app.HistogramSpecificationTab);
            app.imgdisplay6.XTickLabel = '';
            app.imgdisplay6.YTickLabel = '';
            colormap(app.imgdisplay6, 'gray')
            app.imgdisplay6.Visible = 'off';
            app.imgdisplay6.Position = [49 555 207 200];

            % Create imgdisplay7
            app.imgdisplay7 = uiaxes(app.HistogramSpecificationTab);
            app.imgdisplay7.XTickLabel = '';
            app.imgdisplay7.YTickLabel = '';
            colormap(app.imgdisplay7, 'gray')
            app.imgdisplay7.Visible = 'off';
            app.imgdisplay7.Position = [276 554 207 200];

            % Create imgdisplay8
            app.imgdisplay8 = uiaxes(app.HistogramSpecificationTab);
            app.imgdisplay8.XTickLabel = '';
            app.imgdisplay8.YTickLabel = '';
            colormap(app.imgdisplay8, 'gray')
            app.imgdisplay8.Visible = 'off';
            app.imgdisplay8.Position = [909 500 296 255];

            % Create Histr_4
            app.Histr_4 = uiaxes(app.HistogramSpecificationTab);
            title(app.Histr_4, 'Image Histogram')
            xlabel(app.Histr_4, 'Grayscale')
            ylabel(app.Histr_4, 'Frequency')
            app.Histr_4.Visible = 'off';
            app.Histr_4.Position = [49 75 381 289];

            % Create Histg_4
            app.Histg_4 = uiaxes(app.HistogramSpecificationTab);
            title(app.Histg_4, 'Image Histogram')
            xlabel(app.Histg_4, 'Grayscale')
            ylabel(app.Histg_4, 'Frequency')
            app.Histg_4.Visible = 'off';
            app.Histg_4.Position = [458 75 390 289];

            % Create Histb_4
            app.Histb_4 = uiaxes(app.HistogramSpecificationTab);
            title(app.Histb_4, 'Image Histogram')
            xlabel(app.Histb_4, 'Grayscale')
            ylabel(app.Histb_4, 'Frequency')
            app.Histb_4.Visible = 'off';
            app.Histb_4.Position = [865 77 383 287];

            % Create UploadGambar1Button
            app.UploadGambar1Button = uibutton(app.HistogramSpecificationTab, 'push');
            app.UploadGambar1Button.ButtonPushedFcn = createCallbackFcn(app, @UploadGambar1ButtonPushed, true);
            app.UploadGambar1Button.Position = [92 521 118 24];
            app.UploadGambar1Button.Text = 'Upload Gambar 1';

            % Create UploadGambarAcuButton
            app.UploadGambarAcuButton = uibutton(app.HistogramSpecificationTab, 'push');
            app.UploadGambarAcuButton.ButtonPushedFcn = createCallbackFcn(app, @UploadGambarAcuButtonPushed, true);
            app.UploadGambarAcuButton.Position = [316 520 124 24];
            app.UploadGambarAcuButton.Text = 'Upload Gambar Acu';

            % Create ModifyButton
            app.ModifyButton = uibutton(app.HistogramSpecificationTab, 'push');
            app.ModifyButton.ButtonPushedFcn = createCallbackFcn(app, @ModifyButtonPushed, true);
            app.ModifyButton.FontSize = 24;
            app.ModifyButton.Position = [614 636 165 38];
            app.ModifyButton.Text = 'Modify';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = tucil1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end