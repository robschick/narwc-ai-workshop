# Using AI in the Analysis of Marine Ecological Data

The project for the NARWC 2026 workshop: one dataset, seven days of North
Atlantic right whale up-call detections, and the exercises we'll work through
together.

## Before the workshop

1. Open `narwc_workshop.Rproj` in RStudio or Positron.
2. Run `_setup.R`. It installs the packages the exercises use and checks that
   the data load. It should end with `Setup OK: 8256 up-calls loaded.`

## What's here

```
_exercises/   one folder per exercise, in the order we'll do them
data/         narw_upcalls.rds, and data-dict.yaml, which describes it
_setup.R      run once before the workshop
```

Read `data/data-dict.yaml` before you analyse anything. It says what each
column means and what in the data needs a decision from you.

The data are public: the DCLDE 2013 dataset, NOAA NCEI. This material is
licensed CC-BY; see `LICENSE.md`.
