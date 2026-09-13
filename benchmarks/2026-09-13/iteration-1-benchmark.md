# Skill Benchmark: iphone-duo-skills

**Model**: claude-opus-5
**Date**: 2026-09-12T19:37:05Z
**Evals**: 1, 2, 3, 4, 5, 6 (1 runs each per configuration)

## Summary

| Metric | With Skill | Without Skill | Delta |
|--------|------------|---------------|-------|
| Pass Rate | 98% ± 6% | 70% ± 20% | +0.28 |
| Time | 198.0s ± 81.3s | 152.8s ± 39.8s | +45.2s |
| Tokens | 59145 ± 21118 | 34903 ± 4920 | +24242 |

## Notes

- Baselines were strong: every without_skill run searched the web and found Apple's iPhone Duo tech talks, so the delta measures the skill's workflow (SDK verification, citations, approval gate, scoped edits), not access to information.
- The largest gap is eval 5 (centered-column-and-fold): 6/6 with skill vs 2/6 without. The baseline proposed paginating the article into two pages split at the crease, contradicting Apple's 'scrolling content does not displace' guidance, and never checked reservedRegions against the SDK.
- Eval 2 (missing-27-1-sdk): both runs refused to write uncompilable code, but the baseline offered guessed 27.1 calls behind a compile-time guard and nothing that builds today (3/5 vs 5/5).
- Eval 4 (toolbar-audit) does not discriminate (6/7 both): the with_skill run failed the ToolbarOverflowMenu assertion by giving the filter menu its own symbol instead, a defensible design the assertion is too narrow to accept; the baseline failed only on SDK availability.
- The citation-count assertions pass on presence of any timestamp; graders flagged they would pass fabricated timestamps. Iteration 2 pins claims to specific session timestamps.
- With the skill, runs cost more: +45 s and roughly +24k tokens on average (eval 1 used ~100k tokens vs ~41k), mostly from reading references and running the scan and SDK check.
- Programmatic checks: no run modified files where the prompt asked for a plan; eval 3 edits were typechecked by the with_skill run, not by the baseline, which also restructured the documented DockBleedModifier without asking.