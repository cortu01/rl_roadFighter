function [] = printGrid (grid, axes, mesh)
%    
[r,c] = size(grid);                          %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,grid);           %# Plot the image
colormap(flipud(colorcube));                      %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal
set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
if nargin < 2 || axes == 0
    showaxes
end

if nargin < 3
    mesh = 0;
end % if no mesh

if mesh
    set(gca,'XTick', 1:c)
    set(gca,'YTick', 1:r)
end % if we want a mesh printed

set(gca,'LooseInset',get(gca,'TightInset'))