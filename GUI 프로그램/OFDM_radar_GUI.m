 classdef OFDM_radar_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        StatusLampLabel                 matlab.ui.control.Label
        StatusLamp                      matlab.ui.control.Lamp
        OFDMRADARLabel                  matlab.ui.control.Label
        ConnectionButton                matlab.ui.control.Button
        StatusLamp_2                    matlab.ui.control.Lamp
        ReceiverparameterPanel          matlab.ui.container.Panel
        FsMHzLabel                      matlab.ui.control.Label
        FsMHzDropDown_2                 matlab.ui.control.DropDown
        FcGHzEditFieldLabel             matlab.ui.control.Label
        FcGHzEditField                  matlab.ui.control.EditField
        RADARparameterPanel             matlab.ui.container.Panel
        WindowDropDownLabel             matlab.ui.control.Label
        WindowDropDown                  matlab.ui.control.DropDown
        DistanceresolutionEditFieldLabel  matlab.ui.control.Label
        DistanceresolutionEditField     matlab.ui.control.NumericEditField
        SpeedresolutionEditFieldLabel   matlab.ui.control.Label
        SpeedresolutionEditField        matlab.ui.control.NumericEditField
        DistanceAxisEditFieldLabel      matlab.ui.control.Label
        DistanceAxisEditField           matlab.ui.control.NumericEditField
        SpeedAxisEditFieldLabel         matlab.ui.control.Label
        SpeedAxisEditField              matlab.ui.control.NumericEditField
        CFARparameterPanel              matlab.ui.container.Panel
        GuardBandEditFieldLabel         matlab.ui.control.Label
        GuardBandEditField              matlab.ui.control.NumericEditField
        TrainingBandEditFieldLabel      matlab.ui.control.Label
        TrainingBandEditField           matlab.ui.control.NumericEditField
        ProbFalseAlarmEditField_2Label  matlab.ui.control.Label
        ProbFalseAlarmEditField_2       matlab.ui.control.NumericEditField
        SetupButton                     matlab.ui.control.Button
        CollectionlengthEditFieldLabel  matlab.ui.control.Label
        CollectionlengthEditField       matlab.ui.control.NumericEditField
        MaxAGCgainEditFieldLabel        matlab.ui.control.Label
        MaxAGCgainEditField             matlab.ui.control.NumericEditField
        NumofframeEditFieldLabel        matlab.ui.control.Label
        NumofframeEditField             matlab.ui.control.NumericEditField
        DisconnectionButton             matlab.ui.control.Button
        TransmitterparameterPanel       matlab.ui.container.Panel
        BandwidthMHzDropDownLabel       matlab.ui.control.Label
        BandwidthMHzDropDown            matlab.ui.control.DropDown
        NumofOFDMsymbolDropDownLabel    matlab.ui.control.Label
        NumofOFDMsymbolDropDown         matlab.ui.control.DropDown
        FFTpointDropDownLabel           matlab.ui.control.Label
        FFTpointDropDown                matlab.ui.control.DropDown
        RightPanel                      matlab.ui.container.Panel
        TextArea                        matlab.ui.control.TextArea
        TabGroup                        matlab.ui.container.TabGroup
        RangeDopplerlogTab              matlab.ui.container.Tab
        UIAxes_3                        matlab.ui.control.UIAxes
        RangeDopplerlinearTab           matlab.ui.container.Tab
        UIAxes_4                        matlab.ui.control.UIAxes
        CFARTab_2                       matlab.ui.container.Tab
        UIAxes_5                        matlab.ui.control.UIAxes
        TimedomainTab                   matlab.ui.container.Tab
        UIAxes                          matlab.ui.control.UIAxes
        SpectrumTab                     matlab.ui.container.Tab
        UIAxes_2                        matlab.ui.control.UIAxes
        SavematButton                   matlab.ui.control.Button
        CollectionButton                matlab.ui.control.Button
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        address
        platform
        radio_rx
        status_usrp=0;
        Fs
        save_data
        wave_form
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ConnectionButton
        function ConnectionButtonPushed(app, event)
            app.TextArea.Value = {'Loading'};
            [output,app.address,app.platform]=USRP_connection();
            if strncmp(output, 'Success', 7)
                app.StatusLamp.Visible = 'on';
                app.StatusLamp_2.Visible = 'off';
                app.TextArea.Value = {'Success USRP connection!';'Set trigger channel Port 1 and Receiver Channel Port 2';'Set parameters'};
                app.status_usrp=1;
                app.SetupButton.Enable = 'on';
                app.ConnectionButton.Enable = 'off';
                app.DisconnectionButton.Enable = 'on';
            else
                app.StatusLamp.Visible = 'off';
                app.StatusLamp_2.Visible = 'on';
                app.TextArea.Value = {'USRP connection failed.';'Check your connection'};
            end
        end

        % Button pushed function: SetupButton
        function SetupButtonPushed(app, event)
            if app.status_usrp==1
                app.TextArea.Value = {'Loading'};
                if strcmp(app.FsMHzDropDown_2.Value, '184.32')
                    master_clock=184.32e6;
                    Deci_factor=1;
                    app.Fs=184.32*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '61.44')
                    master_clock=184.32e6;
                    Deci_factor=3;
                    app.Fs=61.44*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '30.72')
                    master_clock=184.32e6;
                    Deci_factor=6;
                    app.Fs=30.72*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '15.36')
                    master_clock=184.32e6;
                    Deci_factor=12;
                    app.Fs=15.36*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '200')
                    master_clock=200e6;
                    Deci_factor=1;
                    app.Fs=200*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '100')
                    master_clock=200e6;
                    Deci_factor=2;
                    app.Fs=100*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '50')
                    master_clock=200e6;
                    Deci_factor=4;
                    app.Fs=50*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '40')
                    master_clock=200e6;
                    Deci_factor=5;
                    app.Fs=40*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '20')
                    master_clock=200e6;
                    Deci_factor=10;
                    app.Fs=20*1e6;
                elseif strcmp(app.FsMHzDropDown_2.Value, '10')
                    master_clock=200e6;
                    Deci_factor=20;
                    app.Fs=10*1e6;
                end
                app.radio_rx = comm.SDRuReceiver(...
                    'Platform',             app.platform, ...
                    'IPAddress',            app.address, ...
                    'MasterClockRate',      master_clock, ...
                    'CenterFrequency',      str2double(app.FcGHzEditField.Value)*1e9, ...
                    'LocalOscillatorOffset',0,...
                    'ChannelMapping',       [1 2], ... % 1.rx_signal 2.trigger
                    'ClockSource',          'External',... % 10MHz
                    'Gain',                 app.MaxAGCgainEditField.Value, ... % max AGC gain
                    'DecimationFactor',     Deci_factor, ...
                    'SamplesPerFrame',      app.CollectionlengthEditField.Value, ...
                    'OutputDataType',       'double');
                [rx_sig, dataLen, overrun] = app.radio_rx();
                app.TextArea.Value = {'Ready to go!'};
                app.CollectionButton.Enable = 'on';
                
            else
                app.TextArea.Value = {'USRP is not connected.'; 'Please connect USRP to PC.'};
            end
        end

        % Button pushed function: CollectionButton
        function CollectionButtonPushed(app, event)
            if app.status_usrp==1
                app.TextArea.Value = {'Loading'};
                app.save_data=zeros(app.DistanceresolutionEditField.Value,app.SpeedresolutionEditField.Value,app.NumofframeEditField.Value);
                app.wave_form=zeros(app.CollectionlengthEditField.Value,2,app.NumofframeEditField.Value);
                for n=1:app.NumofframeEditField.Value
                    while(1)
                        [rx_sig, dataLen, overrun] = app.radio_rx();
                        if dataLen > 0
                            break;
                        end
                    end
                    if strcmp(app.WindowDropDown.Value,'Square')
                        window_idx=1;
                    elseif strcmp(app.WindowDropDown.Value,'Hanning')
                        window_idx=2;
                    elseif strcmp(app.WindowDropDown.Value,'Hamming')
                        window_idx=3;
                    elseif strcmp(app.WindowDropDown.Value,'Blackmanharris')
                        window_idx=4;
                    elseif strcmp(app.WindowDropDown.Value,'Chebwin')
                        window_idx=5;
                    end
                    [data_set_log,data_set_linear,speed_range,dist_range]=range_doppler(rx_sig,app.DistanceresolutionEditField.Value,app.SpeedresolutionEditField.Value,str2double(app.FcGHzEditField.Value),window_idx,str2double(app.NumofOFDMsymbolDropDown.Value),str2double(app.BandwidthMHzDropDown.Value),str2double(app.FFTpointDropDown.Value));
                    
                    plot(app.UIAxes,abs(rx_sig(:,2)))
                    [pxx, f] = pwelch(rx_sig(:,2), hanning(512), 256, 8192, app.Fs ,'centered','power');
                    plot(app.UIAxes_2,f,10*log10(pxx),'LineWidth',1.5);
                    axis(app.UIAxes_2,[-app.Fs/2 app.Fs/2 min(10*log10(pxx)) max(10*log10(pxx))])
                    
                    mesh(app.UIAxes_3,speed_range,dist_range,data_set_log);
                    view(app.UIAxes_3,2);
                    axis(app.UIAxes_3,[-app.SpeedAxisEditField.Value app.SpeedAxisEditField.Value 0 app.DistanceAxisEditField.Value])
                    
                    mesh(app.UIAxes_4,speed_range,dist_range,data_set_linear);
                    view(app.UIAxes_4,2);
                    axis(app.UIAxes_4,[-app.SpeedAxisEditField.Value app.SpeedAxisEditField.Value 0 app.DistanceAxisEditField.Value])
                    
                    cfar2D = phased.CFARDetector2D('GuardBandSize',app.GuardBandEditField.Value,'TrainingBandSize',app.TrainingBandEditField.Value,...
                        'ProbabilityFalseAlarm',app.ProbFalseAlarmEditField_2.Value);
                    
                    % [resp,rngGrid,dopGrid] = helperRangeDoppler;
                    %
                    [~,rangeIndx] = min(abs((-dist_range).'-[-app.DistanceAxisEditField.Value app.DistanceAxisEditField.Value]));
                    [~,dopplerIndx] = min(abs(speed_range.'-[-app.SpeedAxisEditField.Value app.SpeedAxisEditField.Value]));
                    [columnInds,rowInds] = meshgrid(dopplerIndx(1):dopplerIndx(2),...
                        rangeIndx(1):rangeIndx(2));
                    CUTIdx = [rowInds(:) columnInds(:)]';
                    resp=data_set_linear;
                    detections = cfar2D(resp,CUTIdx);
                    %                 helperDetectionsMap(resp,dist_range,speed_range,rangeIndx,dopplerIndx,detections,app.DistanceAxisEditField.Value,app.SpeedAxisEditField.Value)
                    detectionMap = zeros(size(resp));
                    detectionMap(rangeIndx(1):rangeIndx(2),dopplerIndx(1):dopplerIndx(2)) = ...
                        reshape(double(detections),rangeIndx(2)-rangeIndx(1)+1,dopplerIndx(2)-dopplerIndx(1)+1);
                    h = imagesc(app.UIAxes_5,speed_range,dist_range,detectionMap);
                    xlabel(app.UIAxes_5,'Speed (Km/h)'); ylabel(app.UIAxes_5,'Range (m)');
                    X=app.SpeedAxisEditField.Value;
                    Y=app.DistanceAxisEditField.Value;
                    axis(app.UIAxes_5,[-X X 0 Y])
                    h.Parent.YDir = 'normal';
                    app.save_data(:,:,n)=data_set_log;
                    app.wave_form(:,:,n)=rx_sig;
                end
                app.SavematButton.Enable = 'on';
                app.TextArea.Value = {'Finish'};
            else
                app.TextArea.Value = {'USRP is not connected.'; 'Please connect USRP to PC.'};
            end
        end

        % Button pushed function: DisconnectionButton
        function DisconnectionButtonPushed(app, event)
            if app.status_usrp==1
                app.TextArea.Value = {'Loading'};
                release(app.radio_rx);
                app.StatusLamp.Visible = 'off';
                app.StatusLamp_2.Visible = 'on';
                app.TextArea.Value = {'USRP disconnect successful!'};
                app.status_usrp=0;
                app.SavematButton.Enable = 'off';
                app.CollectionButton.Enable = 'off';
                app.SetupButton.Enable = 'off';
                app.ConnectionButton.Enable = 'on';
                app.DisconnectionButton.Enable = 'off';
            else
                app.TextArea.Value = {'USRP is not connected.'; 'Please connect USRP to PC.'};
            end
        end

        % Button pushed function: SavematButton
        function SavematButtonPushed(app, event)
            t = string(datetime('now','TimeZone','local','Format','dd_MM_y HH_mm_ss'));
            S=sprintf("%s Num_frame(%d)",t,app.NumofframeEditField.Value);
            range_doppler_Data=app.save_data;
            waveform=app.wave_form;
            save(S,'range_doppler_Data','waveform','-v7.3')
            app.TextArea.Value = {'Save was successful.!'};
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {741, 741};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1064 741];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.TitlePosition = 'centertop';
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create StatusLampLabel
            app.StatusLampLabel = uilabel(app.LeftPanel);
            app.StatusLampLabel.HorizontalAlignment = 'right';
            app.StatusLampLabel.Position = [130 638 40 22];
            app.StatusLampLabel.Text = 'Status';

            % Create StatusLamp
            app.StatusLamp = uilamp(app.LeftPanel);
            app.StatusLamp.Visible = 'off';
            app.StatusLamp.Position = [185 638 20 20];

            % Create OFDMRADARLabel
            app.OFDMRADARLabel = uilabel(app.LeftPanel);
            app.OFDMRADARLabel.HorizontalAlignment = 'center';
            app.OFDMRADARLabel.FontSize = 18;
            app.OFDMRADARLabel.FontWeight = 'bold';
            app.OFDMRADARLabel.Position = [46 675 128 50];
            app.OFDMRADARLabel.Text = 'OFDM RADAR';

            % Create ConnectionButton
            app.ConnectionButton = uibutton(app.LeftPanel, 'push');
            app.ConnectionButton.ButtonPushedFcn = createCallbackFcn(app, @ConnectionButtonPushed, true);
            app.ConnectionButton.Position = [17 658 100 22];
            app.ConnectionButton.Text = 'Connection';

            % Create StatusLamp_2
            app.StatusLamp_2 = uilamp(app.LeftPanel);
            app.StatusLamp_2.Position = [185 639 20 20];
            app.StatusLamp_2.Color = [1 0 0];

            % Create ReceiverparameterPanel
            app.ReceiverparameterPanel = uipanel(app.LeftPanel);
            app.ReceiverparameterPanel.TitlePosition = 'centertop';
            app.ReceiverparameterPanel.Title = 'Receiver parameter';
            app.ReceiverparameterPanel.BackgroundColor = [1 1 1];
            app.ReceiverparameterPanel.Position = [6 9 208 499];

            % Create FsMHzLabel
            app.FsMHzLabel = uilabel(app.ReceiverparameterPanel);
            app.FsMHzLabel.HorizontalAlignment = 'right';
            app.FsMHzLabel.Position = [8 422 51 22];
            app.FsMHzLabel.Text = 'Fs(MHz)';

            % Create FsMHzDropDown_2
            app.FsMHzDropDown_2 = uidropdown(app.ReceiverparameterPanel);
            app.FsMHzDropDown_2.Items = {'200', '184.32', '100', '61.44', '50', '40', '30.72', '20', '15.36', '10'};
            app.FsMHzDropDown_2.Position = [73 422 118 22];
            app.FsMHzDropDown_2.Value = '30.72';

            % Create FcGHzEditFieldLabel
            app.FcGHzEditFieldLabel = uilabel(app.ReceiverparameterPanel);
            app.FcGHzEditFieldLabel.HorizontalAlignment = 'right';
            app.FcGHzEditFieldLabel.Position = [8 453 51 22];
            app.FcGHzEditFieldLabel.Text = 'Fc(GHz)';

            % Create FcGHzEditField
            app.FcGHzEditField = uieditfield(app.ReceiverparameterPanel, 'text');
            app.FcGHzEditField.Position = [74 453 117 22];
            app.FcGHzEditField.Value = 'DC to 6GHz';

            % Create RADARparameterPanel
            app.RADARparameterPanel = uipanel(app.ReceiverparameterPanel);
            app.RADARparameterPanel.TitlePosition = 'centertop';
            app.RADARparameterPanel.Title = 'RADAR parameter';
            app.RADARparameterPanel.Position = [11 40 188 282];

            % Create WindowDropDownLabel
            app.WindowDropDownLabel = uilabel(app.RADARparameterPanel);
            app.WindowDropDownLabel.HorizontalAlignment = 'right';
            app.WindowDropDownLabel.Position = [1 233 48 22];
            app.WindowDropDownLabel.Text = 'Window';

            % Create WindowDropDown
            app.WindowDropDown = uidropdown(app.RADARparameterPanel);
            app.WindowDropDown.Items = {'Square', 'Hanning', 'Hamming', 'Blackmanharris', 'Chebwin'};
            app.WindowDropDown.Position = [63 233 87 22];
            app.WindowDropDown.Value = 'Hanning';

            % Create DistanceresolutionEditFieldLabel
            app.DistanceresolutionEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.DistanceresolutionEditFieldLabel.HorizontalAlignment = 'right';
            app.DistanceresolutionEditFieldLabel.Position = [1 206 108 22];
            app.DistanceresolutionEditFieldLabel.Text = 'Distance resolution';

            % Create DistanceresolutionEditField
            app.DistanceresolutionEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.DistanceresolutionEditField.Position = [120 206 63 22];
            app.DistanceresolutionEditField.Value = 4096;

            % Create SpeedresolutionEditFieldLabel
            app.SpeedresolutionEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.SpeedresolutionEditFieldLabel.HorizontalAlignment = 'right';
            app.SpeedresolutionEditFieldLabel.Position = [1 179 96 22];
            app.SpeedresolutionEditFieldLabel.Text = 'Speed resolution';

            % Create SpeedresolutionEditField
            app.SpeedresolutionEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.SpeedresolutionEditField.Position = [120 179 63 22];
            app.SpeedresolutionEditField.Value = 256;

            % Create DistanceAxisEditFieldLabel
            app.DistanceAxisEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.DistanceAxisEditFieldLabel.HorizontalAlignment = 'right';
            app.DistanceAxisEditFieldLabel.Position = [1 152 78 22];
            app.DistanceAxisEditFieldLabel.Text = 'Distance Axis';

            % Create DistanceAxisEditField
            app.DistanceAxisEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.DistanceAxisEditField.Position = [120 152 63 22];
            app.DistanceAxisEditField.Value = 500;

            % Create SpeedAxisEditFieldLabel
            app.SpeedAxisEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.SpeedAxisEditFieldLabel.HorizontalAlignment = 'right';
            app.SpeedAxisEditFieldLabel.Position = [1 125 66 22];
            app.SpeedAxisEditFieldLabel.Text = 'Speed Axis';

            % Create SpeedAxisEditField
            app.SpeedAxisEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.SpeedAxisEditField.Position = [120 125 63 22];
            app.SpeedAxisEditField.Value = 500;

            % Create CFARparameterPanel
            app.CFARparameterPanel = uipanel(app.RADARparameterPanel);
            app.CFARparameterPanel.TitlePosition = 'centertop';
            app.CFARparameterPanel.Title = 'CFAR parameter';
            app.CFARparameterPanel.BackgroundColor = [0.8 0.8 0.8];
            app.CFARparameterPanel.Position = [6 9 177 111];

            % Create GuardBandEditFieldLabel
            app.GuardBandEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.GuardBandEditFieldLabel.HorizontalAlignment = 'right';
            app.GuardBandEditFieldLabel.Position = [6 75 70 22];
            app.GuardBandEditFieldLabel.Text = 'Guard Band';

            % Create GuardBandEditField
            app.GuardBandEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.GuardBandEditField.Position = [122 75 58 22];
            app.GuardBandEditField.Value = 4;

            % Create TrainingBandEditFieldLabel
            app.TrainingBandEditFieldLabel = uilabel(app.RADARparameterPanel);
            app.TrainingBandEditFieldLabel.HorizontalAlignment = 'right';
            app.TrainingBandEditFieldLabel.Position = [5 48 80 22];
            app.TrainingBandEditFieldLabel.Text = 'Training Band';

            % Create TrainingBandEditField
            app.TrainingBandEditField = uieditfield(app.RADARparameterPanel, 'numeric');
            app.TrainingBandEditField.Position = [122 48 58 22];
            app.TrainingBandEditField.Value = 9;

            % Create ProbFalseAlarmEditField_2Label
            app.ProbFalseAlarmEditField_2Label = uilabel(app.RADARparameterPanel);
            app.ProbFalseAlarmEditField_2Label.HorizontalAlignment = 'right';
            app.ProbFalseAlarmEditField_2Label.Position = [5 21 102 22];
            app.ProbFalseAlarmEditField_2Label.Text = 'Prob. False Alarm';

            % Create ProbFalseAlarmEditField_2
            app.ProbFalseAlarmEditField_2 = uieditfield(app.RADARparameterPanel, 'numeric');
            app.ProbFalseAlarmEditField_2.Position = [122 21 58 22];
            app.ProbFalseAlarmEditField_2.Value = 1e-05;

            % Create SetupButton
            app.SetupButton = uibutton(app.ReceiverparameterPanel, 'push');
            app.SetupButton.ButtonPushedFcn = createCallbackFcn(app, @SetupButtonPushed, true);
            app.SetupButton.Enable = 'off';
            app.SetupButton.Position = [55 10 100 22];
            app.SetupButton.Text = 'Set up';

            % Create CollectionlengthEditFieldLabel
            app.CollectionlengthEditFieldLabel = uilabel(app.ReceiverparameterPanel);
            app.CollectionlengthEditFieldLabel.HorizontalAlignment = 'right';
            app.CollectionlengthEditFieldLabel.Position = [8 391 94 22];
            app.CollectionlengthEditFieldLabel.Text = 'Collection length';

            % Create CollectionlengthEditField
            app.CollectionlengthEditField = uieditfield(app.ReceiverparameterPanel, 'numeric');
            app.CollectionlengthEditField.ValueDisplayFormat = '%.0f';
            app.CollectionlengthEditField.Position = [118 391 71 22];
            app.CollectionlengthEditField.Value = 187500;

            % Create MaxAGCgainEditFieldLabel
            app.MaxAGCgainEditFieldLabel = uilabel(app.ReceiverparameterPanel);
            app.MaxAGCgainEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxAGCgainEditFieldLabel.Position = [8 360 84 22];
            app.MaxAGCgainEditFieldLabel.Text = 'Max AGC gain';

            % Create MaxAGCgainEditField
            app.MaxAGCgainEditField = uieditfield(app.ReceiverparameterPanel, 'numeric');
            app.MaxAGCgainEditField.Position = [118 360 71 22];
            app.MaxAGCgainEditField.Value = 1;

            % Create NumofframeEditFieldLabel
            app.NumofframeEditFieldLabel = uilabel(app.ReceiverparameterPanel);
            app.NumofframeEditFieldLabel.HorizontalAlignment = 'right';
            app.NumofframeEditFieldLabel.Position = [10 329 82 22];
            app.NumofframeEditFieldLabel.Text = 'Num. of frame';

            % Create NumofframeEditField
            app.NumofframeEditField = uieditfield(app.ReceiverparameterPanel, 'numeric');
            app.NumofframeEditField.Position = [118 329 71 22];
            app.NumofframeEditField.Value = 10;

            % Create DisconnectionButton
            app.DisconnectionButton = uibutton(app.LeftPanel, 'push');
            app.DisconnectionButton.ButtonPushedFcn = createCallbackFcn(app, @DisconnectionButtonPushed, true);
            app.DisconnectionButton.Enable = 'off';
            app.DisconnectionButton.Position = [17 624 100 22];
            app.DisconnectionButton.Text = 'Disconnection';

            % Create TransmitterparameterPanel
            app.TransmitterparameterPanel = uipanel(app.LeftPanel);
            app.TransmitterparameterPanel.TitlePosition = 'centertop';
            app.TransmitterparameterPanel.Title = 'Transmitter parameter';
            app.TransmitterparameterPanel.Position = [6 512 208 105];

            % Create BandwidthMHzDropDownLabel
            app.BandwidthMHzDropDownLabel = uilabel(app.TransmitterparameterPanel);
            app.BandwidthMHzDropDownLabel.HorizontalAlignment = 'right';
            app.BandwidthMHzDropDownLabel.Position = [1 57 94 22];
            app.BandwidthMHzDropDownLabel.Text = 'Bandwidth(MHz)';

            % Create BandwidthMHzDropDown
            app.BandwidthMHzDropDown = uidropdown(app.TransmitterparameterPanel);
            app.BandwidthMHzDropDown.Items = {'80', '40', '20'};
            app.BandwidthMHzDropDown.Position = [133 57 62 22];
            app.BandwidthMHzDropDown.Value = '20';

            % Create NumofOFDMsymbolDropDownLabel
            app.NumofOFDMsymbolDropDownLabel = uilabel(app.TransmitterparameterPanel);
            app.NumofOFDMsymbolDropDownLabel.HorizontalAlignment = 'right';
            app.NumofOFDMsymbolDropDownLabel.Position = [1 7 128 22];
            app.NumofOFDMsymbolDropDownLabel.Text = 'Num. of OFDM symbol';

            % Create NumofOFDMsymbolDropDown
            app.NumofOFDMsymbolDropDown = uidropdown(app.TransmitterparameterPanel);
            app.NumofOFDMsymbolDropDown.Items = {'64', '48', '32', '16'};
            app.NumofOFDMsymbolDropDown.Position = [133 7 62 22];
            app.NumofOFDMsymbolDropDown.Value = '64';

            % Create FFTpointDropDownLabel
            app.FFTpointDropDownLabel = uilabel(app.TransmitterparameterPanel);
            app.FFTpointDropDownLabel.Position = [8 33 57 22];
            app.FFTpointDropDownLabel.Text = 'FFT point';

            % Create FFTpointDropDown
            app.FFTpointDropDown = uidropdown(app.TransmitterparameterPanel);
            app.FFTpointDropDown.Items = {'4096', '2048', '1024'};
            app.FFTpointDropDown.Position = [133 33 62 22];
            app.FFTpointDropDown.Value = '1024';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create TextArea
            app.TextArea = uitextarea(app.RightPanel);
            app.TextArea.FontSize = 15;
            app.TextArea.FontWeight = 'bold';
            app.TextArea.Position = [6 7 655 120];
            app.TextArea.Value = {'Connect USRP'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.RightPanel);
            app.TabGroup.Position = [6 138 832 597];

            % Create RangeDopplerlogTab
            app.RangeDopplerlogTab = uitab(app.TabGroup);
            app.RangeDopplerlogTab.Title = 'Range-Doppler(log)';

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.RangeDopplerlogTab);
            title(app.UIAxes_3, '')
            xlabel(app.UIAxes_3, 'Speed(km/h)')
            ylabel(app.UIAxes_3, 'Distance(m)')
            app.UIAxes_3.TitleFontWeight = 'bold';
            app.UIAxes_3.Position = [0 1 832 571];

            % Create RangeDopplerlinearTab
            app.RangeDopplerlinearTab = uitab(app.TabGroup);
            app.RangeDopplerlinearTab.Title = 'Range-Doppler(linear)';

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.RangeDopplerlinearTab);
            title(app.UIAxes_4, '')
            xlabel(app.UIAxes_4, 'Speed(km/h)')
            ylabel(app.UIAxes_4, 'Distance(m)')
            app.UIAxes_4.TitleFontWeight = 'bold';
            app.UIAxes_4.Position = [0 1 832 571];

            % Create CFARTab_2
            app.CFARTab_2 = uitab(app.TabGroup);
            app.CFARTab_2.Title = 'CFAR';

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.CFARTab_2);
            title(app.UIAxes_5, '')
            xlabel(app.UIAxes_5, 'Speed(km/h)')
            ylabel(app.UIAxes_5, 'Distance(m)')
            app.UIAxes_5.TitleFontWeight = 'bold';
            app.UIAxes_5.Position = [0 1 832 571];

            % Create TimedomainTab
            app.TimedomainTab = uitab(app.TabGroup);
            app.TimedomainTab.Title = 'Time domain';

            % Create UIAxes
            app.UIAxes = uiaxes(app.TimedomainTab);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, 'Sample Index')
            ylabel(app.UIAxes, '')
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [0 1 832 571];

            % Create SpectrumTab
            app.SpectrumTab = uitab(app.TabGroup);
            app.SpectrumTab.Title = 'Spectrum';

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.SpectrumTab);
            title(app.UIAxes_2, '')
            xlabel(app.UIAxes_2, 'Frequency (MHz)')
            ylabel(app.UIAxes_2, 'Power Spectral Density (dBm)')
            app.UIAxes_2.TitleFontWeight = 'bold';
            app.UIAxes_2.Position = [0 1 832 571];

            % Create SavematButton
            app.SavematButton = uibutton(app.RightPanel, 'push');
            app.SavematButton.ButtonPushedFcn = createCallbackFcn(app, @SavematButtonPushed, true);
            app.SavematButton.BackgroundColor = [0.651 0.651 0.651];
            app.SavematButton.FontSize = 20;
            app.SavematButton.FontWeight = 'bold';
            app.SavematButton.Enable = 'off';
            app.SavematButton.Position = [669 7 168 54];
            app.SavematButton.Text = {'Save'; '(.mat)'};

            % Create CollectionButton
            app.CollectionButton = uibutton(app.RightPanel, 'push');
            app.CollectionButton.ButtonPushedFcn = createCallbackFcn(app, @CollectionButtonPushed, true);
            app.CollectionButton.BackgroundColor = [0.651 0.651 0.651];
            app.CollectionButton.FontSize = 25;
            app.CollectionButton.FontWeight = 'bold';
            app.CollectionButton.Enable = 'off';
            app.CollectionButton.Position = [669 68 168 60];
            app.CollectionButton.Text = 'Collection';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = OFDM_radar_GUI

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