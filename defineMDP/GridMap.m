classdef GridMap
%GRIDMAP: Stores data for a 2D grid-map, as well as the agent's start 
%location along with the $CarLocations$ and the $RewardFunction$. The grid 
%is assumed to take values of "0:paved and 1:non-paved".
%
    properties
        Grid
        GridSize
        Start
        MarkerRescaleFactor
        Size
        CarLocations
        RewardFunction
        probabilityOfUniformlyRandomDirectionTaken
        CoordinatesToStateNumberMap
    end % properties
    
    methods
        function GM = GridMap(grid, start, markerRescaleFactor, ...
                probabilityOfUniformlyRandomDirectionTaken)
            if nargin < 3
                markerRescaleFactor = 1 ;
            end
            GM.MarkerRescaleFactor = markerRescaleFactor ;
            GM.Grid = grid ;
            [ GM.Size, ~ ] = size(grid) ;
            GM.GridSize = size(grid) ;
            if nargin > 1
                GM.Start = start ;
            end
            GM.CarLocations = 0 ;
            GM.RewardFunction = 0 ;
            if nargin > 3
                GM.probabilityOfUniformlyRandomDirectionTaken = ...
                    probabilityOfUniformlyRandomDirectionTaken ;
            end % if the probability of a uniformly random transition 
            % happening was given
            GM.CoordinatesToStateNumberMap = zeros( GM.GridSize );
            id = 0;
            for row = 1:GM.GridSize(1)
                for column = 1:GM.GridSize(2)
                    id = id + 1;
                    GM.CoordinatesToStateNumberMap( row, column ) = id;
                end % for each row
            end % for each column
            
        end % GridMap
        
        function [ nextStates, probabilities ] = ...
                getTransitions( obj, state, action )
            % Given a current state and the action taken, this function 
            % returns all possible next states and the probability of
            % transitioning to each one
            %
            % $nextStates$ is a 2-column matrix, where each row
            % corresponds to a potential next [row, column] state 
            % coordinate.
            %
            % $probabilities$ is a 1-column matrix, where each row is the
            % probability of transitioning to the corresponding [row, 
            % column] coordinate in $nextStates$.
            
            transformOutputToStateNumber = 0;
            if length(state) == 1
                state = obj.getCoordinatesFromStateNumber(state)
                transformOutputToStateNumber = 1;
            end % if the state was given by its number rather than its 
            % coordinates            
            
            p = obj.probabilityOfUniformlyRandomDirectionTaken;            
            
            if state(1) == 1 % if the current state is on the top row (an absorbing state)
                % Deterministically transitions back to the same state.
                nextStates = state;
                probabilities = 1;
            elseif state(2) == 1 %if we are on the leftmost side of the road
                nextStates = zeros(2,2);
                probabilities = zeros(2, 1);
                nextStates(1,:) = [ state(1)-1, state(2)  ]; % UP
                nextStates(2,:) = [ state(1)-1, state(2)+1]; % UP_RIGHT
                if action == 1 % UP_LEFT
                    probabilities(1) = 1 - p + 2*p/3;
                    probabilities(2) = p/3;
                elseif action == 2 % UP
                    probabilities(1) = 1 - p + 2*p/3;
                    probabilities(2) = p/3;
                else % if action == 3 % UP_RIGHT
                    probabilities(1) = 2*p/3;
                    probabilities(2) = 1 - p + p/3;
                end % if action
                
            elseif state(2) == obj.GridSize(2) %if we are on the rightmost side of the road
                nextStates = zeros(2,2);
                probabilities = zeros(2, 1);
                nextStates(1,:) = [ state(1)-1, state(2)-1]; % UP_LEFT
                nextStates(2,:) = [ state(1)-1, state(2)  ]; % UP
                if action == 1 % UP_LEFT
                    probabilities(1) = 1 - p + p/3;
                    probabilities(2) = 2*p/3;
                elseif action == 2 % UP
                    probabilities(1) = p/3;
                    probabilities(2) = 1 - p + 2*p/3;
                else % if action == 3 % UP_RIGHT
                    probabilities(1) = p/3;
                    probabilities(2) = 1 - p + 2*p/3;
                end % if action
                
            else %if we can go in any direction
                nextStates = zeros(3,2);
                probabilities = zeros(3, 1);
                nextStates(1,:) = [ state(1)-1, state(2)-1]; % UP_LEFT
                nextStates(2,:) = [ state(1)-1, state(2)  ]; % UP
                nextStates(3,:) = [ state(1)-1, state(2)+1]; % UP_RIGHT
                if action == 1 % UP_LEFT
                    probabilities(1) = 1 - p + p/3;
                    probabilities(2) = p/3;
                    probabilities(3) = p/3;
                elseif action == 2 % UP
                    probabilities(1) = p/3;
                    probabilities(2) = 1 - p + p/3;
                    probabilities(3) = p/3;
                else % if action == 3 % UP_RIGHT
                    probabilities(1) = p/3;
                    probabilities(2) = p/3;
                    probabilities(3) = 1 - p + p/3;
                end % if action
            end
            
            if transformOutputToStateNumber == 1
                %state
                if obj.IS_TERMINAL_STATE( state )
                    nextStates = obj.getStateNumberFromCoordinates(state);
                else % if we are not at a terminal/absorbing state
                    tempNextStates = zeros( length(nextStates), 1 );
                    
                    for next = 1:length(nextStates)
                        tempNextStates(next) = ...
                            obj.getStateNumberFromCoordinates(...
                            nextStates(next, :) );
                    end % for each possible next state
                    
                    nextStates = tempNextStates;  
                end % if we are at a terminal/absorbing state
                
            end % if we were given state input in the form of a state 
            % number, then the output should be given as state numbers too.
            
        end % getTransitions
        
        function [ reward ] = getReward( obj, state, nextState, action )
            % This function returns the reward for transitioning from 
            % $state$ to $nextState$, while taking an $action$.  
            %
            % $state$ and $nextState$ are given as [x, y] ccordinates.
            %
            % $reward$ is a scalar value.
            %
            % This does not check whether the transition is possible. You
            % can call this without the action if you prefer.
            
            if length(state) == 1
                state = obj.getCoordinatesFromStateNumber(state);
            end % if the state was given by its number rather than its 
            % coordinates
            
            if length(nextState) == 1
                nextState = obj.getCoordinatesFromStateNumber(nextState);
            end % if the next state was given by its number rather than its 
            % coordinates
            
            if state(1) == 1 % if the current state is on the top row (an absorbing state)
                reward = 0;
            else
                reward = obj.RewardFunction( nextState(1), nextState(2) );
            end % if state(1) == 1
            
        end % getReward
        
        function [ isTerminal ] = IS_TERMINAL_STATE( obj, state )
            % Returns 1 if $state$ is a terminal/absorbing state, and 0 if 
            % it isn't.
            %
            % $State$ is a [row, column] coordinate.
            if state(1) == 1
                isTerminal = 1;
            else
                isTerminal = 0;
            end % if state(1) == 1
        end % IS_TERMINAL_STATE
        
        function [ coordinates ] = ...
                getCoordinatesFromStateNumber( obj, stateNumber )
            % $stateNumber$ is a scalar from 1 to the number of discrete
            % states in the problem (number of rows X number of columns).
            %
            % $coordinates$ is a 2-column, 1-row, matrix of the form [row,
            % column].
            
            [ coordinates(1), coordinates(2) ] = find( ...
                obj.CoordinatesToStateNumberMap == stateNumber ) ;
            
        end % getCoordinatesFromStateNumber
        
        
        function [ stateNumber ] = ...
                getStateNumberFromCoordinates( obj, coordinates )
            % $stateNumber$ is a scalar from 1 to the number of discrete
            % states in the problem (number of rows X number of columns).
            %
            % $coordinates$ is a 2-column, 1-row, matrix of the form [row,
            % column].
            
            stateNumber = obj.CoordinatesToStateNumberMap( ...
                coordinates(1), coordinates(2) ) ;
            
        end % getStateNumberFromCoordinates
            
        function [ stateFeatures ] = ...
                getStateFeatures( obj, state )
            % There is a real problem with our definition of features.
            % Can you figure it out and maybe use it for the last bonus?
            
            if length(state) == 1
                state = obj.getCoordinatesFromStateNumber(state);
            end % if the state was given by its number rather than its 
            % coordinates 
            
            minRow = state(1) - 4;
            maxRow = state(1) - 1;
            if maxRow < 1
                stateFeatures = zeros(4, 5);
            elseif minRow < 1
                tempMatrix = zeros(4, 5);
                tempMatrix(4-maxRow + 1:4, :) = ...
                    obj.RewardFunction(1:maxRow, :);
                stateFeatures = tempMatrix;
            else      
                stateFeatures = obj.RewardFunction(minRow:maxRow, :);
            end % if  
            
        end % getStateFeatures
        
    end % methods
    
end % classdef