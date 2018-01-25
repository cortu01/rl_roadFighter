function [ agentRewardSignal, currentAgentLocation, nextTimeStep, ...
    agentMovementHistory ] = ...
    actionMoveAgent( agentCommand, currentAgentLocation, GridMap, ...
    currentTimeStep, agentMovementHistory, ...
    probabilityOfUniformlyRandomDirectionTaken )
%ACTIONMOVEAGENT This function takes as input the current agent locations,  
%and the given move action command (as well as the $GridMap$ object  
%describing the world). It executes the move, correcting in case the agent 
%were to end outside of the grid, and returns the agent's new location, as 
%well as the reward signal experienced (depends on the next state).
%
% Optional input arguments do bookeeping for the $currentTimeStep$ and
% $moveHistory$.
           
    if randomWeightedSelect( ...
            [ 1 - probabilityOfUniformlyRandomDirectionTaken, ...
            probabilityOfUniformlyRandomDirectionTaken ] ) - 1 %#ok<BDLOG>
        
        agentCommand = randi(3) ;
        
    end
    
    currentAgentLocation = ...
        move( agentCommand, currentAgentLocation, GridMap.Grid ) ;
    
    agentRewardSignal = GridMap.RewardFunction( ...
        currentAgentLocation(1), currentAgentLocation(2) ) ;
    
    if nargin > 3
        
        nextTimeStep = currentTimeStep + 1;
        
        if nargin > 4
            agentMovementHistory(nextTimeStep + 1, :) = ...
                currentAgentLocation ;
        end % if we were given the complete history of moves.
        
    end % if we were given the current time step.
    
end % function actionMoveAgent
    
function [ nextLocation ] = ...
    move( actionIdentifier, currentLocation, grid )
%
    nextLocation = zeros(1, 2) ;
    
    gridSize = size(grid) ;
    
    if actionIdentifier == 1 % UP_LEFT
        
        nextLocation(1) = currentLocation(1) - 1 ;
        nextLocation(2) = currentLocation(2) - 1 ;
        
    elseif actionIdentifier == 2 % UP
    
        nextLocation(1) = currentLocation(1) - 1 ;
        nextLocation(2) = currentLocation(2) ;
        
    elseif actionIdentifier == 3 % UP_RIGHT
            
        nextLocation(1) = currentLocation(1) - 1 ;
        nextLocation(2) = currentLocation(2) + 1 ;
        
    else % action not identified
        
        nextLocation = currentLocation;
        disp('ERROR: The action command was not understood!')
        
    end
    
    if nextLocation(1) < 1
        %nextLocation = 1 ;
        nextLocation = currentLocation;
    end
    
    if nextLocation(2) > gridSize(2)
        nextLocation(2) = gridSize(2) ;
    end
    
    if nextLocation(2) < 1 ;
        nextLocation(2) = 1 ;
    end
    
end % function move