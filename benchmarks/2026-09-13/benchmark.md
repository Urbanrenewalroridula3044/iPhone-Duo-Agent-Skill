# Skill Benchmark: iphone-duo-skills

**Model**: claude-opus-5
**Date**: 2026-09-13T04:22:05Z
**Evals**: 1, 2, 3, 4, 5, 6 (1 runs each per configuration)

## Summary

| Metric | With Skill | Without Skill | Delta |
|--------|------------|---------------|-------|
| Pass Rate | 100% ± 0% | 56% ± 19% | +0.44 |
| Time | 250.3s ± 112.5s | 152.8s ± 39.8s | +97.4s |
| Tokens | 62024 ± 16823 | 34903 ± 4920 | +27121 |

## Notes

- Iteration 2 used stricter assertions (pinned session timestamps, SDK separation, no guessed code behind compile-time guards, preserved behavior, typecheck evidence). The no-skill baseline outputs were reused from iteration 1 and regraded, so the baseline drop from 70% to 56% reflects the stricter rubric, not new runs.
- With the skill every assertion passed in all six evals (51/51); the iteration-1 failure (eval 4, overflow menu) is resolved by the refined bars guidance that allows a named Filter menu with its own symbol.
- Most discriminating assertions: SDK separation / 27.1 availability (fails in 5 of 6 baselines), pinned session timestamps (fails in all baselines), and 'do not ship guessed 27.1 calls behind compile-time guards' (baseline eval 2).
- Eval 5 remains the largest gap (8/8 vs 2/8): the baseline paginates the article at the crease and never checks reserved-region availability.
- Cost: the skill adds about 97 s and 27k tokens per task on average; eval 1 (full readiness plan) and eval 3 (edits + typecheck + rescan) are the slowest at roughly 6.5 minutes each.
- Process issue found by the run, not by any assertion: eval 3's executor ran `xcrun agent skills export` without --output-dir inside the plugin folder; the skill text now shows the temporary-directory command.
- Grader-flagged soft spots: eval 5's 'inactive division region' pass relied on paraphrase; eval 2 offered rather than applied the compiling alternative. Single run per configuration, so variance is not measured.