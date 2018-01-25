% This script will refresh the map, printing the grid of the $currentMap$ 
% (which must be a GridMap object), the agent's curent location, and
% obstacle cars (if the map has been populated with them).

% Print grid:
printGrid(currentMap.Grid, 0, 1)

% Hold figure:
hold

% Print agent location:
printAgentLocation( currentMap, 1, agentLocation )

% Print cars:
printCars

% Print legend:
legend( { 'Your Car'; 'Other Cars' }, 'Location','northeastoutside' ) ;

% Print agent location (ignore the repetition, just a visual hack):
printAgentLocation( currentMap, 1, agentLocation )

% Release figure:
hold