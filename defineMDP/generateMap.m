function [ MDP ] = generateMap( ...
    roadBasisGridMaps, n_blocks, blockSize, noCarOnRowProbability, ...
    probabilityOfUniformlyRandomDirectionTaken, rewards)
%GENERATEMAP Ouputs an MDP representing a new episode of Road Fighter


tempGrid = [ roadBasisGridMaps( randi(8) ).Grid; ...
             roadBasisGridMaps( randi(8) ).Grid; ...
             roadBasisGridMaps( randi(8) ).Grid; ...
             roadBasisGridMaps( randi(8) ).Grid; ...
             roadBasisGridMaps( randi(8) ).Grid ] ;

tempStart = [ n_blocks * blockSize, randi(blockSize) ] ;

tempMarkerRescaleFactor = 1/( (25^2)/36 ) ;

MDP = GridMap( tempGrid, tempStart, tempMarkerRescaleFactor, ...
    probabilityOfUniformlyRandomDirectionTaken) ;

% Appending a matrix (same size size as the grid) with the locations of 
% cars:
MDP.CarLocations = ...
    populateWithCars( MDP.Grid, noCarOnRowProbability );


% Appending the reward function (depends on next state and, only for 
% terminal states, on the current state):
MDP.RewardFunction = generateRewardFunction( MDP, rewards ) ;

end

