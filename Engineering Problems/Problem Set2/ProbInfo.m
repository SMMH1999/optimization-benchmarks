function [nDim,LB,UB,Vio,GloMin,Obj,Meta] = ProbInfo(problemNo)
%PROBINFO Compatibility interface for the engineering benchmark set.

Meta = EngineeringProblem(problemNo);
nDim = Meta.dimension;
LB = Meta.lowerBound;
UB = Meta.upperBound;
Vio = Meta.penaltyWeights; % legacy compatibility only
GloMin = Meta.globalOptimum;
Obj = @(x) EngineeringRawObjective(x,problemNo);
end
