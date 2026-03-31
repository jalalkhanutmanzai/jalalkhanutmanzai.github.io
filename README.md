# jalalkhanutmanzai.github.io

## Accessibility: Contrast Guardrails

This site uses a token-based color system in `assets/css/style.scss`. Keep text and UI pairings within these approved contrast-safe combinations:

### Text contrast-safe token map (AA normal text, >= 4.5:1)
- `--text` on `--bg`
- `--text` on `--surface`
- `--muted` on `--surface`
- `--accent` on `--surface`
- `--accent-ink` on `--accent-weak`
- `#ffffff` on `--accent`
- `#ffffff` on `--accent-2`
- `#ffffff` on `--accent-hover`
- `#ffffff` on `--accent-active`
- `--disabled-text` on `--disabled-bg`

### Non-text contrast map (WCAG 1.4.11, >= 3:1)
- `--ring` on `--surface` (focus indicator)
- `--control-border` on `--surface` (inputs/controls)
- `--accent` on `--surface` (accent outlines and borders)

## Automated contrast gate (CI)

The workflow `.github/workflows/contrast-gate.yml` runs:
1. `ruby scripts/contrast_audit.rb`
2. `bundle exec jekyll build`

The audit blocks merges if any required text contrast drops below `4.5:1` or non-text contrast drops below `3:1`.

## Manual QA pass (keyboard + zoom)

Before shipping visual changes, do one manual pass at 200% zoom and keyboard-only navigation:
- Tab through header links, hero CTAs, form fields, and submit button
- Confirm visible focus outline on all interactive elements
- Confirm text remains readable and no clipping/overlap appears at 200% zoom
