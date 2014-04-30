
function GUICameravideo(hObject, eventdata, handles)  
global MainWindow axe1 axe2 axe3 UploadCameraButton SaveButton Saisie1 GorRGB

h=findall(gcf,'parent',gcf);
 for i = 1:length(h)
     delete(h(i))   
 end
 
%% menu
set(MainWindow,'MenuBar','none');
menu1 = uimenu(MainWindow, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', @GUITrain);
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', @GUICameravideo);

GorRGB = uicontrol ( MainWindow , 'Style' , 'popup' , 'String' , 'no|yes' , 'units','Normalized', 'position', [0.25,0.9,0.1,0.05]);
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.05,0.9,0.2,0.05],'string','convert images in gray-scaled image ?');

axe1 = axes('units', 'Normalized', 'position', [0.4,0.61, 0.3, 0.3], 'tag','axes1');
axis off
UploadBackgroundButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Background folder' , 'fontsize' , 15, 'Units', 'Normalized', 'position', [0.05,0.75,0.3,0.05]);
set(UploadBackgroundButton,'Callback',@UploadBackground);
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.05,0.7,0.3,0.05],'string','Select folder with the background images. The operation may take time');

SaveButton =  uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Save' , 'fontsize' , 15, 'Units', 'Normalized', 'position', [0.72,0.75,0.2,0.05]);
set(SaveButton,'Enable','off')
set(SaveButton,'Callback',@SaveFunction);

axe2 = axes('units', 'Normalized', 'position', [0.3,0.11, 0.3, 0.3], 'tag','axes1');
axis off
UploadCameraButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Camera' , 'fontsize' , 15, 'Units', 'Normalized', 'position', [0.05,0.25,0.2,0.05]);
set(UploadCameraButton,'Callback',@UploadCamera);
set(UploadCameraButton,'Enable','off')
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.05,0.2,0.2,0.05],'string','Select folder with the camera video images');

axe3 = axes('units', 'Normalized', 'position', [0.65,0.11, 0.3, 0.3], 'tag','axes1');
axis off

Saisie1 = uicontrol( MainWindow , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.23,0.35,0.05,0.05], 'Max' , 1 , 'string' , '0' );
set(Saisie1,'Enable','off')
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.03,0.35,0.2,0.05],'string','Iter Lucy');
%%

% Stockage des identifiants utiles
handles = guihandles(MainWindow);
guidata(MainWindow,handles)


function UploadBackground(hObject, eventdata, handles)  
global axe1 UploadCameraButton Out SaveButton Saisie1 GorRGB
set(UploadCameraButton,'Enable','on')
set(SaveButton, 'Enable','on');
set(Saisie1,'Enable','on')
directoryname = uigetdir;
ext = '*.jpg';
chemin = fullfile(directoryname,ext);
list = dir(chemin);
n = numel(list);
A = cell(1,n);
 
if get(GorRGB,'value') == 1
for i = 1:n
    [ratio A{i}] = compression(imread(fullfile(directoryname, list(i).name)), 2);
end
Out = DetectBackgroundColor(A); 
elseif get(GorRGB,'value') == 2
for i = 1:n
    [ratio A{i}] = compression(rgb2gray(imread(fullfile(directoryname, list(i).name))), 2);
end
Out = DetectBackground(A); % Que en noir et blanc
end
imshow(Out{1}/255,'parent',axe1)
title(axe1,'Background'); 
save('Bg','Out');


function UploadCamera(hObject, eventdata, handles)  
global axe1 axe2 axe3 Saisie1 GorRGB
load Bg
directoryname = uigetdir;
ext = '*.jpg';
chemin = fullfile(directoryname,ext);
list = dir(chemin);
iter = str2double(get(Saisie1,'String'));
for n = 1:numel(list)
     if get(GorRGB,'value') == 1
     [ratio img] = compression(imread(fullfile(directoryname, list(n).name)),2);
     elseif get(GorRGB,'value') == 2     
     [ratio img] = compression(rgb2gray(imread(fullfile(directoryname, list(n).name))),2);
     end
     imshow(img,'parent',axe2);
     title(axe2,'Blurred image'); 
     imshow(Out{1}/255,'parent',axe1);
     title(axe1,'Background'); 
     algo = 1;
     comp = 1;
     DeblurCam = cam(double(img), Out{1}, iter, algo, comp, Out{3}(:,:,1));
     save_imageCam (DeblurCam, 'CamDeblurred', 1,directoryname, n);
     imshow(DeblurCam/255,'parent',axe3);
     title(axe3,'Deblurred image'); 
     if get(GorRGB,'value') == 1
       Out = UpdateBackgroundColor(Out, img);
     elseif get(GorRGB,'value') == 2     
       Out = UpdateBackground(Out, img);
     end
     pause(0.01)
end

function SaveFunction(hObject, eventdata, handles)  
load Bg;
[filename,pathname] = uiputfile({'*.png';'*.jpg';'*.tiff';'*.bmp'},'Save Workspace as'); %Dans quel format le mettre ? 
chemin=[pathname filename]; 
if isequal(filename,0)
    %annulation ou fermeture de la fenetre 'browser'
    disp('User selected Cancel')
else
  imwrite(Out{1}/255, chemin); 
end

