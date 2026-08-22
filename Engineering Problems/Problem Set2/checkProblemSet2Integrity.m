function checkProblemSet2Integrity()
%CHECKPROBLEMSET2INTEGRITY Verify that MATLAB resolves the intended Set2 files.
%
% Run this once before a long engineering benchmark. It detects stale or
% duplicate Problem Set2 copies on the MATLAB path and verifies the exact
% inequality-constraint count of all 13 problems.

required = { ...
    'EngineeringProblem', ...
    'EngineeringDecode', ...
    'EngineeringRawObjective', ...
    'EngineeringEvaluate', ...
    'CostFunction'};

fprintf('Problem Set2 path resolution:\n');
for k = 1:numel(required)
    name = required{k};
    matches = which(name,'-all');
    if isempty(matches)
        error('checkProblemSet2Integrity:MissingFile', ...
            'Required function %s is not on the MATLAB path.',name);
    end
    if ischar(matches)
        matches = cellstr(matches);
    end
    fprintf('  %s -> %s\n',name,matches{1});
    if numel(matches) > 1
        fprintf('    WARNING: %d copies found on the MATLAB path.\n',numel(matches));
        for j = 2:numel(matches)
            fprintf('             %s\n',matches{j});
        end
    end
end

expected = [11 4 4 3 0 1 2 6 4 6 10 7 2];
for problemNo = 1:13
    p = EngineeringProblem(problemNo);
    x = (p.lowerBound+p.upperBound)/2;
    [~,g,h,~] = EngineeringRawObjective(x,problemNo);
    if numel(g) ~= expected(problemNo)
        error('checkProblemSet2Integrity:ConstraintCountMismatch', ...
            ['Problem %d (%s) returned %d inequality constraints; expected %d. ' ...
             'Run "which EngineeringRawObjective -all" and remove the stale copy.'], ...
            problemNo,p.name,numel(g),expected(problemNo));
    end
    if ~isempty(h)
        error('checkProblemSet2Integrity:UnexpectedEquality', ...
            'Problem %d unexpectedly returned equality constraints.',problemNo);
    end
end

fprintf('Problem Set2 integrity check passed. P7 has exactly 2 inequality constraints.\n');
end
