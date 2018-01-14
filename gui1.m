function varargout = gui1(varargin)
% modified by Maryam Najafi
% date: Dec 3, 2016

% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 04-Dec-2016 00:19:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
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

% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

% Choose default command line output for gui1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles)
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

cla(handles.axes1,'reset'); 
cla(handles.axes2,'reset'); 
cla(handles.axes3,'reset');
cla(handles.axes4,'reset'); 
cla(handles.axes5,'reset'); 
cla(handles.axes6,'reset');

popup_sel_index = get(handles.popupmenu1, 'Value');
global Pattern
switch popup_sel_index
    case 1
        %% unnormalized spectral clustering
        dataset = 'jain';
        load(dataset);
        k = 2;
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        
        %1. original dataset
        axes(handles.axes1);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; 
        scatter (x(Label == 2), y(Label == 2), 'b');
        title (sprintf('dataset: %s',dataset));
        xlabel ('x'); ylabel('y');
        
        %2. k_means
        axes(handles.axes2);
        [labels_kmeans, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels_kmeans == 1), y(labels_kmeans == 1), 'r'); hold on;
        scatter (x(labels_kmeans == 2), y(labels_kmeans == 2), 'b');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %3. spectral clustering
        axes(handles.axes3);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .2;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        labels_unnormalized = unnormSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_unnormalized == 1), y(labels_unnormalized == 1), 'r'); hold on;
        scatter (x(labels_unnormalized == 2), y(labels_unnormalized == 2), 'b');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% normalized spectral clustering
        %1. original dataset
        axes(handles.axes4);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on;
        scatter (x(Label == 2), y(Label == 2), 'b');
        title (sprintf('dataset: %s',dataset));
        xlabel ('x'); ylabel('y');
        
        %2. k_means
        axes(handles.axes5);
        [labels, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels == 1), y(labels == 1), 'r'); hold on;
        scatter (x(labels == 2), y(labels == 2), 'b');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %3. spectral clustering
        axes(handles.axes6);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        sigma = 2; % the denominator of the Gauss. kernel sim. func.
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .2;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        S = getSimilarityMatrix(Pattern, sigma);
        labels_normalized = normSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_normalized == 1), y(labels_normalized == 1), 'r'); hold on;
        scatter (x(labels_normalized == 2), y(labels_normalized == 2), 'b');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% evaluation
        % 1. k-means clustering
        F = getF1measure(Label, labels_kmeans, k)

        % 2. unnormalized spectral clustering
        F = getF1measure(Label, labels_unnormalized, k)


        % 3. normalized spectral clustering
        F = getF1measure(Label, labels_normalized, k)

        
    case 2
        dataset = 'spiral';
        load(dataset);
        k = 3;
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        %% unnormalized spectral clustering
        %1. original dataset
        axes(handles.axes1);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; 
        scatter (x(Label == 2), y(Label == 2), 'b');
        scatter (x(Label == 3), y(Label == 3), 'g');
        title (sprintf('dataset: %s',dataset));
        xlabel ('x'); ylabel('y');
        
        %2. k_means
        axes(handles.axes2);
        [labels_kmeans, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels_kmeans == 1), y(labels_kmeans == 1), 'r'); hold on;
        scatter (x(labels_kmeans == 2), y(labels_kmeans == 2), 'b'); hold on;
        scatter (x(labels_kmeans == 3), y(labels_kmeans == 3), 'g');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %3. spectral clustering
        hold off; axes(handles.axes3);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .2;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        labels_unnormalized = unnormSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_unnormalized == 1), y(labels_unnormalized == 1), 'r'); hold on;
        scatter (x(labels_unnormalized == 2), y(labels_unnormalized == 2), 'b');
        hold on; scatter (x(labels_unnormalized == 3), y(labels_unnormalized == 3), 'g');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% normalized spectral clustering
        %1. original dataset
        axes(handles.axes4);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; 
        scatter (x(Label == 2), y(Label == 2), 'b');
        scatter (x(Label == 3), y(Label == 3), 'g');
        title (sprintf('dataset: %s',dataset));
        xlabel ('x'); ylabel('y');
        
        %2. k_means
        axes(handles.axes5);
        [labels, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels == 1), y(labels == 1), 'r'); hold on;
        scatter (x(labels == 2), y(labels == 2), 'b'); hold on;
        scatter (x(labels == 3), y(labels == 3), 'g');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %3. spectral clustering
        axes(handles.axes6);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .2;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        S = getSimilarityMatrix(Pattern, sigma);
        labels_normalized = normSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_normalized == 1), y(labels_normalized == 1), 'r'); hold on;
        scatter (x(labels_normalized == 2), y(labels_normalized == 2), 'b'); hold on;
        scatter (x(labels_normalized == 3), y(labels_normalized == 3), 'g');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% evaluation
        % 1. k-means clustering
        F = getF1measure(Label, labels_kmeans, k)

        % 2. unnormalized spectral clustering
        F = getF1measure(Label, labels_unnormalized, k)


        % 3. normalized spectral clustering
        F = getF1measure(Label, labels_normalized, k)
        
    case 3
        dataset = 'twoDonuts';
        load(dataset);
        k = 2;
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        
        %% original dataset
        axes(handles.axes1);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on;
        scatter (x(Label == 2), y(Label == 2), 'b');
        title (sprintf('dataset: %s',dataset));
        
        %% k_means
        axes(handles.axes2);
        [labels_kmeans, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels_kmeans == 1), y(labels_kmeans == 1), 'r'); hold on;
        scatter (x(labels_kmeans == 2), y(labels_kmeans == 2), 'b');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% spectral clustering
        axes(handles.axes3);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .1e-1;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        labels_unnormalized = unnormSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_unnormalized == 1), y(labels_unnormalized == 1), 'r'); hold on;
        scatter (x(labels_unnormalized == 2), y(labels_unnormalized == 2), 'b');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        %% normalized spectral clustering
        axes(handles.axes4);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; scatter (x(Label == 2), y(Label == 2), 'b');
        if k == 3
            hold on; scatter (x(Label == 3), y(Label == 3), 'g');
        end
        title (sprintf('dataset: %s',dataset));
        %% k_means
        axes(handles.axes5);
        [labels, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels == 1), y(labels == 1), 'r'); hold on;
        scatter (x(labels == 2), y(labels == 2), 'b');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% spectral clustering
        axes(handles.axes6);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 2; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .1e-1;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        S = getSimilarityMatrix(Pattern, sigma);
        labels_normalized = normSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_normalized == 1), y(labels_normalized == 1), 'r'); hold on;
        scatter (x(labels_normalized == 2), y(labels_normalized == 2), 'b');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
       
        %% evaluation
        % 1. k-means clustering
        F = getF1measure(Label, labels_kmeans, k)

        % 2. unnormalized spectral clustering
        F = getF1measure(Label, labels_unnormalized, k)


        % 3. normalized spectral clustering
        F = getF1measure(Label, labels_normalized, k)
        
    case 4
        dataset = 'petals';
        load(dataset);
        k = 3;
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        
        %% original dataset
        axes(handles.axes1);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; 
        scatter (x(Label == 2), y(Label == 2), 'b'); hold on; 
        scatter (x(Label == 3), y(Label == 3), 'g');
        title (sprintf('dataset: %s',dataset));
        
        %% k_means
        axes(handles.axes2);
        [labels_kmeans, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels_kmeans == 1), y(labels_kmeans == 1), 'r'); hold on; 
        scatter (x(labels_kmeans == 2), y(labels_kmeans == 2), 'b'); hold on; 
        scatter (x(labels_kmeans == 3), y(labels_kmeans == 3), 'g');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% spectral clustering
        axes(handles.axes3);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 1; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .1;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        labels_unnormalized = unnormSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_unnormalized == 1), y(labels_unnormalized == 1), 'r'); hold on; 
        scatter (x(labels_unnormalized == 2), y(labels_unnormalized == 2), 'b'); hold on; 
        scatter (x(labels_unnormalized == 3), y(labels_unnormalized == 3), 'g');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% normalized spectral clustering
        axes(handles.axes4);
        scatter (x(Label == 1), y(Label == 1), 'r'); hold on; 
        scatter (x(Label == 2), y(Label == 2), 'b'); hold on; 
        scatter (x(Label == 3), y(Label == 3), 'g');
        title (sprintf('dataset: %s',dataset));
        
        %% k_means
        axes(handles.axes5);
        [labels, cc] = kmeans(Pattern, k);
        x = Pattern(:, 1);
        y = Pattern(:, 2);
        scatter (x(labels == 1), y(labels == 1), 'r'); hold on; 
        scatter (x(labels == 2), y(labels == 2), 'b'); hold on; 
        scatter (x(labels == 3), y(labels == 3), 'g');
        title (sprintf('clustering algorithm: K_ means Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');
        
        %% spectral clustering
        axes(handles.axes6);
        if (isempty(str2num(get(handles.edit4, 'string'))))
            sigma = 1; % the denominator of the Gauss. kernel sim. func.
            set(handles.edit4, 'string',sigma);
        else
            sigma = str2num(get(handles.edit4, 'string')); 
        end
        S = getSimilarityMatrix(Pattern, sigma);
        if (isempty(str2num(get(handles.edit1, 'string'))))
            eps = .1;
            set(handles.edit1, 'string',eps);
        else
            eps = str2num(get(handles.edit1, 'string')); 
        end
        if (isempty(str2num(get(handles.edit2, 'string'))))
            k_neighbors = 15;
            set(handles.edit2, 'string',k_neighbors);
        else
            k_neighbors = str2num(get(handles.edit2, 'string')); 
        end
        rb = get(handles.radiobutton2, 'Value');
        if (rb == 1)
            approach = 'eps'; % The 1st approach to construct the sim. graph
        else
            approach = 'mutual_knn'; % The 2nd approach to construct the sim. graph
        end
        
        S = getSimilarityMatrix(Pattern, sigma);
        labels_normalized = normSpecClustering(k, S, approach, eps, k_neighbors);
        
        scatter (x(labels_normalized == 1), y(labels_normalized == 1), 'r'); hold on; 
        scatter (x(labels_normalized == 2), y(labels_normalized == 2), 'b'); hold on; 
        scatter (x(labels_normalized == 3), y(labels_normalized == 3), 'g');
        title (sprintf('clustering algorithm: Spectral Clustering, k: %d',k));
        xlabel ('x'); ylabel('y');

        %% evaluation
        % 1. k-means clustering
        F = getF1measure(Label, labels_kmeans, k)

        % 2. unnormalized spectral clustering
        F = getF1measure(Label, labels_unnormalized, k)


        % 3. normalized spectral clustering
        F = getF1measure(Label, labels_normalized, k)

end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end


set(hObject, 'String', {'Jain dataset', 'Spiral dataset', 'Two donuts dataset', 'Petal dataset'});



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
