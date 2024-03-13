# hygienic macro system implementation

## Dev Integration check-list:

- Integrate interpretation envrionment
  - Use the "descriptor" structure instead of plain procedure for
    macro definition's expansion.
  - serialise compilation environements.

- Integrate compilation environment
  - merge (phase 1) changes to this branch
    - either 

- Performance
  - general optimizations

- Correctness
  - Fix `define-library` by removing references to the old syntax system.
    - Some modules (from `make modules`) were not tested for correctness yet.
  - Fix `make checks` as the string comparaison doesn't work anymore 
    with hygienically renamed identifiers.
  - rename `plain-datum->syntax` as `datum->syntax`
    rename `datum->syntax` as `source->syntax`.

## Full Integration check-list:

- Syntax
  - Completely remove every references to the old macro system.
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

