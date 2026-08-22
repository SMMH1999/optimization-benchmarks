function testProblem7()
%TESTPROBLEM7 Deterministic regression test for Problem 7.

x = [80, 50, 0.9, 2.321792260794296];

problem = EngineeringProblem(7);
result = EngineeringEvaluate(x,7);

fprintf('P7 name             : %s\n',problem.name);
fprintf('Raw objective       : %.15g\n',result.rawObjective);
fprintf('Global optimum      : %.15g\n',result.globalOptimum);
fprintf('Reported objective  : %.15g\n',result.reportedObjective);
fprintf('g1                  : %.15g\n',result.inequality(1));
fprintf('g2                  : %.15g\n',result.inequality(2));
fprintf('Total violation     : %.15g\n',result.totalViolation);
fprintf('Feasible            : %d\n',result.isFeasible);
fprintf('Optimum hit         : %d\n',result.optimumHit);

assert(problem.inequalityCount == 2, ...
    'Problem 7 metadata must declare exactly two inequality constraints.');
assert(numel(result.inequality) == 2, ...
    'Problem 7 objective must return exactly two inequality constraints.');
assert(isempty(result.equality), ...
    'Problem 7 must not return equality constraints.');
assert(result.domainValid, ...
    'Known P7 reference point was rejected by domain validation.');
assert(result.isFeasible, ...
    'Known P7 reference point must be feasible.');
assert(result.optimumHit, ...
    'Known P7 reference point must be recognized as an optimum hit.');
assert(result.totalViolation <= 10*eps, ...
    'Known P7 reference point must have zero effective violation.');
assert(abs(result.reportedObjective-problem.globalOptimum) <= ...
    eps(max(1,abs(problem.globalOptimum))), ...
    'Reported P7 objective was not canonicalized to the reference optimum.');

fprintf('Problem 7 regression test: PASS\n');
end
