function [gridMap] = miniMap_5 ( size )
% Road basis image 5

if nargin < 1
    size = 5;
end % if no size given

% frame
grid = zeros(size, size) ;

% unpaved lines
grid(1:size, 1) = 1;
grid(1:size, size-1:size) = 1;

markerRescaleFactor = 15* 1/( (25^2)/36 ) ;

% start location (for when necessary)
start = [size, round(size/2)] ;

gridMap = GridMap(grid, start, markerRescaleFactor) ;