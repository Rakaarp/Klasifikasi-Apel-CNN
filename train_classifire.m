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

% Mengklasifikasikan data pengujian
YPred = classify(net, datastoreTest);

% Mendapatkan label asli dari data pengujian
YTest = imdsTest.Labels;

% Menghitung akurasi
accuracy = sum(YPred == YTest) / numel(YTest);

% Menampilkan hasil klasifikasi pada sebuah gambar
figure
I = imread('.\\Apel\\Busuk\\Bucuk (3).JPG'); % Membaca gambar
I2 = imresize(I, [64, 64], 'nearest'); % Mengubah ukuran gambar menjadi 64x64
[Pred, scores] = classify(net, I2); % Mengklasifikasikan gambar
scores = max(double(scores * 100)); % Mendapatkan skor probabilitas tertinggi
imshow(I); % Menampilkan gambar
title(join([string(Pred), '', scores, '%'])); % Menampilkan prediksi dan skor pada judul gambar
