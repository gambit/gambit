# Hygienic Macro System Implementation

## Full Integration Check-list:

- Bootstrap progress:
  - phase1 make (/)
  - phase1 make ut (/) 320/320
  - phase1 make modules (?)
  - phase2 make (/) (2 warnings)
  - phase2 make ut (/) 320/320
  - phase2 make modules (?)
  - phase3 make (?) 
  - phase3 make ut (?)
  - phase3 output == phase2 output (?)

- GSC
  - merge the parse-program phase to the hygienic `compile` phase. (might not be required)

- GSI
  - merge the original `compile-top` phase with the hygienic `compile` phase. (might not be required)
  - add more unit-tests for the command-line's stepper.

- Performance
  - general optimizations (Now ~2x initial speed, need real benchmark)

- Correctness
  - Fix `define-library` by removing references to the old syntax system.
    - Some modules (from `make modules`) were not tested for correctness yet.
  - Fix `make checks` as strings comparaison doesn't work anymore with renamed identifiers.


