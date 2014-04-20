function interface2
global MainWindow 

MainWindow = figure('color',[0 1 0]); %vert
set(MainWindow, 'Units', 'Normalized', 'Position', [0.3 0.2 0.5 0.7], 'Resize', 'off','Name','Deblur program','NumberTitle','off');
movegui(MainWindow,'center')

%% menu 
set(MainWindow,'MenuBar','none');
menu1 = uimenu(MainWindow, 'label', 'Case');
smenu1 = uimenu(menu1,'label', 'Train', 'callback', @GUITrain);
smenu2 = uimenu(menu1, 'label', 'Camera video', 'callback', @GUICameravideo);

