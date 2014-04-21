%% Cr�ation des boutons
function GUITrain(hObject, eventdata, handles)  
global MainWindow ArtificialBlurButton DeblurButton1

h=findall(gcf,'parent',gcf);
 for i = 1:length(h)
     delete(h(i))   
 end
 %% menu 
set(MainWindow,'MenuBar','none');
menu1 = uimenu(MainWindow, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', @GUITrain);
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', @GUICameravideo);


UploadButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Upload Image' , 'fontsize' , 15, 'position', [250,500,150,30] );
set(UploadButton,'Callback',@LoadFunction);

ArtificialBlurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'artificially blur' , 'fontsize' , 15, 'position', [120,100,200,30] );
set(ArtificialBlurButton,'Enable','off')
set(ArtificialBlurButton,'Callback',@ArtificialBlurFunction);

DeblurButton1 = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Deblur image' , 'fontsize' , 15, 'position', [400,100,150,30] );
set(DeblurButton1,'Enable','off')
set(DeblurButton1,'Callback',@DeblurFunction1);


%%

axe1 = axes('units', 'pixels', 'position', [190,200, 300, 225], 'tag','axes1');
axis off; 
% Stockage des identifiants utiles
handles = guihandles(MainWindow);
guidata(MainWindow,handles)

function LoadFunction(hObject, eventdata, handles)  
%% attention code trouv� sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
global ArtificialBlurButton DeblurButton1 a
a = 0;
nomfichier=[]; 
[filename,pathname] = uigetfile({'*.png';'*.jpg';'*.tiff';'*.bmp'},'File Selector');% recupere le 
%chemin du r�pertoire et le nom du fichier 
chemin=[pathname filename]; 
% chemin absolu donnant nombre_images'image a utiliser pour la mosaique 

if isequal(filename,0)
    %annulation ou fermeture de la fenetre 'browser'
    disp('User selected Cancel')
else
    fullpath = fullfile(pathname, filename);
    disp(['Image acquise ', fullpath]);
    I = imread(filename);
    %I=rgb2gray(imread(filename));
    size(I)
    %I = rgb2gray(I);
    I = im2double(I);
    save('LALA','I')
    imshow(I);% Afficher l'image
    title('original image');
    axis off;
    handles.ImgPret=I;
end
set(ArtificialBlurButton,'Enable','on');
set(DeblurButton1,'Enable','on');
%guidata(hObject,handles) 

function ArtificialBlurFunction(hObject, eventdata, handles)  
global Saisie1 Saisie2 DeblurButton2 Enregistrer1Button 

ArtificialBlur = figure('color',[1 1 0]); 
set(ArtificialBlur,'MenuBar','none');
set(ArtificialBlur, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off','Name','Blurring artificialy','NumberTitle','off');
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load LALA;
imshow(I);% Afficher l'image 
title('Original Image'); 
axis off; 
handles.ImgPret=I; 

Saisie1 = uicontrol( ArtificialBlur , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.8,0.2,0.05], 'Max' , 1 , 'string' , '0' );
uicontrol(ArtificialBlur,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Blur angle');

Saisie2 = uicontrol( ArtificialBlur, 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0');
uicontrol(ArtificialBlur,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Blur length');

GoBlurButton = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoBlurButton,'Callback',@GoBlurFunction);

Enregistrer1Button = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'string' , 'Save' , 'fontsize' , 15, 'position', [100,40,200,30] );
set(Enregistrer1Button,'Enable','off')
set(Enregistrer1Button,'Callback',@Enregistrer1);

DeblurButton2 = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'string' , 'Deblur image' , 'fontsize' , 15, 'position', [380,40,280,30] );
set(DeblurButton2,'Enable','off')
set(DeblurButton2,'Callback',@DeblurFunction2);

handles = guihandles(ArtificialBlur);
guidata(hObject,handles) 

function DeblurFunction1(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse Enregistrer2Button 
MainWindow = figure('color',[1 0 0]); 
set(MainWindow,'MenuBar','none');
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off','Name','Deblurring','NumberTitle','off');
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');
load LALA
imshow(I);% Afficher l'image 
title('Image before deblurring'); 
axis off; 
handles.ImgPret=I; 

choix1 = uicontrol ( MainWindow , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( MainWindow , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

GoDeblurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoDeblurButton,'Callback',@Defloute1);

Enregistrer2Button = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Save' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Enregistrer2Button,'Enable','off')
set(Enregistrer2Button,'Callback',@Enregistrer2);

handles = guihandles(MainWindow);
guidata(hObject,handles)



function DeblurFunction2(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse Enregistrer2Button
MainWindow = figure('color',[1 0 0]); 
set(MainWindow,'MenuBar','none');
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off', 'Name','Deblurring','NumberTitle','off');
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load BlurredImage
imshow(L);% Afficher l'image 
title('Image before deblurring');  
axis off; 
handles.ImgPret=L; 



choix1 = uicontrol ( MainWindow , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( MainWindow , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

GoDeblurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoDeblurButton,'Callback',@Defloute2);

Enregistrer2Button = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'save' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Enregistrer2Button,'Enable','off')
set(Enregistrer2Button,'Callback',@Enregistrer2);

handles = guihandles(MainWindow);
guidata(hObject,handles) 

function GoBlurFunction(hObject, eventdata, handles)  
global Saisie1 Saisie2 DeblurButton2 Enregistrer1Button 
angle = str2double(get(Saisie1,'String'));
length = str2double(get(Saisie2,'String'));
load LALA;
L = blur(I, length, angle);
save('BlurredImage','L')
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
imshow(L)
title('artificially blurred image');
set(Enregistrer1Button,'Enable','on');
set(DeblurButton2,'Enable','on');


function CBchoix1(hObject, eventdata, handles)  
global choix1 SaisieVitesse
if get(choix1,'Value') == [2]
    set(SaisieVitesse,'Enable','on' );
end

function Defloute1(hObject, eventdata, handles)  
global Enregistrer2Button
load Lala;
I = compression(I);
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
title('Deblurring image');
axis off; 
%I = deblur(I,1);
imshow(I,'parent',axe1);
Final = I;
save('DeblurImage','Final')
set(Enregistrer2Button,'Enable','on');
%guidata(hObject,handles) 

function Defloute2(hObject, eventdata, handles)  
global Enregistrer2Button
load BlurredImage ;
L = compression(L);
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
title('Deblurring image'); 
axis off; 
%L = deblur(L,1);
Imshow(L, 'parent', axe1);
Final = L;
save('DeblurImage','Final')
set(Enregistrer2Button,'Enable','on');
%guidata(hObject,handles) 

function Enregistrer1(hObject, eventdata, handles)  
%% attention code trouv� sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
load BlurredImage;
[filename,pathname] = uiputfile('*.png','Save Workspace as'); %Dans quel format le mettre ? 
chemin=[pathname filename]; 
if isequal(filename,0)
    %annulation ou fermeture de la fenetre 'browser'
    disp('User selected Cancel')
else
  imwrite(L, chemin); 
end

function Enregistrer2(hObject, eventdata, handles)  
%% attention code trouv� sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
load DeblurImage;
[filename,pathname] = uiputfile('*.png','Save Workspace as'); %Dans quel format le mettre ? 
chemin=[pathname filename]; 
if isequal(filename,0)
    %annulation ou fermeture de la fenetre 'browser'
    disp('User selected Cancel')
else
  imwrite(Final, chemin); 
end