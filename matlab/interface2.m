function interface2
global MainWindow 

MainWindow = figure('color',[0 1 0]); %vert
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
movegui(MainWindow,'center')

%% menu 
set(MainWindow,'MenuBar','none');
menu1 = uimenu(MainWindow, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', @methode_normale);
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', @methode_cameravideo);



% CAS DU TRAIN


%% Création des boutons
function methode_normale(hObject, eventdata, handles)  

global MainWindow ArtificialBlurButton DeblurButton1
UploadButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Charger' , 'fontsize' , 15, 'position', [250,500,150,30] );
set(UploadButton,'Callback',@LoadFunction);

ArtificialBlurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Flouter artificiellement' , 'fontsize' , 15, 'position', [120,100,200,30] );
set(ArtificialBlurButton,'Enable','off')
set(ArtificialBlurButton,'Callback',@ArtificialBlurFunction);

DeblurButton1 = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Déflouter' , 'fontsize' , 15, 'position', [400,100,150,30] );
set(DeblurButton1,'Enable','off')
set(DeblurButton1,'Callback',@DeblurFunction1);


%%

axe1 = axes('units', 'pixels', 'position', [190,200, 300, 225], 'tag','axes1');
axis off; 
% Stockage des identifiants utiles
handles = guihandles(MainWindow);
guidata(MainWindow,handles)

function LoadFunction(hObject, eventdata, handles)  
%% attention code trouvé sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
global ArtificialBlurButton DeblurButton1 a
a = 0;
nomfichier=[]; 
[filename,pathname] = uigetfile({'*.png';'*.jpg';'*.tiff';'*.bmp'},'File Selector');% recupere le 
%chemin du rï¿½pertoire et le nom du fichier 
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
    title('Image originelle');
    axis off;
    handles.ImgPret=I;
end
set(ArtificialBlurButton,'Enable','on');
set(DeblurButton1,'Enable','on');
guidata(hObject,handles) 

function ArtificialBlurFunction(hObject, eventdata, handles)  
global Saisie1 Saisie2 DeblurButton2 Button22 

ArtificialBlur = figure('color',[1 1 0]); 
set(ArtificialBlur, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load LALA;
imshow(I);% Afficher l'image 
title('Image originelle'); 
axis off; 
handles.ImgPret=I; 

Saisie1 = uicontrol( ArtificialBlur , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.8,0.2,0.05], 'Max' , 1 , 'string' , '0' );
uicontrol(ArtificialBlur,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Angle de floutage');

Saisie2 = uicontrol( ArtificialBlur, 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0');
uicontrol(ArtificialBlur,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Longueur de floutage');

GoBlurButton = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoBlurButton,'Callback',@GoBlurFunction);

Button22 = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [100,40,200,30] );
set(Button22,'Enable','on')
set(Button22,'Callback',@Enregistrer1);

DeblurButton2 = uicontrol( ArtificialBlur , 'style' , 'pushbutton' ,'string' , 'Déflouter image obtenue' , 'fontsize' , 15, 'position', [380,40,280,30] );
set(DeblurButton2,'Enable','off')
set(DeblurButton2,'Callback',@DeblurFunction2);

handles = guihandles(ArtificialBlur);
guidata(hObject,handles) 

function DeblurFunction1(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse 
MainWindow = figure('color',[1 0 0]); 
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');
load LALA
imshow(I);% Afficher l'image 
title('Image de départ du défloutage'); 
axis off; 
handles.ImgPret=I; 

choix1 = uicontrol ( MainWindow , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( MainWindow , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

GoDeblurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoDeblurButton,'Callback',@Defloute1);

Button32 = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Button32,'Enable','on')
set(Button32,'Callback',@Enregistrer2);

handles = guihandles(MainWindow);
guidata(hObject,handles)



function DeblurFunction2(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse 
MainWindow = figure('color',[1 0 0]); 
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load BlurredImage
imshow(L);% Afficher l'image 
title('Image de départ du défloutage');  
axis off; 
handles.ImgPret=L; 



choix1 = uicontrol ( MainWindow , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( MainWindow , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(MainWindow,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

GoDeblurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(GoDeblurButton,'Callback',@Defloute2);

Button32 = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Button32,'Enable','on')
set(Button32,'Callback',@Enregistrer2);

handles = guihandles(MainWindow);
guidata(hObject,handles) 

function GoBlurFunction(hObject, eventdata, handles)  
global Saisie1 Saisie2 DeblurButton2 Button22 
angle = str2double(get(Saisie1,'String'));
length = str2double(get(Saisie2,'String'));
load LALA;
L = blur(I, length, angle);
save('BlurredImage','L')
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
imshow(L)
title('Image floutée artificiellement');
%set(Button22,'Enable','on');
set(DeblurButton2,'Enable','on');


function CBchoix1(hObject, eventdata, handles)  
global choix1 SaisieVitesse
if get(choix1,'Value') == [2]
    set(SaisieVitesse,'Enable','on' );
end

function Defloute1(hObject, eventdata, handles)  

load Lala;
I = compression(I);
Final = deblur(I,1);
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
imshow(I,'parent',axe1);
title('Image défloutée'); 
save('DeblurImage','Final')
%axis off; 
%guidata(hObject,handles) 

function Defloute2(hObject, eventdata, handles)  

load BlurredImage ;
L = compression(L);
Final = deblur(L,1);
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
Imshow(L, 'parent', axe1);
title('Image défloutée'); 
save('DeblurImage','Final')
%axis off; 
%guidata(hObject,handles) 

function Enregistrer1(hObject, eventdata, handles)  
%% attention code trouvé sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
load BlurredImage;
[filename,pathname] = uiputfile('*.png','Save Workspace as'); %Dans quel format le mettre ? 
chemin=[pathname filename]; 
imwrite(L, chemin); 

function Enregistrer2(hObject, eventdata, handles)  
%% attention code trouvé sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
load DeblurImage;
[filename,pathname] = uiputfile('*.png','Save Workspace as'); %Dans quel format le mettre ? 
chemin=[pathname filename]; 
imwrite(Final, chemin); 




% CAS DE LA CAMERA



function methode_cameravideo(hObject, eventdata, handles)  

global MainWindow 
UploadButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Charger' , 'fontsize' , 15, 'position', [250,500,150,30] );
set(UploadButton,'Callback',@LoadFunction);

ArtificialBlurButton = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Flouter artificiellement' , 'fontsize' , 15, 'position', [120,100,200,30] );
set(ArtificialBlurButton,'Enable','off')
set(ArtificialBlurButton,'Callback',@ArtificialBlurFunction);

DeblurButton1 = uicontrol( MainWindow , 'style' , 'pushbutton' ,'string' , 'Déflouter' , 'fontsize' , 15, 'position', [400,100,150,30] );
set(DeblurButton1,'Enable','off')
set(DeblurButton1,'Callback',@DeblurFunction1);


%%

axe1 = axes('units', 'pixels', 'position', [190,200, 300, 225], 'tag','axes1');

% Stockage des identifiants utiles
handles = guihandles(MainWindow);
guidata(MainWindow,handles)

