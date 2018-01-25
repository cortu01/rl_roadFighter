function printPointsOnGridMapWColors (...
    IndexVector, bigness, shape, rescale, colors)

e = 0.01 ;
if nargin < 5
    colors = [0, 1, 1]; % Default coluring is cyan
    
    if nargin < 4
        rescale = 1 ;
        
        if nargin < 3
            shape = 'o' ;
            
            if nargin < 2
                bigness = 1 ;
                
            end % if no size
        end % if no shape
    end % if no rescale    
end % if no colors

if strcmp(shape, 'boxes')|| strcmp(shape, 'box') || strcmp(shape, 's')
    shape = 's' ;
    % bigness = 10 ;
elseif strcmp(shape, 'crosses') || strcmp(shape, 'cross') || strcmp(shape, '+')
    shape = '+' ;
    % bigness = 10 ;
elseif strcmp(shape, 'exes') || strcmp(shape, 'ex') || strcmp(shape, 'x')    
    shape = 'x' ;
    % bigness = 10 ;
elseif strcmp(shape, 'diamonds') || strcmp(shape, 'diamond') || strcmp(shape, 'd')
    shape = 'd' ;
    bigness = 1 ;
else
    shape = 'o' ;
    bigness = 0.45 ;
end

for i = length(bigness):-1:1
    if bigness(i) <= e || isnan(bigness(i))
        bigness(i) = [] ;
        IndexVector(i,:) = [] ;
    end
end

IndexVector = IndexVector + 0.5 ;

%[n,~] = size(IndexVector) ;

r = bigness*2000*rescale ;

for i = length(r):-1:1
    if r(i) <= 1 || isnan(r(i))
        r(i) = [] ;
        IndexVector(i,:) = [] ;
    end
end

r ;

if ndims(IndexVector == 3)
    IndexVector = squeeze(IndexVector) ;
end % if we were given an array of coordinates.

scatter( IndexVector(:,2), IndexVector(:,1), r, ...
    'MarkerEdgeColor', [ 0 0 0 ], ...
    'MarkerFaceColor', colors, ...
    'Marker', shape ) ;