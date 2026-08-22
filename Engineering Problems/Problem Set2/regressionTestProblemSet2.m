function report = regressionTestProblemSet2()
%REGRESSIONTESTPROBLEMSET2 Deterministic checks for the 13 benchmark models.
%
% The listed designs are fixed numerical regression points. They verify that
% the cleaned implementation preserves the intended optima, decodes actual
% physical variables, and rejects the former Problem-10 boundary exploit.

X = cell(13,1);
X{1}  = [3.5 0.7 17 7.3 7.715319911478246 3.350540949105892 5.286654464980222];
X{2}  = [0.05168905479075052 0.3567175884301705 11.288974625928361];
X{3}  = [0.8125 0.4375 42.09844559585492 176.63659584243945];
X{4}  = [0.7886751346514889 0.40824829030355547];
X{5}  = [49 16 19 43];
X{6}  = [6.016016112422567 5.309173456386318 4.494330949294422 3.501472988354835 2.1526661185307687];
X{7}  = [80 50 0.9 2.3217922606924644];
X{8}  = [5.452180736223905 0.291626429299409];
X{9}  = [0.05 2.041513589918118 4.083027179836219 120];
X{10} = [57.69230769230765 34.1476203486744 57.692307692307686 1.05];
X{11} = [0.5 1.1163655866953432 0.5 1.3021971909912837 0.5 1.5 0.5 0.345 0.345 -19.56153011230516 -3.001924226033868e-7];
X{12} = [0.20572963978607958 3.4704886656279985 9.036623910357632 0.20572963978607955];
X{13} = [6.32 34 8.5];

report = repmat(struct('problem',0,'name','','rawObjective',NaN, ...
    'reportedObjective',NaN,'feasible',false,'optimumHit',false),13,1);

for problemNo = 1:13
    e = EngineeringEvaluate(X{problemNo},problemNo);
    assert(e.isFeasible, 'Problem %d regression design must be feasible.',problemNo);
    assert(e.optimumHit, 'Problem %d regression design must hit the reference target.',problemNo);
    assert(e.reportedObjective == e.globalOptimum, ...
        'Problem %d must canonicalize an optimum hit to the reference value.',problemNo);

    report(problemNo).problem = problemNo;
    report(problemNo).name = e.problemName;
    report(problemNo).rawObjective = e.rawObjective;
    report(problemNo).reportedObjective = e.reportedObjective;
    report(problemNo).feasible = e.isFeasible;
    report(problemNo).optimumHit = e.optimumHit;
end


% The I-shaped beam benchmark has exactly two inequality constraints.
p7 = EngineeringEvaluate(X{7},7);
assert(numel(p7.inequality) == 2, ...
    'Problem 7 must have exactly two inequality constraints.');

% Explicit regression for the former corrugated-bulkhead degeneracy.
bad = EngineeringEvaluate([0 eps 0 5],10);
assert(~bad.isFeasible && ~bad.domainValid, ...
    'Problem 10 boundary-degenerate design must be rejected.');
assert(~bad.optimumHit, ...
    'Problem 10 invalid boundary design must never count as an optimum hit.');

fprintf('Problem Set2 regression tests passed for all 13 problems.\n');
end
