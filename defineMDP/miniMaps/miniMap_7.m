function [gridMap] = miniMap_7 ( size )
% Road basis image 7

if nargin < 1
    size = 5;
end % if no size given

% frame
grid = zeros(size, size) ;

% unpaved lines
grid(1, 1:size-2) = 1;
grid(2, 1:size-3) = 1;
grid(3, 1:size-4) = 1;

grid(size-2, size) = 1;
grid(size-1, size-1:size) = 1;
grid(  size, size-2:size) = 1;

% start location (for when necessary)
start = [size, round(size/2)] ;

markerRescaleFactor = 15* 1/( (25^2)/36 ) ;

gridMap = GridMap(grid, start, markerRescaleFactor) ;