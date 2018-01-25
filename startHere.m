% Initializes the map problem. Use this as an initial guide for how to
% store agent states and trajectories. Take care when renaming variables
% since these might be referenced by other srcipts.
%
% This is not set to go, but most book-keeping procedures are shown. It is
% up to you to determine how you want to go about structuring your code. 
% For example, in the end of PROBLEM SPECIFICATION I generate CarLocations 
% and a RewardFunction. You would need to do likewise each time you learn 
% or test on a new map.

%% ACTION CONSTANTS:
UP_LEFT = 1 ;
UP = 2 ;
UP_RIGHT = 3 ;

%% PROBLEM SPECIFICATION:

blockSize = 5 ; % This will function as the dimension of the road basis 
% images (blockSize x blockSize), as well as the view range, in rows of
% your car (including the current row).

n_MiniMapBlocksPerMap = 20 ; % determines the size of the test instance. 
% Test instances are essentially road bases stacked one on top of the
% other.

discountFactor_gamma = 0.9 ; % if needed

rewards = [ 1, -1, -20 ] ; % the rewards are state-based. In order: paved 
% square, non-paved square, and car collision. Agents can occupy the same
% square as another car, and the collision does not end the instance, but
% there is a significant reward penalty.

probabilityOfUniformlyRandomDirectionTaken = 0.15 ; % Noisy driver actions.
% An action will not always have the desired effect. This is the
% probability that the selected action is ignored and the car uniformly 
% transitions into one of the above 3 states. If one of those states would 
% be outside the map, the next state will be the one above the current one.

noCarOnRowProbability = 0.8 ; % the probability that there is no car 
% spawned for each row

roadBasisGridMaps = generateMiniMaps ; % Generates the 8 road basis grid 
% maps, complete with an initial location for your agent. (Also see the 
% GridMap class).

testGridMap = randomlyCreateATestGridMapFromMiniMapBlocks( ...
   roadBasisGridMaps, n_MiniMapBlocksPerMap, blockSize ) ;

% If you want to see your agents behaviour on some map of your choice, you
% can temporarily comment the above expression and uncomment the
% following lines (editing the indices as you please):
% %->>>>
% tempGrid = [ roadBasisGridMaps(8).Grid; roadBasisGridMaps(7).Grid; ...
%   roadBasisGridMaps(6).Grid; roadBasisGridMaps(5).Grid; ...
%   roadBasisGridMaps(4).Grid; roadBasisGridMaps(3).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(1).Grid; ...
%   roadBasisGridMaps(1).Grid; roadBasisGridMaps(1).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(2).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(2).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(2).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(2).Grid; ...
%   roadBasisGridMaps(2).Grid; roadBasisGridMaps(2).Grid ] ;
% 
% tempStart = [ n_MiniMapBlocksPerMap * blockSize, round(blockSize/2) ] ;
% 
% tempMarkerRescaleFactor = 1/( (25^2)/36 ) ;
% 
% testGridMap = GridMap(tempGrid, tempStart, tempMarkerRescaleFactor) ;
% %<<<<-

currentTimeStep = 0 ;

basisEpsisodeLength = blockSize - 1 ; % The agent moves forward at constant speed and
% the upper row of the map functions as a set of terminal states. So 5 rows
% -> 4 actions.
testEpisodeLength = blockSize*n_MiniMapBlocksPerMap - 1 ;% Similarly for a complete
% scenario created from joining road basis grid maps in a line.

% Coordinates on the map are given as an array [row, col]. So, e.g., to
% access the starting location on the GridMap roadBasisGridMaps(8), you can
% write:
           currentMap = roadBasisGridMaps(8) ;
           agentLocation = currentMap.Start ;
% where agentLocation is now an array [row, col].
%
% currentMap is also the variable that the script refreshScreen attempts to
% access as a GridMap object.

% Appending a matrix (same size size as the grid) with the locations of 
% cars:
testGridMap.CarLocations = ...
    populateWithCars( testGridMap.Grid, noCarOnRowProbability ) ;

% Appending the reward function (depends on next state):
testGridMap.RewardFunction = ...
    generateRewardFunction( testGridMap, rewards ) ;

currentMap = testGridMap ;
agentLocation = currentMap.Start ;

startingLocation = agentLocation ; % Keeping record of initial location.

% If you need to keep track of agent movement history:
%
agentMovementHistory = zeros(testEpisodeLength+1, 2) ;
%
agentMovementHistory(currentTimeStep + 1, :) = agentLocation ;

%% PRINT MAP:
% You can update viewableGridMap in a similar way as below, in order to
% keep track of the current visible area for your car (don't use this with
% road bases since the whole map should be visible at any time in that case
% ): 
viewableGridMap = ...
    setCurrentViewableGridMap( testGridMap, agentLocation, blockSize ) ;
% When printing $viewableGridMap.Grid$ notice that the row numbers no
% longer correspond to the original test map rows. Use $agentLocation(1)$  
% to keep track of your current row in the complete test map.

refreshScreen % See $refreshScreen$ function for details.

%% TEST ACTION TAKING, MOVING WINDOW AND TRAJECTORY PRINTING:
% Just making some arbitrary moves (uniformly random policy), in order to 
% show action taking and trajectory printing: 
%
% You might want to maximise the final figure and it might not be readable
% in, e.g, a laptop screen. Furthermore, there is a small glitch, and the
% figure will flash purple when all the road is paved.

realAgentLocation = agentLocation ; % The location on the test map.

for i = 1:testEpisodeLength
    
    actionTaken = randi(3) ;
    
    [ agentRewardSignal, realAgentLocation, currentTimeStep, ...
        agentMovementHistory ] = ...
        actionMoveAgent( actionTaken, realAgentLocation, testGridMap, ...
        currentTimeStep, agentMovementHistory, ...
        probabilityOfUniformlyRandomDirectionTaken ) ;

    agentRewardSignal
    
    % If you want to view the agents behaviour sequentially, and with a 
    % moving view window, try using $pause(n)$ to pause the screen for $n$
    % seconds between each draw:
       
    [ viewableGridMap, agentLocation ] = setCurrentViewableGridMap( ...
        testGridMap, realAgentLocation, blockSize ); %#ok<NASGU>
    
    currentMap = viewableGridMap ; %#ok<NASGU>
    
    refreshScreen
    
    pause(0.15)
    
end

currentMap = testGridMap ;
agentLocation = realAgentLocation ;

printAgentTrajectory