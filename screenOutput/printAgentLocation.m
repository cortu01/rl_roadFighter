function [] = printAgentLocation( ...
    gridMap, agentIndex, location, rescale, shape )
%PRINTAGENTLOCATION Hardcodes some color values for agent indices up to 5
%(defauting to blue after that) and calls $printPointsOnGridMapWColors$ to
%print a marker on the grid for each agent. Only the last printed
%overlapping agent marker will be visible at each square.
%
% This function can also accept an array of coordinates, if you want to
% print an agent's trajectory.
%
if nargin < 5
    shape = 'box';
    
    if nargin < 4
        rescale = gridMap.MarkerRescaleFactor ;
        
    end % if no rescale factor was given.
end % if no marker shape was given.

if agentIndex == 1
    colors = [0, 1, 1] ; % cyan
elseif agentIndex == 2
    colors = [1, 0, 1] ; % magenta
elseif agentIndex == 3
    colors = [1, 1, 0] ; % yellow
elseif agentIndex == 4
    colors = [0, 1, 0] ; % green
elseif agentIndex == 5
    colors = [1, 0, 0] ; % red   
else
    colors = [0, 0, 1] ; % blue
end % change marker color according to agent index.
    
printPointsOnGridMapWColors (location, 1, shape, rescale, colors) ;