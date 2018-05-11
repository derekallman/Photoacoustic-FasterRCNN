
function PA_Beamform (saveDir, saveName, datapath, chan, seq)
    Rx_F_num = 1;
    Offset = 50;
    fs = 40e6;
    c = 1400;
    AdcData_frame000 = chan.AdcData_frame000;
    AlignedSampleNum = chan.AlignedSampleNum;
    SampleNum = chan.SampleNum;
    System = seq.System;
    
    imgdepth=size(AdcData_frame000,2) ;
    Atmp2 = reshape(permute(AdcData_frame000, [1 3 2]),128, imgdepth); %was 3072 before imgdepth
    Atmp = Atmp2;
    for i = 1:size(Atmp2,2)
        Atmp(:,i) = Atmp2(:,i) - mean( Atmp2(:,i) );
    end
    A = Atmp;
    
    N_ele = double(System.Transducer.elementCnt);
    pitch = double(System.Transducer.elementPitchCm) * 1e-2;     % cm => m

    AlignedSample = double(AlignedSampleNum);
    DepSample = double(SampleNum);

    nNumCh = 128;
    N_ch = nNumCh;
    nHalfNumCh = nNumCh/2;
    sam_st_2nd = AlignedSample*nHalfNumCh;

    data_total = AlignedSample;
    data_total1 = DepSample;
    pixel_d = c/fs/2; %Depth per pixel

    %%
    scan_view_size = pitch*N_ele; % Lateral View Size

    N_sc = ((scan_view_size/pitch));  % Scanline number
    sc_d = scan_view_size/(N_sc); % Scanline distance
    st_sc_x = - scan_view_size/2+sc_d/2 ; % Start Scanline position

    st_sam = round(0.001/pixel_d);
    ed_sam = data_total1;
    %% DC cancle filter
    f = [0 0.1 0.1 1]; m = [0 0 1 1];
    DC_cancel = fir2(64,f,m);
    %% rf channel data interpolation
    interp_rate = 8; % channel data interpolation rate
    %% reordering information
    rx_HalfCh = N_ch*0.5;
    rx_ch_mtx = [-rx_HalfCh:rx_HalfCh-1];

    RxMux = zeros(N_sc, N_ch);
    SCvsEle = sc_d/pitch;

    for sc = 1:N_sc
        idx = floor((sc-1)*SCvsEle) + 1;

        rx_idx_tmp = idx + rx_ch_mtx;
        rx_idx = rx_idx_tmp((rx_idx_tmp > 0) & (rx_idx_tmp <= N_ele));
        RxMux(sc,:) = rx_idx_tmp;
    end
    %%
    half_ele = -(N_ele-1)*pitch/2; % half aperture size
    half_rx_ch = N_ch*pitch/2; % half rx channel size

    sc_weight = zeros(data_total,1);
    sc_weight(st_sam:ed_sam) = 1;

    n_sample = [0:data_total-1]' + Offset;
    d_sample = n_sample * pixel_d;
    d_mtx = d_sample * ones(1,N_ele); % depth information matrix

    ele_pos = [half_ele:pitch:-half_ele]; % element position matrix

    % rx data read pointer offset matrix
    rp_mtx = ones(data_total,1) * [0:data_total*interp_rate:data_total*interp_rate*(N_ele-1)];

    LPBF_output  = zeros(data_total, 128,N_sc);

    j = sqrt(-1);
    %ChData = ChData';%notin orig script, but needed to make dims match 
    for sc = 1:N_sc
     %sc = 1;   
        %disp(['SC : ',num2str(sc)])
        %cmd = sprintf('ChData = avgA;',sc-1);
        cmd = sprintf('ChData = A;',sc-1);
        %cmd = sprintf('ChData = AdcData_scanline%03d_thi0_sa0;',sc-1);
        eval(cmd);
        ChData = ChData';
        RF_Ch_data = double(abs(ChData));
   
        inter_p_B_tmp = zeros(data_total*interp_rate,N_ele);

        for ch = 1:N_ele
            tmp = RF_Ch_data(:,ch);
            fil_tmp = conv(tmp, DC_cancel, 'same');
            inter_p_B_tmp(:,ch) = interp(fil_tmp,interp_rate);
            %inter_p_B_tmp(:,ch) = tmp;
        end
        %     inter_p_B_tmp = hilbert(inter_p_B_tmp); % hilbert transform

        Rx_apod_index = zeros(data_total, N_ele); % apodization matrix initialize

        sc_pos = st_sc_x + (sc-1)*sc_d; % current scanline position

        ch_pos = abs(sc_pos - ele_pos); % current channel position
        ch_pos_mtx = ones(data_total,1) * ch_pos;

        %%%%%%%%%%% Apodization matrix generation %%%%%%%%%%%%%%%%
        aper_size = d_mtx/Rx_F_num; % dynamic aperture size
        h_aper_size = aper_size * 0.5; % half size

        idx = find(h_aper_size >= half_rx_ch); % full aperture region index
        idx1 = find(h_aper_size < half_rx_ch); % small aperture region index

        apo_tmp = ch_pos_mtx./half_rx_ch;
        apo_tmp1 = ch_pos_mtx./h_aper_size;

        Rx_apod_index(idx) = apo_tmp(idx);
        Rx_apod_index(idx1) = apo_tmp1(idx1);

        idx4 = find(Rx_apod_index >= 1);
        Rx_apod_index(idx4) = 1;

        Rx_apod_index_r = Rx_apod_index;
        idx5 = find(Rx_apod_index_r < 1);
        Rx_apod_index_r(idx5) = 0;

        rect_apo = 0.5+0.5.*cos(Rx_apod_index_r.*pi);    % rectangle window

        %%%%%%%%%%%% focused channel data %%%%%%%%%%%%%%%%%%%

        tx_t = d_mtx./c;
        rx_t = sqrt(ch_pos_mtx.^2 + d_mtx.^2)./c;

        %read_pointer_rx = round((tx_t + rx_t)*fs*interp_rate);
        read_pointer_rx = round(( rx_t)*fs*interp_rate);

        idx = find(read_pointer_rx > data_total*interp_rate);
        read_pointer_rx(idx) = data_total*interp_rate;

        idx = find(read_pointer_rx < 1);
        read_pointer_rx(idx) = 1;

        focused_ch_data = conj(inter_p_B_tmp(read_pointer_rx+rp_mtx)');
        LPBF_output(:,:, sc) = (focused_ch_data)';%sum
       
     %figure(3), imagesc(focused_ch_data); drawnow
     %colormap gray
     %figure(4), imagesc(LPBF_output(:,:,sc)); drawnow
     %colormap gray
    end 
    filename = sprintf('%s/LPBF_output.mat', datapath);%pname);
    %save(filename,'LPBF_output');
%return

    %%
    LPBF_output = squeeze(sum(LPBF_output,2));%
    LPBF_output = hilbert(LPBF_output); % hilbert transform

    RF_env = abs(LPBF_output);%
    figure(5), imagesc(RF_env); drawnow

    data_max = max(max(RF_env));
    % data_max = 751.3949;


    log_data = RF_env./data_max;

    dB = 30;
    min_dB = 10^(-dB/20);

    for i=1:N_sc
        for j=1:data_total
            if(log_data(j,i) < min_dB)
                log_data(j,i) = 0;
            else
                log_data(j,i) = 255*((20/dB)*log10(log_data(j,i))+1);
            end
        end
    end
    
    
% figure(7), imagesc(log_data)

    %%
    img_width = scan_view_size;
%     img_dep = data_total*pixel_d;
    img_dep = 0.042;
    
    lat = img_width;
    ax = [1:data_total]*pixel_d;
    ax2 = ax(1:data_total1);
    %figure(7), imagesc([0 lat],ax2, RF_env(1:data_total1,:), [0,5e3]);%2e+4])
    %axis image
    %colormap gray
      
    img_x = 500;
    img_z = 650;

    B_img = zeros(img_z, img_x);

    dx = img_width/(img_x-1);
    dz = img_dep/img_z;

    for i=1:img_x
        ix = (i-1)*dx;
        for j=1:img_z
            iz = (j-1.5)*dz;

            z = iz/pixel_d;
            x = ix/sc_d + 1;

            z_L = floor(z);
            z_H = z_L+1;
            x_L = floor(x);
            x_H = x_L+1;

            z_err = z-z_L;
            x_err = x-x_L;

            if((z_L>0) && (z_H <= data_total) && (x_L > 0) &&(x_H <= N_sc))
                Zon = log_data(z_L,x_L);
                Zon1 = log_data(z_H,x_L);
                Zin = log_data(z_L,x_H);
                Zin1 = log_data(z_H,x_H);

                Zri = Zin*(1-z_err) + Zin1*z_err;
                Zro = Zon*(1-z_err) + Zon1*z_err;
                Z = Zro*(1-x_err) + Zri*x_err;

                B_img(j,i) = Z;
            end
        end
    end
    imagesc(1000*linspace(0,img_width,img_x),1000*linspace(0,img_dep,img_z),B_img);axis image; colormap gray;%c/fs/2*
    axis image;xlabel('Lateral Position [mm]');ylabel('Depth [mm]');
    saveas(gcf,[saveDir '/' saveName ]);
%     filename = [SaveDir '/RF_sum_DS_dB-' dataList(datano).name '-'  num2str(num) '.mat'];
%     save(filename,'B_img', 'RF_env', 'ax', 'lat');
end

