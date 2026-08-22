# Problem Set2

Clean implementation of the current 13 constrained engineering benchmark problems.

## Main interfaces

- `EngineeringProblem(problemNo)` — fixed dimension, physical bounds, variable types, reference optimum and reporting tolerance.
- `EngineeringDecode(x,problemNo)` — returns the actual physical design used by the objective function.
- `EngineeringRawObjective(x,problemNo)` — raw objective and constraints (`g <= 0`).
- `EngineeringEvaluate(x,problemNo)` — complete result structure: raw/reportable objective, feasibility, violations, benchmark error and decoded variables.
- `CostFunction(x,problemNo)` — scalar optimizer merit.
- `RW_Evaluator(X,functionNo)` — safe CEC-style population adapter.
- `RW_Function(functionNo)` — bounds and fixed dimension.

## Result semantics

The reference optimum is not used to guide the optimization search. A feasible design is optimized using its raw objective value.

For final reporting, a feasible objective that reaches the benchmark target within the configured tolerance, or is numerically below that target, is reported exactly as the reference optimum and receives zero benchmark error. This prevents insignificant numerical precision from producing false wins or losses.

`position` always contains the decoded physical engineering variables. Integer, stepped, and catalog variables are never reported as their internal search representation.

## Quality checks

Run:

```matlab
validateProblemSet2
regressionTestProblemSet2
```

The regression test also verifies that the former degenerate boundary solution of Problem 10 is rejected.


P7 FIX v3: Problem 7 is explicitly defined with exactly two inequality constraints; structural constraint-count validation and deterministic P7 regression test added.
