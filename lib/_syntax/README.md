# Hygienic Macro System Implementation

## Dev Integration Check-list:

- Integrate compilation environment
  - re-integrate interface for gsc's env
  - merge hygiene's compile phase to gsc's macro expansion phase

- Performance
  - general optimizations

- Correctness
  - Fix `define-library` by removing references to the old syntax system.
    - Some modules (from `make modules`) were not tested for correctness yet.
  - Fix `make checks` as strings comparaison doesn't work anymore 
    with renamed identifiers.

## Full Integration Check-list:

- GSC
  - merge the parse-program phase to the hygienic `compile` phase.

- GSI
  - merge the original `compile-top` phase with 
    the hygienic `compile` phase and add more unit-tests for the command-line's stepper.

