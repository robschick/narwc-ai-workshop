# Exercise 09 — The same question, locally ------------------------------------
# Take-home, after the workshop. Requires Ollama running and a model pulled.
#
# Two ways to do this, and the first is the point:
#
#   1. In Posit Assistant, switch the model provider to your local Ollama model.
#      Same pane, same workflow, same /plan mode — only the provider changed.
#      Re-ask the exercise 02 planning question and compare the answer.
#
#   2. Or call it directly from R with {ellmer}, below. Not installed by
#      _setup.R: install.packages("ellmer") first.

library(ellmer)

local_chat <- chat("ollama/llama3.1:8b", echo = "output")
local_chat$chat("In two lines, why is a right whale up-call called an up-call?")

# Now give it something real: the summary of your fit from exercise 06. A
# summary holds no raw data, so it is the kind of thing you might hand a local
# model when the data themselves can't leave your machine.

library(mgcv)

fit_gam <- readRDS(here::here("fit_gam.rds"))

local_chat$chat(paste(
  "This is the summary of a Poisson GAM of hourly counts of right whale",
  "up-calls over one week. Explain in plain language what it says, then",
  "list anything in it a reviewer should worry about.\n\n",
  paste(capture.output(summary(fit_gam)), collapse = "\n")
))

# Mark its answer against what you found in exercise 07:
#
# - What does it say the smooth over time is? Check your exercise 06 prompt.
# - How does it read the intercept? The model is on the log scale.
# - Does it notice `Scale est. = 1`? What was your dispersion in 07?
# - What did it get right? What did it invent?
#
# Then compare it with the cloud assistant's critique in 07, part 4.

# It will be slower and worse. That is the honest comparison. The point is the
# trade: embargoed data, permitted data, data under a non-disclosure agreement,
# no cloud access, no budget — for those, worse-but-local is the right answer,
# and because the assistant is the same the workflow is otherwise identical.
