# Hygienic Macro System Implementation

## Full Integration Check-list:

- Bootstrap progress:
  - [x] phase1 make
  - [x] phase1 make check (up to golden-file like changes)
  - [x] phase1 make ut
  - [x] phase1 make modules

  - [x] phase2 make
  - [x] phase2 make check (up to golden-file like changes)
  - [x] phase2 make ut
  - [x] phase2 make modules

  - [x] phase3 output == phase2 output

  - Bug / Todo: 
    - srfi 158(:428):
      - macro-force-vars: 
          declare expanded binding causes map -> ##map and thus accept dotted tail parameter

- Tests
  - add more unit tests

- GSC
  - merge the parse-program phase to the hygienic `compile` phase. (might not be required)

- GSI
  - merge the original `compile-top` phase with the hygienic `compile` phase. (might not be required)
  - add more unit-tests for the command-line's stepper.

- Performance
  - general optimizations (Now ~2x initial speed, need find/create real benchmark)

- Correctness
  - Fix `define-library` within hygienic system (fixed?)


