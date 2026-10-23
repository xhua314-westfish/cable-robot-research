# how to use:

<img width="1380" height="468" alt="image" src="https://github.com/user-attachments/assets/26149831-7e81-40bb-9a84-f602dad419fa" />

根据 GitHub 中的 Weekly_Presentation_Template.md 和本周的 weekly plan，帮我生成这周的英文 PPT 框架。保留结果空位，周五用于 research presentation。

# Weekly Research Presentation — Reusable Template

**Version:** v1.0  
**Purpose:** Turn a weekly research plan into an editable PPT skeleton at the start of the reporting week, fill it with verified daily progress, and have a presentation ready by Friday.  
**Application:** Cable-robot-based passive 6-DOF balloon pose sensing (also reusable for later project stages).  
**Recommended GitHub location:** `08_Project_Management/Weekly_Presentation_Template.md`  
**Important:** This is a **permanent reusable template**. Do not overwrite it with each week's records.

---

## 1. Weekly workflow

| When | Input | ChatGPT's task | Deliverable |
|---|---|---|---|
| **Start of reporting week** | This template + current weekly plan + latest research state | Identify the week's tasks and create an English, editable 16:9 PowerPoint **skeleton** with prepared evidence slots | Draft `.pptx` |
| **Each research day** | Latest PPTX + actual code/results/screenshots/notes | Update only the relevant slides; distinguish verified results from plans | Updated `.pptx` |
| **Friday** | Latest PPTX + verified weekly outputs | Consolidate findings, blockers, next steps; simplify language and check slide rendering | Presentation-ready `.pptx` |
| **After presenting** | Feedback + incomplete tasks | Record carry-over work in the existing research log / next plan **if requested** | Research log / next plan |

**Calendar rule:** Some weekly plans span dates other than Monday–Friday (e.g. Thursday–Wednesday). If the Friday presentation occurs before the plan's final date, treat Friday as the **reporting cutoff**. Mark tasks scheduled for later dates as *upcoming*, never completed. Preserve actual task dates rather than silently moving them.

**Goal:** Research → evidence → presentation. The PPT should emerge from daily work, not become a separate large task on Friday.

---

## 2. Source files and evidence priority

Use the **latest available** versions relevant to the active week:

1. **Weekly plan:** for example, `08_Project_Management/weekly_plan_02.md`, replaced by the current plan each week.
2. **Milestone TODO:** for example, `08_Project_Management/current_october_november_todo.md`.
3. **Research direction:** `CURRENT_STATE2.md`, `05_My_Research/Sensing_Objective_v0.2.md`, or newer replacements.
4. **Actual evidence:** MATLAB `.m` scripts, figures, printed outputs, numerical checks, paper notes and `06_Research_Log` entries.
5. **Latest PPTX:** the most recently edited draft for this week (attach it or provide an accessible, verified GitHub file).

**Evidence priority:** Actual verified output and dated notes > task checkboxes > future plans. A planned task is not proof of completion. If sources disagree, identify the difference and use the newest verifiable evidence.

**Minimum kickoff inputs:** This template, the active weekly plan, and the reporting dates. No completed results are required to make a skeleton.

**Minimum daily inputs:** Latest PPTX plus the actual work completed today (even one screenshot or a partial result is enough). Do not claim to have updated an unavailable presentation file.

---

## 3. Week-specific information — fill when starting a new week

Do not edit the permanent template to store these values. Enter them in the weekly chat or a separate weekly log.

| Field | Value |
|---|---|
| Reporting period | `[YYYY-MM-DD to YYYY-MM-DD]` |
| Friday presentation date | `[YYYY-MM-DD]` |
| Active weekly-plan path | `[GitHub path / link]` |
| Main research question | `[One clear question]` |
| Key tasks / milestone IDs | `[A2 / A3 / B1 / etc.]` |
| Intended deliverables | `[Code / plot / numeric verification / paper reproduction]` |
| Already verified before this week | `[Evidence / date / None]` |
| Key paper(s) and DOI | `[Links or TBD]` |
| Latest draft PPTX | `[Uploaded file / confirmed GitHub path]` |

Use **TBD** for genuinely unknown fields. Do not invent values.

---

## 4. Start-of-week PPT skeleton rules

- **Language:** English only inside the slides; prefer keywords, short phrases and simple diagrams. Discussion with me can remain in Chinese.
- **Format:** 16:9, clean academic style, visually consistent with the most recent presentation when available.
- **Length:** Usually **6–8 slides**, adjusted to actual tasks. Never create filler slides just to reach a fixed count.
- **One core point per slide:** Question, method, implementation, evidence, verification or decision.
- **Editable objects:** Use PowerPoint text boxes, tables, shapes, arrows and charts whenever practical; embedded MATLAB/paper images are acceptable with captions and source information.
- **Skeleton only at kickoff:** Pre-fill known objective, literature, equations and intended validation methods; reserve space for results using visible placeholders.
- **Stable slide IDs:** Use **S1, S2, ...**. Keep established titles and ordering stable during daily updates unless a change is needed and explained.
- **Never invent:** Completed methods, tested geometry, numerical accuracy, code execution, paper agreement or visuals described as experimental results.

### Default slide allocation

| Slide | Proposed title | Fill at week start | Complete during the week |
|---|---|---|---|
| **S1** | Weekly Goal & Research Question | Research aim, scope, dates, milestone IDs | Only if scope changes |
| **S2** | Weekly Plan & Deliverables | Compact day-by-day work plan | Real completion status: done / in progress / blocked |
| **S3** | Background & Reference Method | 1–3 relevant papers, principal equation/algorithm | Method understanding and corrected assumptions |
| **S4** | Mathematical / Algorithmic Approach | Inputs, outputs, equations, verification checklist | Actual derivation and implemented method |
| **S5** | MATLAB Implementation | Expected scripts, workflow and test parameters | Real scripts, settings and screenshots/code excerpt |
| **S6** | Results & Visual Evidence | **[RESULT PENDING]**, reserved plot/table area | Actual figures, values, conditions and captions |
| **S7** | Verification & Interpretation | Expected vs actual / checks planned | Verified results, discrepancies and limitations |
| **S8** | Current Status & Next Steps | Current milestone and next intended tasks | What was done, unresolved problems and handoff |

**Adapt the allocation:** For one major algorithm, use more space for implementation and results. For several workstreams, split results by task. Merge or delete irrelevant slots rather than forcing every heading into every week. Keep an end-of-week summary slide.

### Status labels

- **PLANNED:** Scheduled, not started.
- **IN PROGRESS:** Work started; results not fully verified.
- **RESULT PENDING:** Placeholder with no actual output.
- **PARTIAL:** Some checks passed; limitations or discrepancies remain.
- **VERIFIED:** An explicit numerical or visual check passed against defined criteria.
- **BLOCKED:** A specific problem is preventing progress.

A MATLAB script running without errors is **not automatically VERIFIED**.

---

## 5. Daily update — reusable record

Copy this block into the day's message or research log:

**Date:** `[YYYY-MM-DD]`  
**Task ID:** `[A2 / A3 / B1 / ...]`  
**Today's objective:** `[One short sentence]`  
**What I actually completed:** `[Specific action]`  
**Code / files:** `[Filename or GitHub path]`  
**Plots / numerical values:** `[Filename, unit, parameters, scenario]`  
**Verification:** `[How checked; pass/fail/not checked]`  
**Status:** `[PLANNED / IN PROGRESS / PARTIAL / VERIFIED / BLOCKED]`  
**Issue or discrepancy:** `[Specific problem or None]`  
**Tomorrow's next step:** `[One concrete action]`  
**Slide(s) to update (optional):** `[S4 / S5 / S6 / ...]`

### How ChatGPT should update the slides

1. Read the **latest actual PPTX**, the plan and the day's evidence.
2. Identify the corresponding **existing slide ID**; do not reconstruct the entire presentation unnecessarily.
3. Replace placeholders only when outputs exist; include **units, parameters, method, and concise source/figure captions**.
4. Update **S2** (progress) and **S8** (next steps / blockers) as needed.
5. Preserve previously verified content unless new evidence corrects it.
6. Export the revised, editable `.pptx` and check cropping, overflow, readability and slide-to-slide consistency.
7. State which slides changed, what is still unverified and which result is needed next.

**If there is no numerical result today:** Update method understanding, code status or blockers. Do not fabricate figures or force an empty results slide.

---

## 6. Friday finalization checklist

- [ ] Weekly goal and scientific question remain accurate.
- [ ] The results section reflects **actual work**, not planned work.
- [ ] Every important numeric result has units, conditions and a source or calculation.
- [ ] Paper figures have clear citation/credits (on slide or in speaker notes).
- [ ] Results use correct status: VERIFIED / PARTIAL / BLOCKED.
- [ ] Negative results and unexpected differences are not hidden.
- [ ] Paper reproduction is visibly separate from the **new balloon-system work**.
- [ ] PPT wording is concise and clear enough for a short English presentation.
- [ ] Tables and figures are readable on a 16:9 projected slide.
- [ ] Last slide highlights **completed work + remaining issues + 1–3 next actions**.
- [ ] Empty slots are removed or clearly identified as future work.

### Project-specific scientific guardrails

- **Anatomical bounding box ≠ balloon-centre feasible region ≠ sensing workspace.**
- **WCC / TF (force feasibility) ≠ Jacobian rank / covariance / RMSE (sensing performance).**
- **6 cables** are the measurement baseline; **7/8 cables** are research candidates, not a proven accuracy ranking.
- **Original paper method reproduction ≠ system-specific anchor/attachment optimization.**
- **Anchor** `A_i` is fixed in the world frame; **attachment** `r_i` is fixed in the balloon body frame; `B_i = P + R*r_i`.
- Balloon motion remains **passive and unknown**, whereas low-tension motors are only a proposed cable-tracking mechanism.

---

## 7. Copy-and-send ChatGPT instructions

### A. At the beginning of each week

> Use **Weekly_Presentation_Template.md** and my current **[weekly plan path/link]** to generate this week's English **editable PPT skeleton** for **[dates]**, with a Friday presentation on **[date]**. Read the latest GitHub research state and milestones. Create about 6–8 concise slides with stable S1–S8 IDs, relevant methods/references and visible result placeholders. Do not invent completed work or results. Return the `.pptx` and a short mapping between weekly tasks and the slide slots.

### B. After each day's work

> Update **the attached latest weekly PPTX** using today's actual work: **[task, code, findings, images and verification]**. Only change the relevant slides and progress/next-steps sections. Preserve the existing style, slide IDs and verified material. Return the updated editable PPTX and a short note explaining what changed and what remains pending.

### C. On Friday

> Use **the latest weekly PPTX** and this week's verified MATLAB scripts, figures and research notes to finalize my Friday presentation. Use short, clear English, and do not invent any result. Clearly distinguish completed, partial and blocked work. Include the main results and next steps, check all slide renderings, and give me the final editable PPTX.

---

## 8. File naming and storage

**Permanent reusable template:**  
`08_Project_Management/Weekly_Presentation_Template.md`

**Draft/update/final decks:**  
`weekly_progress_YYYY-MM-DD_draft.pptx`  
`weekly_progress_YYYY-MM-DD_updated.pptx`  
`weekly_progress_YYYY-MM-DD_final.pptx`

**Suggested location for final PPT in GitHub (create when needed):**  
`08_Project_Management/Weekly_Presentations/YYYY-MM-DD/`

**Practical file handling:** Use the most recent PPTX in the same conversation, or reattach the latest PPTX when switching conversations. Saving only the final Friday PPTX to GitHub generally avoids needless daily binary-file commits. GitHub plans and notes remain the source for task status.

---

## 9. Weekly success criterion

The Friday PPT is successful if it answers four questions:

1. **What did I plan?**
2. **What did I actually complete?**
3. **What evidence proves the result—or explains the blocker?**
4. **What will I do next?**

**Guiding principle:** The weekly PPT is a by-product of daily research, **not another project to complete on Friday**.
