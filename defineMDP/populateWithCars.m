function [ carLocations ] = populateWithCars( grid, noCarOnRowProbability )
%POPULATELWITHCARS Randomly assigns cars to different locations on the
%given grid map. Returns a matrix with 1s indicating the pressence of a 
%car. 
%   Each row (except the last one which our car occupies at the beginning 
%   of the instance) has a car assigned to one of its squares (or none at 
%   all) according to a distribution over the paved squares and a 
%   hypothetical "no-car" square. There is a $noCarOnRowProbability$ 
%   probability of no car appearing on a row, with the rest being divided
%   among paved squares.
    
    [ n_Rows, n_Columns ] = size(grid) ;    
    
    carLocations = zeros(n_Rows, n_Columns) ;
    
    for row = 1:n_Rows-1
    
        weights = ( 1 - noCarOnRowProbability ) * ( 1 - grid(row, :) ) ...
            / sum( 1 - grid(row, :) ) ;
        
        weights = [ weights, noCarOnRowProbability ] ; %#ok<AGROW>
        
        column = randomWeightedSelect( weights ) ;
        
        if column <= n_Columns
            
            % Place car:
            carLocations(row, column) = 1 ;
            
        end % if there is to be a car on this row
        
    end % for each row, except for the last one
        
end