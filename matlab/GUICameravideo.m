function GUICameravideo(hObject, eventdata, handles)  
global MainWindow axe1 axe2 UploadCameraButton

h=findall(gcf,'parent',gcf);
 for i = 1:length(h)
     delete(h(i))   
 end
 
%% menu
set(MainWindow,'MenuBar','none');
menu1 = uimenu(MainWindow, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', @GUITrain);
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', @GUICameravideo);


axe1 = axes('units', 'Normalized', 'position', [0.4,0.61, 0.3, 0.3], 'tag','axes1');
axis off
UploadBackgroundButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Background folder' , 'fontsize' , 15, 'Units', 'Normalized', 'position', [0.05,0.75,0.3,0.05]);
set(UploadBackgroundButton,'Callback',@UploadBackground);
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.05,0.7,0.3,0.05],'string','Select folder with the background images. The operation may take time');

axe2 = axes('units', 'Normalized', 'position', [0.3,0.11, 0.3, 0.3], 'tag','axes1');
axis off
UploadCameraButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Camera' , 'fontsize' , 15, 'Units', 'Normalized', 'position', [0.05,0.25,0.2,0.05]);
set(UploadCameraButton,'Callback',@UploadCamera);
set(UploadCameraButton,'Enable','off')
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.05,0.2,0.2,0.05],'string','Select folder with the camera video images');

axe3 = axes('units', 'Normalized', 'position', [0.65,0.11, 0.3, 0.3], 'tag','axes1');
axis off
%%

% Stockage des identifiants utiles
handles = guihandles(MainWindow);
guidata(MainWindow,handles)


function UploadBackground(hObject, eventdata, handles)  
global axe1 UploadCameraButton Out
set(UploadCameraButton,'Enable','on')
directoryname = uigetdir;
ext = '*.jpg';
chemin = fullfile(directoryname,ext);
list = dir(chemin);
n = numel(list);
A = cell(1,n);
for i = 1:n
    A{i} = rgb2gray(imread(fullfile(directoryname, list(i).name)));
end
Out = DetectBackground(A); % Que en noir et blanc 
imshow(uint8(Out{1}),'parent',axe1)

function UploadCamera(hObject, eventdata, handles)  
global axe1 axe2 Out
directoryname = uigetdir;
ext = '*.jpg';
chemin = fullfile(directoryname,ext);
list = dir(chemin);
for n = 1:numel(list)
     img = rgb2gray(imread(fullfile(directoryname, list(n).name)));
     Out = UpdateBackground(Out, img);
     imshow(img,'parent',axe2);
     imshow(uint8(Out{1}),'parent',axe1);
     pause(0.01)
end

