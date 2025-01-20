function varargout = cnn_gui(varargin) % Fungsi utama untuk GUI cnn_gui
% CNN_GUI MATLAB code for cnn_gui.fig
%      CNN_GUI, by itself, creates a new CNN_GUI or raises the existing
%      singleton*.
%
%      H = CNN_GUI returns the handle to a new CNN_GUI or the handle to
%      the existing singleton*.
%
%      CNN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CNN_GUI.M with the given input arguments.
%
%      CNN_GUI('Property','Value',...) creates a new CNN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cnn_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cnn_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cnn_gui

% Last Modified by GUIDE v2.5 19-May-2024 19:28:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
% Mengatur GUI sebagai singleton (hanya satu instance yang berjalan pada satu waktu)
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cnn_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @cnn_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
% Membuat struktur gui_State untuk menyimpan informasi tentang status GUI
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
% Jika ada argumen input dan argumen pertama adalah string, maka dianggap sebagai nama callback fungsi dan diubah menjadi fungsi


if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% Jika ada argumen output, jalankan fungsi utama GUI dan kembalikan argumen output yang sesuai. Jika tidak ada, cukup jalankan fungsi utama GUI

global I net
% End initialization code - DO NOT EDIT


% --- Executes just before cnn_gui is made visible.
function cnn_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cnn_gui (see VARARGIN)
% Fungsi ini dieksekusi sebelum GUI cnn_gui ditampilkan

% Choose default command line output for cnn_gui
handles.output = hObject;
% Menyimpan handle output GUI
load net 
handles.net = net;
axes1 = gca;
axes1.XAxis.Visible = 'off';   % remove y-axis
axes1.YAxis.Visible = 'off';   % remove y-axis

% Update handles structure
guidata(hObject, handles);
% Memperbarui data GUI

% UIWAIT makes cnn_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cnn_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject; % Menyimpan handle dari objek yang memicu callback (pushbutton1)

global GRAY % Mendeklarasikan variabel global GRAY

[fn pn] = uigetfile('*.jpg','*.png','select jpg file');
% Membuka dialog untuk memilih file gambar dengan ekstensi .jpg atau .png
% fn menyimpan nama file, pn menyimpan path file

str = strcat(pn,fn);
% Menggabungkan path dan nama file menjadi satu string

set(handles.edit1,'string',str);
% Menampilkan path dan nama file pada kontrol edit1 di GUI

I = imread(str);
% Membaca gambar dari path yang ditentukan

handles.I = I;
% Menyimpan gambar dalam struktur handles untuk diakses oleh fungsi lain

imshow(I, 'Parent', handles.axes1);
% Menampilkan gambar pada axes1 di GUI

GRAY = rgb2gray(I);
% Mengonversi gambar RGB ke grayscale dan menyimpannya di variabel global GRAY

guidata(hObject, handles);
% Memperbarui data GUI dengan perubahan yang dilakukan


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global GRAY 
% Mendeklarasikan variabel global GRAY

% Menerapkan filter Sobel pada gambar grayscale
EDGE = edge(GRAY, 'Sobel');
axes(handles.axes9);
imshow(EDGE);
guidata(hObject, handles);

% Menerapkan filter Prewitt pada gambar grayscale
global GRAY
EDGE = edge(GRAY, 'Prewitt');
axes(handles.axes10);
imshow(EDGE);
guidata(hObject, handles);

% Menerapkan filter Roberts pada gambar grayscale
global GRAY
EDGE = edge(GRAY, 'Roberts');
axes(handles.axes11);
imshow(EDGE);
guidata(hObject, handles);

% Menerapkan filter Laplacian of Gaussian (LoG) pada gambar grayscale
global GRAY
EDGE = edge(GRAY, 'log');
axes(handles.axes12);
imshow(EDGE);
guidata(hObject, handles);

% Menerapkan filter Canny pada gambar grayscale
global GRAY
EDGE = edge(GRAY, 'Canny');
axes(handles.axes13);
imshow(EDGE);
guidata(hObject, handles);

% Menampilkan histogram RGB setelah pemfilteran
I = handles.I;
R = imhist (I(:,:,1));
G = imhist (I(:,:,2));
B = imhist (I(:,:,3));
axes(handles.axes7),plot(R,'r')
hold on,plot(G,'g')
plot (B,'b'),legend('Red Channel','Green Channel','Blue Channel');
hold off,

% Melakukan klasifikasi apakah apel bagus atau busuk
handles = guidata(hObject);
net = handles.net;
I = handles.I;
I= imresize(I,[64,64],'nearest');
[Pred,scores]  = classify(net,I);
scores = max(double(scores*100));
set(handles.edit2,'string',join([string(Pred),'' ,scores ,'%']));
% Menampilkan hasil klasifikasi dan skor pada edit2


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle ke pushbutton12 (lihat GCBO)
% eventdata  dipesan - akan didefinisikan di versi MATLAB mendatang
% handles    struktur dengan handles dan user data (lihat GUIDATA)

handles = guidata(hObject);
% Mengambil data GUI yang terbaru

% Membuat image datastore dari folder 'Apel'
imds = imageDatastore('Apel', ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

% Mengatur penguat citra untuk augmentasi data
augmenter = imageDataAugmenter( ...
    'RandXReflection', true, ... % Refleksi horizontal acak
    'RandRotation', [-10 10], ... % Rotasi acak dalam rentang [-10, 10] derajat
    'RandXScale', [1 1.2], ... % Skala acak sumbu X dalam rentang [1, 1.2]
    'RandYReflection', true, ... % Refleksi vertikal acak
    'RandYScale', [1 1.2], ... % Skala acak sumbu Y dalam rentang [1, 1.2]
    'RandXTranslation', [-10 10], ... % Translasi acak sumbu X dalam rentang [-10, 10] piksel
    'RandYTranslation', [-10 10]); % Translasi acak sumbu Y dalam rentang [-10, 10] piksel

% Membagi data menjadi set pelatihan dan pengujian (50% masing-masing)
[imdsTrain, imdsTest] = splitEachLabel(imds, 0.5, 'randomize');

% Mendefinisikan ukuran gambar input
imageSize = [64 64 3];

% Membuat augmented image datastore untuk pelatihan
datastoreTrain = augmentedImageDatastore(imageSize, imdsTrain, 'DataAugmentation', augmenter);

% Membuat image datastore untuk pengujian
datastoreTest = augmentedImageDatastore(imageSize, imdsTest); % Mengubah ukuran gambar validasi

% Mendefinisikan arsitektur jaringan
layers = [ ...
    imageInputLayer(imageSize, 'Name', 'input'), ... % Lapisan input gambar
    convolution2dLayer(3, 8, 'Padding', 'same'), ... % Lapisan konvolusi dengan filter 3x3 dan 8 channel output
    batchNormalizationLayer, ... % Lapisan normalisasi batch
    reluLayer, ... % Lapisan aktivasi ReLU
    maxPooling2dLayer(2, 'Stride', 2), ... % Lapisan pooling maksimum dengan ukuran filter 2x2 dan langkah 2
    dropoutLayer(0.5), ... % Lapisan dropout dengan dropout rate 50%
    fullyConnectedLayer(2), ... % Lapisan fully connected dengan 2 neuron output (2 kelas)
    softmaxLayer, ... % Lapisan softmax untuk menghasilkan probabilitas
    classificationLayer]; % Lapisan klasifikasi

% Mendefinisikan opsi pelatihan
options = trainingOptions('sgdm', ...
    'MaxEpochs', 400, ... % Jumlah epoch maksimal 400
    'InitialLearnRate', 1e-4, ... % Learning rate awal 0.0001
    'Verbose', true, ... % Menampilkan informasi pelatihan
    'Plots', 'training-progress', ... % Menampilkan plot progres pelatihan
    'ValidationData', datastoreTest, ... % Menambahkan data validasi
    'ValidationFrequency', 30, ... % Frekuensi validasi setiap 30 iterasi
    'ValidationPatience', 5); ... % Patience untuk early stopping

% Melatih jaringan
net = trainNetwork(datastoreTrain, layers, options);

% Menyimpan jaringan saraf yang dilatih ke dalam struktur handles
handles.net = net;
guidata(hObject, handles);
% Memperbarui data GUI dengan perubahan yang dilakukan


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load net 
handles.net = net;
analyzeNetwork(net)
guidata(hObject, handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load net 
handles.net = net;
accuracy = sum(YPred == YTest)/numel(YTest)
set(handles.edit7,'string',accuracy);
guidata(hObject, handles);



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])

axes(handles.axes7)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])

axes(handles.axes9)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])

axes(handles.axes10)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])

axes(handles.axes11)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(handles.edit1, 'String', '')
set(handles.edit2, 'String', '')

axes(handles.axes12)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])

axes(handles.axes13)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])