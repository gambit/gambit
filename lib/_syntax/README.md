# Hygienic Macro System Implementation

## Full Integration Check-list:

- Fix bootstrap (in progress)

- GSC
  - merge the parse-program phase to the hygienic `compile` phase.

- GSI
  - merge the original `compile-top` phase with 
    the hygienic `compile` phase and add more unit-tests for the command-line's stepper.

- Performance
  - general optimizations

- Correctness
  - Fix `define-library` by removing references to the old syntax system.
    - Some modules (from `make modules`) were not tested for correctness yet.
  - Fix `make checks` as strings comparaison doesn't work anymore 
    with renamed identifiers.


