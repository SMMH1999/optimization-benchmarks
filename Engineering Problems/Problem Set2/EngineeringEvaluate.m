function result = EngineeringEvaluate(x,problemNo)
%ENGINEERINGEVALUATE Full constrained evaluation for one engineering design.
%
% The optimizer is NEVER given the reference optimum. The reference value is
% used only after evaluation to canonicalize reporting and compute benchmark
% success. This keeps the search fair while suppressing insignificant
% floating-point differences in the final tables.

problem = EngineeringProblem(problemNo);
searchX = double(x(:).');
actualX = EngineeringDecode(searchX,problemNo);
[f,g,h,domainValid] = EngineeringRawObjective(actualX,problemNo);

% Structural validation before feasibility/penalty calculation.
if numel(g) ~= problem.inequalityCount
    error('EngineeringEvaluate:ConstraintCountMismatch', ...
        ['Problem %d (%s) must return exactly %d inequality constraints, ' ...
         'but the active EngineeringRawObjective returned %d.'], ...
        problemNo,problem.name,problem.inequalityCount,numel(g));
end
if numel(h) ~= problem.equalityCount
    error('EngineeringEvaluate:EqualityCountMismatch', ...
        ['Problem %d (%s) must return exactly %d equality constraints, ' ...
         'but the active EngineeringRawObjective returned %d.'], ...
        problemNo,problem.name,problem.equalityCount,numel(h));
end

finiteObjective = isscalar(f) && isfinite(f) && isreal(f);
finiteConstraints = all(isfinite(g)) && all(isfinite(h)) && isreal(g) && isreal(h);

ineqViolation = max(g-problem.constraintTolerance,0);
if isempty(h)
    eqViolation = zeros(1,0);
else
    eqViolation = max(abs(h)-problem.constraintTolerance,0);
end

% Penalty weights are only used to order infeasible candidates.
% A scalar weight is broadcast to every inequality constraint. This keeps the
% metadata compact and avoids fragile one-weight-per-constraint bookkeeping.
if isempty(ineqViolation)
    weightedIneq = 0;
elseif isempty(problem.penaltyWeights)
    weightedIneq = sum(ineqViolation);
else
    weights = problem.penaltyWeights(:).';
    if isscalar(weights)
        weights = repmat(weights,1,numel(ineqViolation));
    elseif numel(weights) ~= numel(ineqViolation)
        error('EngineeringEvaluate:PenaltyWeightMismatch', ...
            ['Problem %d returned %d inequality constraints but its metadata ' ...
             'contains %d penalty weights. This indicates an inconsistent or ' ...
             'shadowed Problem Set2 file on the MATLAB path.'], ...
            problemNo,numel(ineqViolation),numel(weights));
    end
    weightedIneq = sum(weights.*ineqViolation);
end

if domainValid
    domainViolation = 0;
else
    % Domain failures are hard invalidity conditions, not tiny soft violations.
    domainViolation = 1;
end

if finiteConstraints
    totalViolation = sum(ineqViolation)+sum(eqViolation)+domainViolation;
    weightedViolation = weightedIneq+sum(eqViolation)+domainViolation;
    maxViolation = max([ineqViolation eqViolation domainViolation 0]);
else
    totalViolation = Inf;
    weightedViolation = Inf;
    maxViolation = Inf;
end

isFeasible = domainValid && finiteConstraints && ...
    all(g <= problem.constraintTolerance) && ...
    all(abs(h) <= problem.constraintTolerance);
isValidResult = isFeasible && finiteObjective;

if finiteObjective
    rawReferenceDelta = f-problem.globalOptimum;
    rawAbsoluteReferenceError = abs(rawReferenceDelta);
else
    rawReferenceDelta = NaN;
    rawAbsoluteReferenceError = Inf;
end

% CEC-style canonicalization for a minimization benchmark:
%   feasible f <= f* + tolerance  -> target reached, report exactly f*.
% A slightly lower feasible value is therefore never treated as an artificial
% advantage caused by reference rounding or floating-point noise.
optimumHit = isValidResult && ...
    f <= problem.globalOptimum+problem.canonicalTolerance;

if isValidResult
    if optimumHit
        reportedObjective = problem.globalOptimum;
        benchmarkError = 0;
    else
        reportedObjective = f;
        benchmarkError = max(f-problem.globalOptimum,0);
    end
else
    reportedObjective = NaN;
    benchmarkError = NaN;
end

% Scalar merit used by optimizers. Reference optimum is intentionally absent.
% Every feasible finite design keeps its true raw objective ordering. Invalid
% designs are placed safely above the feasible objective scale.
if isValidResult
    merit = f;
else
    if isfinite(weightedViolation)
        violationTerm = min(weightedViolation,1e100);
    else
        violationTerm = 1e100;
    end

    merit = problem.penaltyBase*(1+violationTerm);
    if finiteObjective
        merit = merit+min(abs(f),problem.penaltyBase*0.1);
    end
end

if ~isfinite(merit) || ~isreal(merit)
    merit = realmax('double')/100;
end

result = struct();
result.problemNo = problemNo;
result.problemName = problem.name;
result.searchPosition = searchX;
result.position = actualX;
result.rawObjective = finiteOrNaN(f);
result.reportedObjective = reportedObjective;
result.merit = merit;
result.globalOptimum = problem.globalOptimum;
result.canonicalTolerance = problem.canonicalTolerance;
result.absoluteError = finiteOrNaN(benchmarkError);
result.rawAbsoluteReferenceError = finiteOrNaN(rawAbsoluteReferenceError);
result.rawReferenceDelta = finiteOrNaN(rawReferenceDelta);
result.inequality = g;
result.equality = h;
result.totalViolation = finiteOrInf(totalViolation);
result.weightedViolation = finiteOrInf(weightedViolation);
result.maxViolation = finiteOrInf(maxViolation);
result.domainValid = logical(domainValid);
result.isFeasible = logical(isFeasible);
result.optimumHit = logical(optimumHit);
result.isValidResult = logical(isValidResult);
end

function value = finiteOrNaN(value)
if ~isscalar(value) || ~isfinite(value) || ~isreal(value)
    value = NaN;
end
end

function value = finiteOrInf(value)
if ~isscalar(value) || ~isfinite(value) || ~isreal(value)
    value = Inf;
end
end
