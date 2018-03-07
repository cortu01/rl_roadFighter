% This script will refresh the map and print out the starting location and 
% trajectory of your agent so far, along with any obstacle cars.
% This is meant to be used with a complete test GridMap $currentMap$, for 
% the purpose of visualizing agent behaviour.

% Requires:
%currentMap

% Print grid:
printGrid(currentMap.Grid, 0, 1)

% Hold figure:
hold

% Print agent's current location:
printAgentLocation( currentMap, 1, agentLocation )

% Print cars:
printCars

if currentTimeStep > 1
    % Print agent trajectory so far:
    
    printAgentLocation( currentMap, 1, ...
        agentMovementHistory(1:currentTimeStep, :), ...-1
        currentMap.MarkerRescaleFactor, 'o' )
    
end % if currentTimeStep > 1

% Print agent starting location:
printAgentLocation( currentMap, 1, startingLocation, ...
    currentMap.MarkerRescaleFactor, 'd' ) ;

% Print legend:
legend( { 'Your Car'; 'Other Cars' }, 'Location','northeastoutside' ) ;

% Release figure:
hold