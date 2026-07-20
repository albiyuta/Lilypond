# Lilypond

Embedding [LilyPond](https://lilypond.org/) scores directly in a LaTeX document
with [lyluatex](https://github.com/jperon/lyluatex).

`lyluatex` runs LilyPond on an external `.ly` file at compile time and inserts
the engraved score into the text, so the score and the prose live in a single
source tree — no manual export of image files.

## Contents

| File | Description |
| --- | --- |
| `Score.tex` | The LaTeX document. Includes both scores below. |
| `Bach_BWV846.ly` | J.S. Bach, Fugue in C major, BWV 846 — first exposition, with the voices colored by function. |
| `Beethoven_op106.ly` | Beethoven, Piano Sonata No. 29, Op. 106 — opening of the finale. |
| `Score.pdf` | Compiled output. |

## Usage

A score is included with a single command giving the path to the `.ly` file:

```latex
\usepackage{lyluatex}
...
\lilypondfile[staffsize=16, line-width=150mm]{Bach_BWV846.ly}
```

## Building

```sh
lualatex --shell-escape Score.tex
```

Shell escape is required, since `lyluatex` needs to invoke the `lilypond`
executable.

## Requirements

- LuaLaTeX (TeX Live 2025 or comparable) with the `lyluatex` package
- LilyPond 2.24 or later, on `PATH`
- Ghostscript on `PATH` (optional; without it `lyluatex` warns about rounding
  errors in the score bounding boxes)

## License

MIT — see [LICENSE](LICENSE).
