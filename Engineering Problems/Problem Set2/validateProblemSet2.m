function report = validateProblemSet2(sampleCount)
%VALIDATEPROBLEMSET2 Basic structural and numerical validation.

if nargin < 1
    sampleCount = 200;
end

rng(12345,'twister');
expectedInequalityCount = [11 4 4 3 0 1 2 6 4 6 10 7 2];
report = struct('problem',cell(13,1),'name',cell(13,1),'passed',cell(13,1), ...
    'message',cell(13,1));

for problemNo = 1:13
    p = EngineeringProblem(problemNo);
    passed = true;
    message = 'OK';

    try
        assert(numel(p.lowerBound) == p.dimension);
        assert(numel(p.upperBound) == p.dimension);
        assert(all(p.upperBound >= p.lowerBound));
        assert(isfinite(p.globalOptimum));
        assert(p.canonicalTolerance > 0);

        % Structural formulation check. In particular, Problem 7 must expose
        % exactly two inequality constraints.
        xMid = (p.lowerBound+p.upperBound)/2;
        [~,gMid,hMid,~] = EngineeringRawObjective(xMid,problemNo);
        assert(numel(gMid) == expectedInequalityCount(problemNo), ...
            'Problem %d returned %d inequality constraints; expected %d.', ...
            problemNo,numel(gMid),expectedInequalityCount(problemNo));
        assert(isempty(hMid), ...
            'Problem %d unexpectedly returned equality constraints.',problemNo);

        for k = 1:sampleCount
            x = p.lowerBound+rand(1,p.dimension).*(p.upperBound-p.lowerBound);
            r = EngineeringEvaluate(x,problemNo);
            assert(isreal(r.merit) && isfinite(r.merit));
            assert(numel(r.position) == p.dimension);
            assert(all(r.position >= p.lowerBound-10*eps));
            assert(all(r.position <= p.upperBound+10*eps));
        end
    catch ME
        passed = false;
        message = ME.message;
    end

    report(problemNo).problem = problemNo;
    report(problemNo).name = p.name;
    report(problemNo).passed = passed;
    report(problemNo).message = message;
end

if all([report.passed])
    fprintf('Problem Set2 validation passed for all 13 problems.\n');
else
    failed = find(~[report.passed]);
    error('validateProblemSet2:Failed', ...
        'Validation failed for problem(s): %s',mat2str(failed));
end
end
