# Transition from A4 to 6 / 7 / 8 Cable Sensing Configuration Comparison

## Research question
At the same sampled balloon poses and per-cable noise assumptions, how do cable number and anchor/attachment geometry affect local identifiability, predicted and simulated pose uncertainty, estimation robustness, and feasibility?

## Stage 1 — Shared baseline

- Fix units and coordinate conventions; use a rigid-balloon surrogate initially.
- Define a single common set of 6-DOF sampled poses within a candidate gastric envelope.
- Define candidate anchor and attachment regions (do not assume paper 4's large rigid frame fits the stomach application).
- Set independent noise standard deviations or calibration-supported sensor covariance.
- Record common solver initialization, maximum iterations, stopping criteria, random seeds, and convergence tests.

## Stage 2 — Comparable experiments

For m=6,7,8 and each candidate layout:

1. Calculate every sampled pose's  m×6 cable-length Jacobian and check rank 6.
2. At locally observable poses, compute `(H'*(V\H))^-1` and position (mm), rotation (deg) uncertainty statistics.
3. Compute scaled Jacobian conditioning with an explicitly stated rotation-length scale (avoid raw mixed-unit condition-number comparisons).
4. Run identical noise trials, Gauss–Newton/LM FK with realistic initial guesses, record success fraction, position and rotation RMSE, bias and NEES/ANEES.
5. Separately evaluate WCC / positive-tension and cable length / routing / collision feasibility for those same poses.
6. Report *coverage* as count of jointly feasible and observable poses divided by the explicitly defined sampled pose count.

## Stage 3 — Interpretation

- **Six cables:** possible local 6-DOF length-based observability if full rank, but does not imply wrench closure without other external wrenches/constraints.
- **Seven cables:** one extra length measurement; also a common starting point for positive cable self-stress under suitable geometry.
- **Eight cables:** two extra measurements and increased design flexibility, **not automatically** improved noise accuracy or feasibility for arbitrary layouts.
- Compare both subsets of the same original geometry *and* separately optimized configurations to distinguish cable count from layout quality.

## Recommended scorecard

Configuration ID | Cable count | Rank-6 pose fraction | WCC pose fraction | Joint coverage | Median σ_position (mm) | Median σ_rotation (deg) | Position RMSE (mm) | Rotation RMSE (deg) | FK convergence (%) | Notes

## Exit criteria

One reproducible script drives all three cable counts under shared pose and noise samples, reports uncertainty and feasibility metrics separately, and stores source geometry plus CSV results and figures.
