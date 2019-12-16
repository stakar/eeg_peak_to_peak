eeglab
tStart=clock;

[FileName, pathIn] = uigetfile('*.erp','Wskaż pliki erp dla amplitudy','MultiSelect','on');
if ~iscell(FileName)
    FileName={FileName};
end

LowerTimeWindow = 150;
group = '0';

A = readtable([group '_SN_lat.txt'],'ReadVariableNames',true);
%Na początku musi dostać tabelę z latencjami dla pozytywnych peaków p300

placeholder = zeros(height(A),width(A));
disp('Default settings of importing set:')
disp(['Length of set: ' num2str(length(FileName))])
disp(['Length of A: ' num2str(height(A))])

if (length(FileName) ~= height(A))
    disp('Fixed settings of importing set:')
    A = readtable([group '_SN_lat.txt'],'ReadVariableNames',false);
    disp(['Length of set: ' num2str(length(FileName))])
    disp(['Length of A: ' num2str(height(A))])
end

for i = 1:length(FileName)
    
    nazwapliku=FileName{i};
    % wczytaj EGI raw binary
    ERP = pop_loaderp( 'filename', strcat(pathIn,nazwapliku));% GUI: 16-Sep-2019 10:42:48
    for n = 0:3
        bin = n+1+2;
        for z = 0:1
            column = ((n*2)+z)+1;
            latency = A(i,column).Variables;
            chan = z+1+4;
            disp(chan)
            disp(bin)
            disp(latency)
            if (latency == LowerTimeWindow)
                lower = (latency-100);
            else 
                lower = LowerTimeWindow;
            end
            measurement = pop_geterpvalues(ERP,[lower latency],bin,chan,...
             'Baseline', [ -100 0], 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', 'test.txt',...
             'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3,...
             'PeakOnset',  1, 'Peakpolarity', 'positive',...
             'Peakreplace', 'absolute', 'Resolution',  3, 'SendtoWorkspace', 'on' );
            placeholder(i,column) = ERP_MEASURES;
        end
    end
end
WriteMatrix2Text(placeholder,[group '_SN_amp_ptp.txt'])


for i = 1:length(FileName)
    
    nazwapliku=FileName{i};
    % wczytaj EGI raw binary
    ERP = pop_loaderp( 'filename', strcat(pathIn,nazwapliku));% GUI: 16-Sep-2019 10:42:48
    for n = 0:3
        bin = n+1+2;
        for z = 0:1
            column = ((n*2)+z)+1;
            latency = A(i,column).Variables;
            chan = z+1+4;
            disp(chan)
            disp(bin)
            disp(latency)
            if (latency == LowerTimeWindow)
                lower = (latency-100);
            else 
                lower = LowerTimeWindow;
            end
            measurement = pop_geterpvalues(ERP,[lower latency],bin,chan,...
             'Baseline', [ -100 0], 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', 'test.txt',...
             'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peaklatbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive',...
             'Peakreplace', 'absolute', 'Resolution',  3, 'SendtoWorkspace', 'on' );
            placeholder(i,column) = ERP_MEASURES;
        end
    end
end
WriteMatrix2Text(placeholder,[group '_SN_lat_ptp.txt'])
