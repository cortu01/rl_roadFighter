function [ viewableGridMap, relativeAgentLocation ] = ...
    setCurrentViewableGridMap( testGridMap, agentLocation, blockSize )
%SETCURRENTVIEWABLEGRIDMAP Assuming an agent can only see $blockSize$
%squares ahead (including his current square), this produces a GridMap
%object within that area. The column coordinate is maintained, but the
%value of the row coordinate is set at $blockSize$, given that the row
%coordinate's domain is redefined at $[1, blockSize]$.
    
  
        
    highestRow = agentLocation(1)-blockSize+1 ;
    lowestRow = agentLocation(1) ;
    agentRowPositioning = blockSize ;
    
    
    if highestRow < 1
        
        highestRow = 1 ;
        lowestRow  = blockSize ;
        agentRowPositioning = agentLocation(1) ;
    
    end % if we reached the top of the screen.
        
    viewableGridMap = ...
        GridMap( testGridMap.Grid( highestRow:lowestRow, : ), ...
        [ agentRowPositioning , agentLocation(2)], 15*1/( (25^2)/36 )  ) ;
    
    viewableGridMap.CarLocations = testGridMap.CarLocations( ...
        highestRow:lowestRow, : ) ;
    
    viewableGridMap.RewardFunction = testGridMap.RewardFunction( ...
        highestRow:lowestRow, : ) ;
    
    relativeAgentLocation = [ agentRowPositioning, agentLocation(2) ];
    
end

