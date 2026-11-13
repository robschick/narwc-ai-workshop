# Exercise 05 — Documentation in the prompt

**Time:** 17 minutes. The most useful habit in this workshop. **Tool:** the
Posit Assistant chat pane.

In this exercise you ask the assistant for the same R function twice: first
from what it already knows, then with the package documentation in front of
it. Then you check the second one against real data and compare the two.

The prompt, used in steps 1 and 3:

> Without reading any files or running any code, write a function that takes
> a data frame of detection times and a fixed recorder location, and returns
> the same data frame with sea surface temperature joined on, pulled from
> ERDDAP using {rerddapXtracto}. Keep it concise, no error handling, roxygen2
> docs with one example, and the same example again as plain R code after the
> function.

## Step 1 — Ask without the docs

Start a new chat. Set the assistant to ask before it runs anything (the
approval setting under the chat box) and turn **web search off** (the globe
icon). Then send the prompt as written.

If it asks to read a file or run code, say no, and note what it wanted. Left
alone, it goes looking: through the project, through the package's help, and
out to the ERDDAP server itself. That's often useful, but here it would mean
the answer isn't from memory alone.

Paste its answer into `step1.R`, next to this file. Source it, then run the
plain example line by line. Does the code use real function names? Real
arguments? Does it run? Do the roxygen docs describe what the code does?

## Step 2 — Fetch the docs

The package's documentation lives in its vignette,
[Using rerddapXtracto](https://rmendels.github.io/UsingrerddapXtracto.html).
Find the section **"An `rxtracto` example"** and copy all of it, text and
code, as it is. Don't summarize it: the point is that the assistant sees the
real documentation. If the next section, "Plotting the results", uses the
columns `rxtracto()` returns, copy that part too.

Open `docs.md`, next to this file, paste on a new line **below** the comment
(the line ending `-->`), and save.

## Step 3 — Ask again, with the docs

Start a new chat and set approval to ask again. Type `@` and choose `docs.md`
to attach it, then send the same prompt, and say no if it asks to read or run
anything. Paste its answer into `step3.R`.

## Step 4 — Check it

Source `step3.R`, which replaces the step 1 version of the function, and run
it on `calls` for the real recorder location (42.066 N, 70.2719 W, from
`data/data-dict.yaml`) and a two-day window from the deployment, e.g. 28–29
March 2009. Sanity-check the values: is that a plausible SST for this place
and season? The function running is not the same as the data being right.

## Step 5 — Compare them

Before you ask, read the two files yourself, with what step 4 showed you in
mind. Which would you use, and why? Write it down in a sentence.

Then start a new chat and set approval to ask. Type `@` and attach both
`step1.R` and `step3.R`, and send:

> Can you compare these two functions and see which is better? Please tell me
> why, and suggest how they could be made stronger and more reproducible.

Say no if it asks to run anything: this step is about reading the code. Did
it pick the one you picked? Did it find anything you missed, or miss anything
you found? Its suggestions are more code you'd have to check.
