function [ gridMaps ] = generateMiniMaps( )
%GENERATEMAP Creates the 8 Road basis image as given in Fig 2. of Rosman & 
%Ramamoorthy 2010 (the paper referenced in readme.md) Each map is 
%defined by a grid-map, starting and target locations.
%   gridMap is a $GridMap$ object, which has properties:
%           Grid - the map of the world, with 1 indicating non-paved
%           squares. Moving onto a non-paved square results in a negative 
%           reward. Attempting to move diagonally (up-left or up-right) out
%           of the borders of the grid should result in a forward movement
%           (up).
%           
%           Start - the initial coordinates of your agent on the map.
%
    
    for miniMapIndex = 1:8
        
        mapName = strcat( 'miniMap_', int2str(miniMapIndex) ) ;
        
        map_fhandle = str2func( mapName ) ;
        
        gridMap = map_fhandle( ) ;
        
        gridMaps(miniMapIndex) = gridMap ;
        
    end
        
end