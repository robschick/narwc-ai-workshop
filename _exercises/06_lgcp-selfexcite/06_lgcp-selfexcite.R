# Exercise 06 — A GAM LGCP, assistant-driven ----------------------------------
# Time: 20 minutes.
#
# The loop you are practising:
#   state the model -> let it draft -> READ the draft -> correct the
#   parameterisation in words -> refit.
#
# Do not let it choose the model for you. You decided that in exercise 02.
#
# Start clean: restart R (Session -> Restart R) and start a new chat. The
# assistant sees your R session and the whole conversation so far, so objects
# and answers left over from earlier exercises shape what it writes. Your
# hourly counts from exercise 04, for example, may not be in local time.

library(dplyr)

calls <- readRDS(here::here("data/narw_upcalls.rds"))

# Ask the assistant, in this order:
#
# 1. "Bin `calls` into hourly counts using local time (`Etc/GMT+5`), in a
#     data frame `hourly` with columns `start` (the start of each hour) and
#     `n` (the number of calls). Then fit a Poisson GAM with mgcv, called
#     `fit_gam`: a cyclic smooth over hour of day plus a smooth over time.
#     This is a discretised log-Gaussian Cox process."
#    -> before you read the draft, open `data/data-dict.yaml`. Find what it
#       says about the time zone (the `time` column), row order and duplicate
#       start times (`details`, under `tables`), and `Possibly_Detected` (the
#       `confidence` column). That is your list of the data decisions this
#       model needs.
#
#       Now read the draft against that list. Which decisions did it make
#       without asking you? Which did it skip?
#
#    Those decisions are yours. For each one, ask before you change anything:
#
#      "The data dictionary says the rows aren't in time order, and you
#       didn't sort them. Does that matter for this model?"
#
#    Sometimes the answer is that it doesn't matter here, and that can be
#    right: hourly counts don't depend on row order. Otherwise, decide, tell
#    it what you decided, and have it refit. Correct it in words, not by
#    editing its code yourself.
#
#    To decide first instead, open the chat with: "Before you write any code,
#    list the decisions about the data this needs and ask me about each one."
#
# 2. "Plot the fitted hourly intensity against the observed hourly counts."
#
# When you believe the fit, save it and the counts. Exercise 07 starts from
# these files, not from your R session:
#
#   saveRDS(fit_gam, here::here("fit_gam.rds"))
#   saveRDS(hourly, here::here("hourly.rds"))
#
# 3. (Optional, if you finish early.) Work on one day:
#
#      snippet <- calls |> filter(day == 3) |> arrange(time)
#
#    "Add a self-exciting term to a model of `snippet`: a call makes another
#     call more likely in the following few minutes."
#    -> check the bins against the decay time. If the kernel decays over
#       minutes and the bins are an hour wide, what can the term actually see?
#       Does the fit change when you change the decay time?
#
#    If you get a fit you believe, save it for exercise 07, with the decay
#    time and the bin width, both in minutes. If the decay time was fixed or
#    picked from a grid, it isn't stored in the fit. If you're not sure how
#    the kernel is written, ask now, while the assistant is on: "What is the
#    decay time of this kernel, in minutes?"
#
#      saveRDS(
#        list(fit = fit_selfexcite, decay_min = ..., bin_width_min = ...),
#        here::here("fit_selfexcite.rds")
#      )
