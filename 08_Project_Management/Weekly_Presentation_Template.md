# how to use:

<img width="1380" height="468" alt="image" src="https://github.com/user-attachments/assets/26149831-7e81-40bb-9a84-f602dad419fa" />

根据 GitHub 中的 Weekly_Presentation_Template.md 和本周的 weekly plan，帮我生成这周的英文 PPT 框架。保留结果空位，周五用于 research presentation。

# Weekly Research Presentation — Reusable Template

**Version:** 1.1  
**Last Updated:** 2026-11-12  
**Purpose:** Create and update an English research presentation using verified weekly research progress.  
**Format:** Editable PowerPoint, 16:9  
**Status:** Permanent reusable template

---

## 1. Purpose

This document defines the workflow for preparing weekly Master's research presentations.

The presentation should communicate:

1. What research question was investigated?
2. Why was the investigation necessary?
3. What method was used?
4. What results were obtained?
5. What conclusions and next actions follow?

The presentation should be based on actual research evidence, not merely planned activities.

**Core workflow:**

```text
Weekly Research Plan
         |
         v
PPT Skeleton
         |
         v
Daily Research Progress
         |
         v
Verified Results and Figures
         |
         v
Friday Research Presentation
```

The PPT should develop alongside research rather than becoming a separate major task at the end of the week.

---

## 2. Authoritative Research Sources

Use the following repository documents:

| Source | Purpose |
|---|---|
| [CURRENT_STATE2.md](../CURRENT_STATE2.md) | Latest verified progress |
| [Active Research Plan](November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md) | Current tasks and procedures |
| [Roadmap.md](Roadmap.md) | Long-term milestones |
| [Research Logs](../06_Research_Log/) | Actual research results |
| [MATLAB Simulations](../03_Simulation/MATLAB/) | Code, figures and numerical data |
| [AGENTS2.md](../AGENTS2.md) | Research and verification rules |

If a newer active research plan is created, use the latest explicitly designated active plan.

Historical or superseded plans must not be used to determine current research tasks.

### Evidence Priority

1. Verified MATLAB outputs and experimental data.
2. Research Logs.
3. Current Research State.
4. Active Research Plan.
5. Historical documents, only when needed for background.

A scheduled task does not imply completion.

---

## 3. Weekly Presentation Workflow

| Stage | Action | Output |
|---|---|---|
| Start of week | Review current research plan and design slides | Draft PPT |
| During week | Update slides using actual research results | Updated PPT |
| Friday | Finalise content, layout and conclusions | Presentation-ready PPT |
| After presentation | Record useful feedback and research decisions | Research Log or next plan |

### Start of Week

Identify:

- Reporting dates.
- Main research question.
- Current milestone.
- Planned research tasks.
- Relevant literature.
- Expected figures and results.

Create a PPT skeleton with placeholders for results not yet obtained.

### Daily Updates

Use the latest editable PPTX.

Update only the slides affected by actual progress.

Preserve previously verified results unless new evidence corrects them.

### Friday Finalisation

Check:

- Scientific accuracy.
- Logical flow.
- Figure readability.
- Consistent formatting.
- Verified numerical results.
- Remaining limitations.
- Next research actions.

If the weekly research schedule extends beyond Friday, clearly distinguish completed work from tasks planned after the presentation.

---

## 4. PPT Design Requirements

### Language

- English only inside slides.
- Use simple academic English.
- Prefer keywords and short phrases.
- Avoid long paragraphs.
- Discussion and explanation with ChatGPT may remain in Chinese.

### Formatting

- 16:9 widescreen.
- Clean academic layout.
- Consistent with the previous week's PPT when provided.
- Maximum three main font-size levels.
- Large, readable text.
- Consistent spacing and alignment.
- Consistent title and figure styles.
- Minimal unnecessary decoration.

### Content

- One main message per slide.
- Use equations only when necessary.
- Prefer MATLAB figures and concise result tables.
- Include units and evaluation conditions.
- Label cables, anchors and coordinate axes clearly when relevant.
- Keep legends within figures when practical.
- Include sources for literature figures.
- Use editable PowerPoint objects where practical.

### Slide Count

Usually 6–8 slides, adjusted to actual research progress.

Do not add unnecessary slides merely to reach a fixed number.

---

## 5. Recommended Slide Structure

| Slide | Content | Purpose |
|---|---|---|
| S1 | Research Goal | Introduce the week's question |
| S2 | Background and Motivation | Explain why the task is needed |
| S3 | Theory or Literature | Explain the supporting method |
| S4 | Mathematical Model | Present important equations and variables |
| S5 | MATLAB Implementation | Explain the simulation or algorithm |
| S6 | Results | Present numerical and visual evidence |
| S7 | Analysis and Discussion | Interpret results and limitations |
| S8 | Conclusions and Next Steps | Summarise decisions and future work |

This structure is flexible.

Merge or reorder slides when necessary to create a clearer research narrative.

For example, a week focused on configuration optimisation may require multiple results slides and fewer background slides.

### Result Placeholders

At the start of the week, unfinished slides may contain:

`[RESULT PENDING]`

`[MATLAB FIGURE]`

`[NUMERICAL COMPARISON]`

Replace placeholders only when actual evidence becomes available.

---

## 6. Research Result Reporting

Every important result should identify:

- Configuration or experiment.
- Evaluation conditions.
- Units.
- Numerical method.
- Actual value.
- Verification status.
- Physical interpretation.

### Status Definitions

| Status | Meaning |
|---|---|
| PLANNED | Not started |
| IN PROGRESS | Work underway |
| PARTIAL | Some evidence obtained; limitations remain |
| VERIFIED | Defined numerical or experimental checks passed |
| BLOCKED | An unresolved problem prevents progress |

Running MATLAB without an error does not automatically establish scientific verification.

Do not confuse:

- Geometric feasibility with sensing quality.
- Jacobian conditioning with measured pose accuracy.
- Simulated noise with calibrated sensor noise.
- Discrete pose screening with continuous workspace proof.
- Numerical optimisation with experimental validation.

Detailed scientific rules are maintained in `AGENTS2.md`.

---

## 7. Daily PPT Update Input

When updating a presentation, provide:

| Field | Content |
|---|---|
| Date | Research date |
| Task | Current research task |
| Objective | Main question |
| Completed Work | Actual progress |
| MATLAB Files | Relevant scripts or datasets |
| Results | Numerical outputs and figures |
| Verification | Tests performed |
| Limitations | Problems or unresolved issues |
| Next Action | Following research task |

The complete daily research record should be stored in the relevant Research Log, not duplicated inside this template.

---

## 8. Reusable ChatGPT Prompts

### A. Create the Weekly PPT Skeleton

Use this prompt at the beginning of a reporting week:

> Read my GitHub repository's `CURRENT_STATE2.md`, active Research Plan, relevant Research Logs and `Weekly_Presentation_Template.md`.
>
> Create an editable English PowerPoint skeleton for this week's research presentation.
>
> Requirements:
>
> - Follow my current research progress.
> - Explain the research question, motivation and method.
> - Use approximately 6–8 slides.
> - Keep the language simple and concise.
> - Use consistent academic formatting.
> - Limit text to three main font-size levels.
> - Reserve clearly labelled spaces for unfinished results.
> - Do not invent results.
>
> Return the editable PPTX.

### B. Update the PPT After Research

Use this prompt after completing a research task:

> Update my latest attached weekly PPT using today's MATLAB results, figures and research notes.
>
> Requirements:
>
> - Preserve the existing structure where appropriate.
> - Modify only the relevant slides.
> - Include actual numerical results with units.
> - Explain the research meaning of the results.
> - Clearly identify limitations.
> - Keep the slides concise and readable.
> - Do not claim unverified results.
>
> Return the updated editable PPTX.

### C. Finalise the Friday Presentation

Use this prompt before the weekly presentation:

> Finalise my latest weekly research PPT using the verified results and Research Logs from this week.
>
> Requirements:
>
> - Check scientific accuracy.
> - Improve slide layout and readability.
> - Ensure consistent typography.
> - Remove unnecessary paragraphs.
> - Make figures and numerical results easy to understand.
> - Use simple English suitable for oral presentation.
> - Summarise the main findings and next steps.
> - Check the rendered slides for overflow and misalignment.
>
> Return the final editable PPTX.

---

## 9. Presentation File Management

### Permanent Template

`08_Project_Management/Weekly_Presentation_Template.md`

Do not overwrite this reusable template with weekly research results.

### Recommended PPT Naming

```text
week_XX_draft.pptx
week_XX_updated.pptx
week_XX_final.pptx
```

### Recommended GitHub Storage

Store completed presentations in an appropriate weekly presentation directory when needed.

Avoid creating unnecessary duplicate PPT versions in the repository.

The latest editable PPTX should be provided when requesting further slide modifications.

---

## 10. Final Presentation Checklist

- [ ] Research question is clear.
- [ ] Motivation is explained.
- [ ] Methods are supported by theory or literature.
- [ ] MATLAB results are actual verified outputs.
- [ ] Figures have readable labels and legends.
- [ ] Numerical values include units and conditions.
- [ ] Limitations are stated.
- [ ] Slide formatting is consistent.
- [ ] English sentences are short and understandable.
- [ ] Final conclusions follow from the evidence.
- [ ] Next research tasks are identified.
- [ ] PPTX remains editable.

---

**Guiding Principle:** A weekly research presentation should explain the research problem, the method, the evidence and the resulting decision — not simply list completed tasks.
