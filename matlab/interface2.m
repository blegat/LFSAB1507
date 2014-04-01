function interface2
global Button2 Button3 

fig1 = figure('color',[0 1 0]); %vert
set(fig1, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
movegui(fig1,'center')

%% menu 
set(fig1,'MenuBar','none');
menu1 = uimenu(fig1, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', 'methode_normale');
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', 'methode_cameravideo');


%% Création des boutons

Button1 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Charger' , 'fontsize' , 15, 'position', [250,500,150,30] );
set(Button1,'Callback',@B1);

Button2 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Flouter artificiellement' , 'fontsize' , 15, 'position', [120,100,200,30] );
set(Button2,'Enable','off')
set(Button2,'Callback',@B2);

Button3 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Déflouter' , 'fontsize' , 15, 'position', [400,100,150,30] );
set(Button3,'Enable','off')
set(Button3,'Callback',@B31);


%%

axe1 = axes('units', 'pixels', 'position', [190,200, 300, 225], 'tag','axes1');

% Stockage des identifiants utiles
handles = guihandles(fig1);
guidata(fig1,handles)

function B1(hObject, eventdata, handles)  
%% attention code trouvé sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab
global Button2 Button3 a
a = 0;
nomfichier=[]; 
[filename,pathname] = uigetfile({'*.jpg';'*.tiff';'*.bmp';'*.png'},'File Selector');% recupere le 
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
set(Button2,'Enable','on');
set(Button3,'Enable','on');
guidata(hObject,handles) 

function B2(hObject, eventdata, handles)  
global Saisie1 Saisie2 Button23 Button22 

fig1 = figure('color',[1 1 0]); 
set(fig1, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load LALA;
imshow(I);% Afficher l'image 
title('Image originelle'); 
axis off; 
handles.ImgPret=I; 

Saisie1 = uicontrol( fig1 , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.8,0.2,0.05], 'Max' , 1 , 'string' , '0' );
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Angle de floutage');

Saisie2 = uicontrol( fig1 , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0');
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Longueur de floutage');

Button1 = uicontrol( fig1 , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(Button1,'Callback',@B21);

Button22 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [100,40,200,30] );
set(Button22,'Enable','off')
set(Button22,'Callback',@B2);

Button23 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Déflouter image obtenue' , 'fontsize' , 15, 'position', [380,40,280,30] );
set(Button23,'Enable','off')
set(Button23,'Callback',@B32);

handles = guihandles(fig1);
guidata(hObject,handles) 

function B31(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse 
fig1 = figure('color',[1 0 0]); 
set(fig1, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load LALA
imshow(I);% Afficher l'image 
title('Image de départ du défloutage'); 
axis off; 
handles.ImgPret=I; 

choix1 = uicontrol ( fig1 , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( fig1 , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

Button1 = uicontrol( fig1 , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(Button1,'Callback',@B21);

Button32 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Button32,'Enable','off')
%set(Button32,'Callback',@B3);

handles = guihandles(fig1);
guidata(hObject,handles)



function B32(hObject, eventdata, handles)  
% modifier pour a
global choix1 SaisieVitesse 
fig1 = figure('color',[1 0 0]); 
set(fig1, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off' );
axe1 = axes('units', 'Normalized', 'position', [0.09,0.61, 0.3, 0.3], 'tag','axes1');

load BlurredImage
imshow(L);% Afficher l'image 
title('Image de départ du défloutage');  
axis off; 
handles.ImgPret=L; 



choix1 = uicontrol ( fig1 , 'Style' , 'popup' , 'String' , 'non|oui' , 'units','Normalized', 'position', [0.605,0.8,0.2,0.05], 'Callback',@CBchoix1);
get(choix1)
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.8,0.2,0.05],'string','Vitesse du train connue ?');

SaisieVitesse = uicontrol( fig1 , 'style' ,'edit' ,'units', 'Normalized', 'position', [0.60,0.7,0.2,0.05], 'Max' , 1 , 'string' , '0', 'Enable','off' );
uicontrol(fig1,'style',' text','units', 'Normalized','position',[0.40,0.7,0.2,0.05],'string','Si oui, vitesse:');

Button1 = uicontrol( fig1 , 'style' , 'pushbutton' ,'units', 'Normalized','string' , 'Go !' , 'fontsize' , 15, 'position', [0.80,0.75,0.2,0.05] );
set(Button1,'Callback',@Defloute1);

Button32 = uicontrol( fig1 , 'style' , 'pushbutton' ,'string' , 'Enregistrer image' , 'fontsize' , 15, 'position', [240,40,200,30] );
set(Button32,'Enable','off')
%set(Button32,'Callback',@B3);

handles = guihandles(fig1);
guidata(hObject,handles) 

function B21(hObject, eventdata, handles)  
global Saisie1 Saisie2 Button23 Button22 
angle = str2double(get(Saisie1,'String'));
length = str2double(get(Saisie2,'String'));
load LALA;
L = blur(I, length, angle);
save('BlurredImage','L')
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
imshow(L)
title('Image floutée artificiellement');
%set(Button22,'Enable','on');
set(Button23,'Enable','on');


function CBchoix1(hObject, eventdata, handles)  
global choix1 SaisieVitesse
if get(choix1,'Value') == [2]
    set(SaisieVitesse,'Enable','on' );
end

function Defloute1(hObject, eventdata, handles)  

load BlurredImage;
L = deblur(L);
axe1 = axes('units', 'pixels', 'position', [200,80, 300, 225], 'tag','axes1');
imshow(L);
title('Image défloutée'); 
axis off; 











