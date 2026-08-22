function [CostFunctionHandle,CostFunctionDetails,functionNo] = CEC_Config()
%CEC_CONFIG Adapter used by the Framework benchmark loader.
CostFunctionHandle = @RW_Evaluator;
CostFunctionDetails = @RW_Function;
functionNo = 13;
end
