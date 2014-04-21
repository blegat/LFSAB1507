function varargout = Interface(varargin)
% INTERFACE MATLAB code for Interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface

% Last Modified by GUIDE v2.5 04-Mar-2014 13:41:24

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Interface is made visible.
function Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interface (see VARARGIN)

% Choose default command line output for Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)  
%% attention code trouvï¿½ sur un forum http://www.commentcamarche.net/forum/affich-17005255-ouverture-d-un-dossier-d-image-via-gui-matlab

axes(handles.axes1) 
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
guidata(hObject,handles)






% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load LALA;
%image(I)
%load fille;
% n = size(I,1);
% m = size(I,2);
% k = 3;
% psf = ones(1,k) / k;
% A = spdiags(ones(n,k) / k, -k+1:0, n, n);
% B = spdiags(ones(m,k) / k, -k+1:0, m, m)';
% H = kron(B', A);
% save = 2; % 1: save, 2: just show
% tester(I, psf, A, @(img) img, 'nonoise',save);
% tester(I, psf, A, @(img) imnoise(img/255, 'gaussian',0,0.001)*255, 'noise-g10',save);
% tester(I, psf, A, @(img) imnoise(img/255, 'poisson')*255, 'noise-poisson',save);
size(I)
axes(handles.axes2)
L = blur(I, 40, 30);
save('BlurredImage','L')
imshow(L);
title('Image floutée'); 
axis off; 






% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load BlurredImage;
axes(handles.axes3)
L = deblur(L);
imshow(L);
title('Image défloutée'); 
axis off; 



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
