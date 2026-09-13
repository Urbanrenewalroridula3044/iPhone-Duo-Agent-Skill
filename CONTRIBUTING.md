# Contributing

Thanks for helping keep these skills accurate.

## Good contributions

- **SDK updates.** When a new Xcode ships, run `python3 scripts/sdk_api_check.py`, update
  the measured snapshot in `references/api-availability.md`, and fix any sample whose
  spelling changed. Say which Xcode build you checked.
- **Scanner rules.** Add a `Rule` to `scripts/duo_scan.py` with a session citation, a
  positive and a negative test in `tests/test_duo_scan.py`, and a row in
  `READINESS-CHECKS.md`.
- **False positives** found on real projects, with a minimal reproduction.
- **Evals** for behavior the skills get wrong: add a case to
  `skills/<skill>/evals/evals.json` (with a small fixture project under
  `skills/<skill>/evals/files/`) or a query to `skills/<skill>/evals/trigger-evals.json`.

## Rules

- Guidance must trace to an Apple session, documentation page or the SDK. Label
  anything else as inference.
- Edit shared references and scripts at the repository root, then run
  `python3 scripts/sync_skill_copies.py`.
- No third-party Python dependencies.

## Evaluating a change

The skills are developed with Anthropic's
[skill-creator](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator):
run each eval with and without the skill, grade the expectations, aggregate a benchmark,
and review outputs in its viewer. Trigger accuracy is tuned with its `run_loop` against
`trigger-evals.json`. Keep workspaces outside the repository (`*-workspace/` is ignored).

## Checks

```bash
python3 scripts/sync_skill_copies.py --check
python3 -m unittest discover -s tests -v
```
