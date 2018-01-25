function [ testGridMap ] = randomlyCreateATestGridMapFromMiniMapBlocks( ...
    roadBasisGridMaps, n_MiniMapBlocksPerMap, size ) 
%RANDOMLYCREATEATESTGRIDMAPFROMMINIMAPBLOCKS Randomly generates and appends
%$n_MiniMapBlocksPerMap$ road basis grids, in order to generate a complete
%test instance. 
%
%   The start location is defined as the center of the bottom row of the
%   map.
    
    grid = zeros(0, size) ;

    for block = 1:n_MiniMapBlocksPerMap
        
        minMapIndex = randi(8) ;
        
        grid = ...
            [ roadBasisGridMaps(minMapIndex).Grid ; grid ] ; %#ok<AGROW>
        
    end % for each block
    
    start = [ n_MiniMapBlocksPerMap * size, round(size/2) ] ;
    
    markerRescaleFactor = 0.2 * 1/( (25^2)/36 ) ;
    
    testGridMap = GridMap(grid, start, markerRescaleFactor) ;
    
    testGridMap.Size = [ n_MiniMapBlocksPerMap*size, size];
    
end

