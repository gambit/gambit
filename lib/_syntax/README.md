# hygienic macro system implementation

## Dev Integration check-list:

- Integrate compilation environment
  - choose the best approach to finalize the two env merging

- Performance
  - general optimizations

- Correctness
  - Fix `define-library` by removing references to the old syntax system.
    - Some modules (from `make modules`) were not tested for correctness yet.
  - Fix `make checks` as the string comparaison doesn't work anymore 
    with hygienically renamed identifiers.

## Full Integration check-list:

- Syntax
  - Investigate the strategies used to accelerate the compilation
    of those old syntax construct and make sure we do the same when we can.
  - Complete hygiene would rejects programs with undeclared identifiers. 
    Fill up the environment or accept unknown global?

- GSI
  - merge the original `compile-top` phase with 
    the hygienic `compile` phase. 
  - Make sure the stepper doesn't interfere with the hygiene algorithm. (more unit tests required)

- GSC
  - merge the parse-program phase to the hygienic `compile` phase.

