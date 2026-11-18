# AGENTS2 — Research and Collaboration Rules

**Last reviewed:** 2026-11-18  
**Project:** Cable-based sensing for a passive balloon  
**Primary computational tool:** MATLAB

## 1. Start a research session

Use the following documents according to the question being asked.

| Question | Source |
|---|---|
| What is the project about? | [Repository overview](README.md) |
| What has been completed, what remains open, and what comes next? | [Current research state](CURRENT_STATE2.md) |
| How does the current study contribute to the prototype? | [Research roadmap](08_Project_Management/Roadmap.md) |
| How should the current task be carried out and evaluated? | [Prototype V1 build and validation plan](08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md) |
| What supports a reported result? | The relevant [research log](06_Research_Log/), [MATLAB script and saved dataset](03_Simulation/MATLAB/) |

When resuming work, read the current state and the relevant section of the active plan. Before quoting a numerical result or modifying an existing method, inspect the corresponding log, code or saved output. If the records disagree, identify the discrepancy and its effect on the decision.

Keep milestone status, candidate rankings and next-task descriptions in the current-state document. Update the active-plan link here if the plan is replaced.

## 2. Frame the research question

The project studies how cable lengths can reveal the motion of a passively moving object. Motors may take up slack and maintain low tension. Cable-induced changes to the object's motion are part of the experimental assessment.

For each substantial step, answer three questions:

1. **Why is this needed?** Identify the uncertainty that currently prevents a design or experimental decision.
2. **What supports the method?** Identify the relevant theory, literature, previous result or physical measurement and its assumptions.
3. **What decision will the result enable?** State which observation would support retaining, modifying or rejecting the design.

Use the rigid-body stage to establish pose-measurement performance. When a flexible specimen is introduced, define the measured body frame or surface markers and account for deformation and attachment movement.

## 3. Use consistent geometry and measurement conventions

| Quantity | Convention |
|---|---|
| Position and cable length | Millimetres |
| Local rotation increment in Jacobian calculations | Radians |
| Reported orientation | Declare angle units, rotation order and reference frame |
| Cable tension | Newtons |
| Motor or drum torque | Newton-metres; identify the shaft |
| Frame axes | X = length, Y = width, Z = height |

For cable \(i\), let \(A_i\) be the effective exit point in world coordinates, \(r_i\) the attachment in body coordinates, \(P\) the body-frame origin in world coordinates, and \(R\) the body-to-world rotation. For the straight, taut free segment,

\[
s_i=Rr_i,\qquad B_i=P+s_i,\qquad
L_i=\|A_i-B_i\|,\qquad u_i=(A_i-B_i)/L_i.
\]

For a local world-frame rotation increment, the length Jacobian row is

\[
H_i=\begin{bmatrix}-u_i^\mathsf{T} & (u_i\times s_i)^\mathsf{T}\end{bmatrix},
\qquad
\delta L\approx H
\begin{bmatrix}\delta P\\\delta\theta\end{bmatrix}.
\]

Declare the characteristic length used for scaled singular values and condition numbers. Use a consistent scaling convention across candidates. Verify analytical derivatives numerically when changing the coordinate convention, geometry or measurement model.

Distinguish the guide mounting location, effective exit point, drum position and physical cable path. If the exit point moves with direction or the measured length includes a changing wrap length, document the correction or quantify the resulting model error.

## 4. Compare configurations fairly

- Preserve each parent configuration, including rail IDs and parameters, anchor coordinates, body-frame attachments and cable-to-attachment correspondence. If attachment rows are already paired, apply that correspondence exactly once.
- Declare adjustable variables, fixed variables, bounds, physical constraints, objective, pose sets, search budget and stopping rule before comparison. Record seeds for stochastic studies.
- To study anchor–attachment coupling, compare the original, anchor-only, attachment-only and joint variants under matched conditions. Reuse earlier results when their bounds and evaluation protocol match.
- In a joint search, allow the anchor and attachment choices to influence one another. An alternating search qualifies when it can revisit earlier choices. A single anchor pass followed by an attachment pass with permanently frozen anchors establishes a sequential result.
- Keep perturbation tests separate from optimisation results. Perturbation tests evaluate sensitivity to deviations from an existing design.
- Record failed variants and the responsible constraint. Prefer the simpler installable design when a more complex variant provides no meaningful benefit for the stated experiment.

## 5. State what workspace evidence covers

Define the position and orientation domain before reporting a workspace result. Evaluate the criteria needed for the claim:

| Criterion | Evidence to report |
|---|---|
| Installation | Guide footprint, rail-end clearance, fastener access, connector envelopes and measurable exit coordinates |
| Routing | Cable departure, cable-pair separation and clearance from the body, guides and frame, allowing for intended contact at attachments |
| Sensing | Jacobian rank, weakest-direction sensitivity, scaling, assumed length errors and pose-estimation performance |
| Travel and low tension | Required length range by channel, available travel, slack, take-up behaviour and disturbance |
| Connectivity | Starting pose, reachable region and evidence covering transitions between feasible poses |

Distinguish feasibility at **some** orientations from feasibility throughout the required orientation range. Label sampled poses, checked paths, continuously verified cells, observed failures and unresolved regions. A continuous bound supports only the geometry, criterion and domain in its derivation.

Use measured hardware dimensions where available. Label preliminary dimensions and tolerances by source. In figures showing a limiting case, include the configuration, pose index, position, orientation, cable IDs and relevant margin. Keep anchor and attachment labels consistent with the data tables.

## 6. Separate prediction, calibration and independent validation

Use explicit evidence descriptions: **reported in literature**, **derived**, **assumed**, **numerically verified**, **experimentally measured** or **unknown**.

- A full-column-rank Jacobian supports local first-order identifiability. Global uniqueness, solver convergence and realised accuracy require separate evidence.
- Keep development data separate from independent tests. If a validation failure leads to redesign, retain that case in the development record and use fresh data for the revised design's independent evaluation.
- Keep assumed encoder noise, predicted covariance, simulated reconstruction error and experimental pose error distinct. Record units, sample set, failed trials and reference uncertainty.
- For physical pose validation, use an independent position and orientation reference. Separate calibration poses from evaluation poses. Give the estimator only information that will be available during operation.
- For flexible specimens, distinguish rigid-frame motion from attachment migration and deformation. Six instantaneous lengths generally cannot identify six unconstrained pose variables plus additional independent deformation variables.

## 7. Connect design work to bench decisions

Use physical measurements to resolve assumptions that affect the next build decision. For example, measure corner hardware before choosing an anchor shift, and measure single-channel reversal error and tension before replicating a drive module.

When a test changes the model, record the as-built geometry, calibration version, affected assumption and checks that need repeating. Retain the earlier result so that improvements can be traced to a specific change.

Evaluate additional cables under common workspace, uncertainty and installation assumptions. Use the six-cable baseline to identify the value and cost of redundancy.

## 8. Collaborate and document the work

- Discuss research logic in Chinese unless another language is requested. Use English for repository documents and presentation content where established.
- Follow the sequence **research question → method and expected decision → code → interpretation of actual output**. For MATLAB teaching tasks, explain inputs, units and logic, provide runnable code with clear Chinese comments, and interpret the results after execution.
- Reuse verified functions and datasets. Use MATLAB as the primary implementation and CASPR as a supplementary check when it answers a specific verification question.
- For a paper supporting a design decision, give the title, authors, year, verified DOI when available, applicable method and limits of transfer to passive sensing.
- Save technical results and failed cases in the research log. Update the current state when a result changes a candidate, assumption or next task. Update the roadmap when a milestone or dependency changes.
- For manual GitHub reviews, inspect the existing file, provide one complete copyable Markdown replacement, and wait for confirmation before moving to the next file. Preserve historical logs and saved results.
- During a documentation review, finish the agreed file updates before starting new optimisation runs or prototype experiments.
