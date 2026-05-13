# Uruk

A linear-non-linear graded programming language based on the LNL-RMM calculus
from "The Relative Monadic Metalanguage" (Liell-Cock, Shirazi, Staton; POPL 2026).

## Status

In active development. Currently building **v0**: the LNL-RMM kernel with a single
built-in graded primitive (`tick`) over the `(ℕ, +, 0)` grade theory. v0 demonstrates
the Ground/Computation type split, the linear discipline on computation types, and
grade arithmetic — without user-definable effects or handlers.

User-defined operations are planned for v1; handlers for v2.

## Building

```
cabal build
cabal test
cabal run uruk -- path/to/program.uk
```

`alex` and `happy` are fetched automatically as build dependencies.

## Repository layout

- `src/` — the compiler/interpreter
  - `Types.hs`, `Syntax.hs` — core data types and term AST
  - `Parsing/` — lexer, parser, surface syntax, desugarer
  - `Inference/` — bidirectional type checker, grade-equation solver
  - `Environment.hs`, `Eval.hs` — runtime
- `test/` — test harness driving `.uk` files in `test/cases/`
- `paper.pdf` — the LNL-RMM paper this language implements
