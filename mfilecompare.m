function MFC = mfilecompare(chunksize)
%MFILECOMPARE([CHUNKSIZE])
%
% The function FILECOMPARE compares all text files (e.g. m-files) in a selectable directory for overlap of content.
% It displays the overlap of any two files with respect to total text, code only or comments only (selectable in popupmenu)
% as well as some basic descriptive information. Any file can easily be opened (for further control) in the editor 
% by clicking on the respective point in the display.
% The method employed for computation of overlap scans all files for identical text passages of a given CHUNKSIZE (default: CHUNKSIZE = 8).

% I made some cosmetic edits to this file to work better with the files
% downloaded from Mathworks Grader. Instead of the filenames, y axis now
% shows the student name. This assumes the file name will be in the form
% 'name_surname_maildomain_mailpostfix_filenum'. I marked the changes I
% made with '% Umur' revert back to the original if this causes problems
clear global
global MFC
if nargin < 1
    chunksize = 10;
end
MFC.wdir = uigetdir;
if MFC.wdir == 0    %Cancel
    return;
end
MFC.files = dir(MFC.wdir);
MFC.files = MFC.files(~[MFC.files.isdir]);
MFC.nFiles = length(MFC.files);
if MFC.nFiles < 2
    display('The directory has to contain 2 files at minimum!')
    return;
end
% Load and preprocess file data
MFC.filenames = {};
MFC.displaynames = {}; % Umur
for iFile = 1:MFC.nFiles
    mfinfo(iFile) = mfileread(fullfile(MFC.wdir, MFC.files(iFile).name));
    MFC.codeN(iFile) = length(mfinfo(iFile).code);
    MFC.commN(iFile) = length(mfinfo(iFile).comment);
    MFC.filenames(iFile) = {sprintf('%s - %3.0f',MFC.files(iFile).name,iFile)};
    iUS = strfind(MFC.filenames{iFile},'_'); % Umur
    iDash = strfind(MFC.filenames{iFile},'-');
    MFC.displaynames{iFile} = MFC.filenames{iFile}([1:iUS(2)-1, iDash+1:end]); % Umur
    MFC.displaynames{iFile}(iUS(1)) = ' '; % Umur
end
% Computation of overlap/similarity
for iFile = 1:MFC.nFiles
    for jFile = 1:MFC.nFiles
        if iFile ~= jFile
            MFC.overlap.text(iFile, jFile) = textcompare(mfinfo(iFile).text, mfinfo(jFile).text, chunksize);
            MFC.overlap.code(iFile, jFile) = textcompare(mfinfo(iFile).code, mfinfo(jFile).code, chunksize);
            MFC.overlap.comment(iFile, jFile) = textcompare(mfinfo(iFile).comment, mfinfo(jFile).comment, chunksize);
        else
            MFC.overlap.text(iFile, jFile) = 1;
            MFC.overlap.code(iFile, jFile) = 1;
            MFC.overlap.comment(iFile, jFile) = 1;
        end
    end
end
% Display results
MFC.txttype = 'text';
figure('Units','normalized','Position',[.1 .3 .8 .4], 'NumberTitle','off', 'MenuBar','none', 'Name',['Filecompare: ',MFC.wdir],'WindowButtonMotionFcn',@show_xy);
MFC.ax1 = axes('Units','normalized','Position',[.2 .12 .55 .8]);
imagesc(MFC.overlap.text','ButtonDownFcn',@open_xy);
colormap(gray);
% set(gca, 'CLim',[0, 1],'XTick',1:MFC.nFiles,'YTick',1:MFC.nFiles,'XTickLabel',1:MFC.nFiles,'YTickLabel',MFC.filenames) % Umur
set(gca, 'CLim',[0, 1],'XTick',1:MFC.nFiles,'YTick',1:MFC.nFiles,'XTickLabel',1:MFC.nFiles,'YTickLabel',MFC.displaynames) % Umur
MFC.ax2 = axes('Units','normalized','Position',[.8 .12 .15 .8]);
hold on;
for iFile = 1:MFC.nFiles
    fill([0 0 MFC.codeN(iFile) MFC.codeN(iFile)], [iFile iFile-1 iFile-1 iFile],[0 0 0],'ButtonDownFcn',@open_x);
    fill([MFC.codeN(iFile) MFC.codeN(iFile) MFC.codeN(iFile)+MFC.commN(iFile) MFC.codeN(iFile)+MFC.commN(iFile)], [iFile iFile-1 iFile-1 iFile],[0 .6 0],'ButtonDownFcn',@open_x);
end
set(gca, 'XLim',[0 max(MFC.codeN+MFC.commN)],'XTick',[0 max(MFC.codeN+MFC.commN)],'YLim',[0 MFC.nFiles],'YTick',(1:MFC.nFiles)-.5, 'YTickLabel',1:MFC.nFiles,'YDir','reverse')
MFC.typepop = uicontrol('Style','popupmenu','Units','normalized','Position',[.05 .02 .1 .04],'String',{'text','code','comment'},'Value',1,'Callback',@plot_type);
MFC.txtfld = uicontrol('Style','text','Units','normalized','Position',[.2 .02 .75 .04]);
function overlap = textcompare(txt0, txt1, chunksize)
% This function computes the overlap of txt0 and txt1. How much of text0 is found in txt1?
% Note that txt0 and txt1 are not fully exchangeable in this procedure
txt0(isspace(txt0)) = ''; %trim filetext
txt1(isspace(txt1)) = ''; %trim filetext
nchunks = floor(length(txt0)/chunksize);
hit = 0;
for ii = 1:nchunks
    chunk = txt0(((ii-1)*chunksize+1):(ii*chunksize));
    if any(strfind(txt1, chunk))
        hit = hit+1;
    end
end
overlap = hit/nchunks;
% Callbacks in response to mouse commands:
function show_xy(scr, event)    % Display overlap-stats of 2 files (selected by mouse-moving in left axis) in text field
global MFC
p1 = get(MFC.ax1,'CurrentPoint');
p1 = round(p1(1,1:2));
p2 = get(MFC.ax2,'CurrentPoint');
p2 = ceil(p2(1,1:2));
if all(p1 > 0) && all(p1 <= length(MFC.files))
    fname1 = MFC.files(p1(1)).name;
    fname2 = MFC.files(p1(2)).name;
    fname1_short = fname1(1:min(16,length(fname1)));
    fname2_short = fname2(1:min(16,length(fname2)));
    MFC.info_txt = sprintf('File %d (%s) contains %5.2f%% of file %d (%s)', p1(2), fname2_short, MFC.overlap.(MFC.txttype)(p1(1),p1(2))*100, p1(1), fname1_short);
    set(MFC.txtfld,'String', MFC.info_txt);
    
elseif all(p2 > 0) && p2(1) <= max(MFC.codeN+MFC.commN) && p2(2) <= length(MFC.files) 
    MFC.info_txt = sprintf('File %d contains %5.0f chars of Code and %5.0f chars of Comments', p2(2), MFC.codeN(p2(2)), MFC.commN(p2(2)));
    set(MFC.txtfld,'String', MFC.info_txt);
    
else
     set(MFC.txtfld,'String', '');
end
function open_xy(scr, event)    % Open 2 files (selected by clicking in left axis) in editor
global MFC
p = get(gca,'CurrentPoint');
p = round(p(1,1:2));
edit(fullfile(MFC.wdir, MFC.files(p(2)).name))
edit(fullfile(MFC.wdir, MFC.files(p(1)).name))
disp(MFC.info_txt);
function open_x(scr, event)    % Open 1 file (selected by clicking in right axes) in editor
global MFC
p = get(gca,'CurrentPoint');
p = round(p(1,1:2));
edit(fullfile(MFC.wdir, MFC.files(p(2)).name))
disp(MFC.info_txt);
function plot_type(scr, event)  % Update overlap-plot according to selected texttype (text, code, comment)
global MFC
txttype_idx =  get(MFC.typepop,'Value');
txttype_txt = get(MFC.typepop,'String');
MFC.txttype = txttype_txt{txttype_idx};
axes(MFC.ax1)
imagesc(MFC.overlap.(MFC.txttype)','ButtonDownFcn',@open_xy);
colormap(gray);
set(gca, 'CLim',[0, 1],'XTick',1:MFC.nFiles,'YTick',1:MFC.nFiles,'XTickLabel',1:MFC.nFiles,'YTickLabel',MFC.filenames)


% Copyright (c) 2010, Mathias Benedek
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

