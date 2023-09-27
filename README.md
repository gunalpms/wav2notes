# wav2notes v0.1
## Polyphonic Pitch Detection for Classical Guitar Using the Julia Programming Language

#### Research paper is available at the root directory.
==================================
## What is wav2notes?
* wav2notes is a project designed to help people determine musical notes from classical guitar audio
* Can't identify musical notes by ear? Do not worry, wav2notes has your back!
* Currently can extract musical notes from chords and arpeggios.
* Does not miss any musical notes, false positives are generally easily identifiable by the end user.
* Fast, simple algorithmic approach developed by analysing the sound signature of the classical guitar
==================================
## Getting started:

### Running the program:
* Tested with the Julia Programming Language v1.8.5 / No problems should occur on other modern versions of Julia
* Install the DSP, Plots, OffsetArrays and Wav packages.
* Navigate to the /src directory in your terminal.
* Open the test.jl file and go to the bottom after reading the comments on top of the main function.
* Modify the example function call for your needs. 

### Reporting issues:
* Discord @faradaykafesi
* Open an issue with the steps and environment to reproduce the issue.

### Future:
* Increasing the precision of the algorithm.
* Support for 6+ String classical guitars.
* Prettier output for the user.
* Possibly a version written in Rust to compile to WASM and run in a browser. 
