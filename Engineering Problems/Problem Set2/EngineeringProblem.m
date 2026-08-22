function problem = EngineeringProblem(problemNo)
%ENGINEERINGPROBLEM Metadata for the 13 engineering benchmark problems.
%
% The search bounds are expressed in physical design-variable units. Discrete
% and stepped variables are decoded by EngineeringDecode before evaluation.

if ~isscalar(problemNo) || problemNo ~= fix(problemNo) || problemNo < 1 || problemNo > 13
    error('EngineeringProblem:InvalidProblemNumber', ...
        'problemNo must be an integer from 1 to 13.');
end

problem = struct();
problem.id = problemNo;
problem.constraintTolerance = 1e-8;

switch problemNo
    case 1
        problem.name = 'Speed Reducer Design';
        problem.dimension = 7;
        problem.lowerBound = [2.6 0.7 17 7.3 7.3 2.9 5.0];
        problem.upperBound = [3.6 0.8 28 8.3 8.3 3.9 5.5];
        problem.globalOptimum = 2994.4244658;
        problem.canonicalTolerance = 5e-8;
        problem.penaltyWeights = [50 10 1 1 1 20 1 300 1 1 50];
        problem.variableTypes = {'continuous','continuous','integer','continuous', ...
            'continuous','continuous','continuous'};

    case 2
        problem.name = 'Tension-Compression Spring Design';
        problem.dimension = 3;
        problem.lowerBound = [0.05 0.25 2.0];
        problem.upperBound = [2.0 1.3 15.0];
        problem.globalOptimum = 0.012665232788;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [3 4 0.1 0.1];
        problem.variableTypes = {'continuous','continuous','continuous'};

    case 3
        problem.name = 'Pressure Vessel Design';
        problem.dimension = 4;
        problem.lowerBound = [0.0625 0.0625 10 10];
        problem.upperBound = [6.1875 6.1875 200 200];
        problem.globalOptimum = 6059.714335048436;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [12000 8000 1 1];
        problem.variableTypes = {'step-0.0625','step-0.0625','continuous','continuous'};

    case 4
        problem.name = 'Three-Bar Truss Design';
        problem.dimension = 2;
        problem.lowerBound = [0 0];
        problem.upperBound = [1 1];
        problem.globalOptimum = 263.89584338;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [140 7 15];
        problem.variableTypes = {'continuous','continuous'};

    case 5
        problem.name = 'Gear Train Design';
        problem.dimension = 4;
        problem.lowerBound = [12 12 12 12];
        problem.upperBound = [60 60 60 60];
        problem.globalOptimum = 2.70085714e-12;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = zeros(1,0);
        problem.variableTypes = {'integer','integer','integer','integer'};

    case 6
        problem.name = 'Cantilever Beam Design';
        problem.dimension = 5;
        problem.lowerBound = [0.01 0.01 0.01 0.01 0.01];
        problem.upperBound = [100 100 100 100 100];
        % Analytically established value for this formulation.
        problem.globalOptimum = 1.339956367;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = 10;
        problem.variableTypes = repmat({'continuous'},1,5);

    case 7
        problem.name = 'I-Shaped Beam Deflection Design';
        problem.dimension = 4;
        problem.lowerBound = [10 10 0.9 0.9];
        problem.upperBound = [80 50 5 5];
        problem.globalOptimum = 0.0130741;
        problem.canonicalTolerance = 5e-8;
        problem.penaltyWeights = 0.1; % scalar: applied uniformly to both constraints
        problem.variableTypes = repmat({'continuous'},1,4);

    case 8
        problem.name = 'Tubular Column Design';
        problem.dimension = 2;
        problem.lowerBound = [2 0.2];
        problem.upperBound = [14 0.8];
        problem.globalOptimum = 26.486361473;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [100 1 1 1 1 1];
        problem.variableTypes = {'continuous','continuous'};

    case 9
        problem.name = 'Piston Lever Design';
        problem.dimension = 4;
        problem.lowerBound = [0.05 0.05 0.05 0.05];
        problem.upperBound = [500 500 500 120];
        problem.globalOptimum = 8.41269832311;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [1 1 1 100];
        problem.variableTypes = repmat({'continuous'},1,4);

    case 10
        problem.name = 'Corrugated Bulkhead Design';
        problem.dimension = 4;
        problem.lowerBound = [0 0 0 0];
        problem.upperBound = [100 100 100 5];
        problem.globalOptimum = 6.8429580100808;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [1 1 3 3 100 1];
        problem.variableTypes = repmat({'continuous'},1,4);

    case 11
        problem.name = 'Car Side Impact Design';
        problem.dimension = 11;
        problem.lowerBound = [0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.192 0.192 -30 -30];
        problem.upperBound = [1.50 1.50 1.50 1.50 1.50 1.50 1.50 0.345 0.345 30 30];
        problem.globalOptimum = 22.84296954;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [1 1 1 1 1 1 10 29.8 2 6];
        problem.variableTypes = [repmat({'continuous'},1,7), {'catalog','catalog'}, ...
            {'continuous','continuous'}];

    case 12
        problem.name = 'Welded Beam Design';
        problem.dimension = 4;
        problem.lowerBound = [0.1 0.1 0.1 0.1];
        problem.upperBound = [2 10 10 2];
        problem.globalOptimum = 1.724852308597366;
        problem.canonicalTolerance = 1e-8;
        problem.penaltyWeights = [1 1 4 0.001 1 0.5 1];
        problem.variableTypes = repmat({'continuous'},1,4);

    case 13
        problem.name = 'Reinforced Concrete Beam Design';
        problem.dimension = 3;
        problem.lowerBound = [6 28 5];
        problem.upperBound = [8.4 40 10];
        problem.globalOptimum = 359.2080;
        % The reference is reported to four decimal places.
        problem.canonicalTolerance = 5e-5;
        problem.penaltyWeights = [50 30];
        problem.variableTypes = {'catalog','integer','continuous'};
end

problem.lowerBound = problem.lowerBound(:).';
problem.upperBound = problem.upperBound(:).';

% Fixed inequality-constraint counts for Problem Set2.
% This is deliberately independent from penaltyWeights so a malformed
% objective definition cannot be silently accepted.
expectedInequalityCounts = [11 4 4 3 0 1 2 6 4 6 10 7 2];
problem.inequalityCount = expectedInequalityCounts(problemNo);
problem.equalityCount = 0;

problem.penaltyBase = max(1,abs(problem.globalOptimum))*1e6;
end
