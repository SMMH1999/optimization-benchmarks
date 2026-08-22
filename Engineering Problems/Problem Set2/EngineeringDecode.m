function x = EngineeringDecode(x,problemNo)
%ENGINEERINGDECODE Convert a search point to the actual engineering design.

problem = EngineeringProblem(problemNo);
x = double(x(:).');

if numel(x) ~= problem.dimension
    error('EngineeringDecode:DimensionMismatch', ...
        'Problem %d expects %d variables; received %d.', ...
        problemNo,problem.dimension,numel(x));
end

% Clamp defensively. Algorithms are still expected to respect the bounds.
x = min(max(x,problem.lowerBound),problem.upperBound);

switch problemNo
    case 1
        x(3) = round(x(3));

    case 3
        x(1) = 0.0625*round(x(1)/0.0625);
        x(2) = 0.0625*round(x(2)/0.0625);

    case 5
        x = round(x);

    case 11
        sections = [0.192 0.345];
        x(8) = nearestCatalogValue(x(8),sections);
        x(9) = nearestCatalogValue(x(9),sections);

    case 13
        reinforcementAreas = [6 6.16 6.32 6.6 7 7.11 7.2 7.8 7.9 8 8.4];
        x(1) = nearestCatalogValue(x(1),reinforcementAreas);
        x(2) = round(x(2));
end

% Re-clamp after discrete conversion to suppress round-off at the bounds.
x = min(max(x,problem.lowerBound),problem.upperBound);
end

function value = nearestCatalogValue(value,catalog)
[~,index] = min(abs(catalog-value));
value = catalog(index);
end
