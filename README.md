# Gambit for Mimosa

This repository contains a fork of the [Gambit Scheme interpreter/compiler](https://github.com/gambit/gambit). 
It contains some modifications to allow it to communicate with the Mimosa operating system and is designed to be cross-compiled for Mimosa.

Modifications include:
- Different header file for the `gambit.h`
- Usage of the `set_gstate` function provided in the Mimosa `stdio` standard library
- Implementation of direct memory access FFI functions
- Change of the prompt message
