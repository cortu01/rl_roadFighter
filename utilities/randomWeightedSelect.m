function [ solution ] = randomWeightedSelect( weights, twist )
% Returns an index at "random" from 1 to length(weights) with
% probabilities analogous to each index's weight(index).
% 'twist ~= 0' forces the resetting of the random number generator.

if nargin == 2
    if twist
    	rand('twister',sum(100*clock)) ;
    end % if
end % if

weights = weights/sum(weights) ;

randomRoll = rand() ;
N_of_Options = length(weights) ;
solution = 0 ;
solutionFound = 0 ;
sums = 0 ;
i = 1 ;

while i <= N_of_Options && ~solutionFound
    sums = sums + weights( i ) ;
    if randomRoll <= sums
        solution = i ;
        solutionFound = 1 ;
    end % if
    i = i + 1 ;
end % while