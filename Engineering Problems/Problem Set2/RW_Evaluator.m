function y = RW_Evaluator(X,functionNo)
%RW_EVALUATOR CEC-style population adapter for Problem Set2.
% Accepts D-by-N, N-by-D, or a single vector. Returns 1-by-N merits.

problem = EngineeringProblem(functionNo);
D = problem.dimension;

if isvector(X)
    if numel(X) ~= D
        error('RW_Evaluator:DimensionMismatch', ...
            'Problem %d expects %d variables.',functionNo,D);
    end
    candidates = double(X(:).');
elseif size(X,1) == D
    candidates = double(X.');
elseif size(X,2) == D
    candidates = double(X);
else
    error('RW_Evaluator:BadShape', ...
        'Expected D-by-N or N-by-D with D=%d; received %d-by-%d.', ...
        D,size(X,1),size(X,2));
end

N = size(candidates,1);
y = zeros(1,N);
for k = 1:N
    evaluation = EngineeringEvaluate(candidates(k,:),functionNo);
    y(k) = evaluation.merit;
end
end
