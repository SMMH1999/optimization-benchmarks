function [z,Data] = CostFunction(x,problemNo,varargin)
%COSTFUNCTION Scalar merit function for the engineering benchmark set.
%
% Preferred use:
%   z = CostFunction(x,problemNo)
%   [z,Data] = CostFunction(x,problemNo)
%
% A legacy three-argument call CostFunction(x,VioFactor,Obj) is retained for
% compatibility with older callers, but new Framework code should use problemNo.

if nargin >= 2 && isnumeric(problemNo) && isscalar(problemNo) && ...
        problemNo == fix(problemNo) && problemNo >= 1 && problemNo <= 13 && ...
        (nargin == 2 || isempty(varargin))
    Data = EngineeringEvaluate(x,problemNo);
    z = Data.merit;
    return;
end

if nargin < 3 || isempty(varargin) || ~isa(varargin{1},'function_handle')
    error('CostFunction:InvalidCall', ...
        'Use CostFunction(x,problemNo) for Problem Set2.');
end

% Legacy fallback.
VioFactor = problemNo;
Obj = varargin{1};
[f,g,h] = Obj(x);
gh = [g(:).' h(:).'];
weights = VioFactor(:).';
if numel(weights) ~= numel(gh)
    error('CostFunction:LegacyWeightMismatch', ...
        'Legacy VioFactor length does not match the returned constraints.');
end
v = sum(weights.*max(0,gh));
z = f+v;
Data = struct('z',z,'f',f,'g',gh,'v',v,'x',x);
end
