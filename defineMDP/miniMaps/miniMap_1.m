function [gridMap] = miniMap_1 ( size )
% Road basis image 1


if nargin < 1
    size = 5;
end % if no size given

% frame
grid = zeros(size, size) ;

% start location (for when necessary)
start = [size, round(size/2)] ;

markerRescaleFactor = 15* 1/( (25^2)/36 ) ;

gridMap = GridMap(grid, start, markerRescaleFactor) ;