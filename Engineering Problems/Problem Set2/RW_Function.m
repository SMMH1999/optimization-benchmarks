function [LB,UB,Dim] = RW_Function(functionNo)
%RW_FUNCTION Return physical bounds and fixed dimension.
problem = EngineeringProblem(functionNo);
LB = problem.lowerBound;
UB = problem.upperBound;
Dim = problem.dimension;
end
