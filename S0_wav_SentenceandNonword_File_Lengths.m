% Define the directory where your .wav files are located
folder = '/Users/ashliepankonin/Desktop/Verb Stim'; % Update 'path_to_folder' to your directory path
filePattern = fullfile(folder, '*.wav');
wavFiles = dir(filePattern);

% Initialize a cell array to store file names and lengths
fileInfo = cell(length(wavFiles), 2);

% Loop through each .wav file
for i = 1:length(wavFiles)
    filename = fullfile(folder, wavFiles(i).name);

    % Load the audio file using wavread (deprecated in newer MATLAB versions)
    [audio, Fs] = audioread(filename);

    % Calculate the duration of the audio in milliseconds
    duration_ms = size(audio, 1) / Fs * 1000;

    % Save the filename and duration to the cell array
    fileInfo{i, 1} = wavFiles(i).name;
    fileInfo{i, 2} = duration_ms;
end

% Display the file names and lengths
disp('File Names and Lengths (in milliseconds):');
disp(fileInfo);

% Save the cell array to a .mat file
save('file_info.mat', 'fileInfo');