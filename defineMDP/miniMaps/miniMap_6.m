function [gridMap] = miniMap_6 ( size )
% Road basis image 6

if nargin < 1
    size = 5;
end % if no size given

% frame
grid = zeros(size, size) ;

% unpaved lines
grid(1:size, 1:2) = 1;
grid(1:size, size-1:size) = 1;

% start location (for when necessary)
start = [size, round(size/2)] ;

markerRescaleFactor = 15* 1/( (25^2)/36 ) ;

gridMap = GridMap(grid, start, markerRescaleFactor) ;