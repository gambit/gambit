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

- Performance
  - general optimizations (Now ~1.5-2.0x initial speed)
  - heap allocation (Now ~2.2x initial heap allocation)

- Tests
  - add more unit tests

- GSC
  - merge the parse-program phase to the hygienic `compile` phase. (might not be required)

- GSI
  - merge the original `compile-top` phase with the hygienic `compile` phase. (might not be required)


