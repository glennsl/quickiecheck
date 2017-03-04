# Quickiecheck - a BuckleScript quickcheck implementation

Alternative name: "recheck"

Why make another quickcheck implementation when there are already `n` dusty implementations for OCaml?

1. Because BuckleScript targeting JavaScript means you can do _evil_ things.
2. Because I wanted an API that could easily integrate with `bs-jest` (or whichever test runner you'd prefer)