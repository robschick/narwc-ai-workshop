# Exercise 07 — Check the fit yourself ----------------------------------------
# Time: 15 minutes.
#
# =============================================================================
#   CLOSE THE ASSISTANT PANE NOW. Parts 1-3 are done without it.
#   You turn it back on in part 4.
# =============================================================================
#
# Why without it: all morning the assistant has written the code and you have
# read it. If the only way you can check its fit is to ask it, you haven't
# checked it. A model that made a mistake tends to explain it away, as you saw
# in exercise 03. So first find out for yourself what's wrong with the fit.
# Then, in part 4, ask the assistant to review it. That is the one time today
# you know the answers before it does, so you can mark its review.
#
# The code for each check is written for you. Run it and answer the question
# in your own words. The questions are the exercise; the code isn't.

library(dplyr)
library(ggplot2)
library(lubridate)
library(mgcv)

# `hourly.rds` and `fit_gam.rds` are the files you saved at the end of
# exercise 06, in the project folder (the one with narwc_workshop.Rproj).
calls <- readRDS(here::here("data/narw_upcalls.rds"))
hourly <- readRDS(here::here("hourly.rds"))
fit_gam <- readRDS(here::here("fit_gam.rds"))

# The fit and the counts must come from the same run: the counts the model
# was fitted to, in the same order. If this stops, re-run exercise 06 and save
# both files again.
stopifnot(
  "hourly.rds and fit_gam.rds are from different runs" =
    identical(as.numeric(hourly$n), as.numeric(fit_gam$y))
)

# If you dropped duplicates or `Possibly_Detected` calls before fitting in
# exercise 06, drop the same ones from `calls` here. Every check below should
# compare the fit with the calls it was fitted to.

# Part 1: the total, and why it proves nothing ------------------------------
#
# Adding up the fitted hourly counts gives the expected number of calls over
# the week (the fitted intensity, integrated). Compare it with the calls you
# counted.

nrow(hourly)  # a week is 168 hours; fewer means some hours are missing
c(fitted = sum(fitted(fit_gam)), observed = sum(hourly$n))

# They match exactly, and they always will: a Poisson model with an intercept
# and a log link is fitted so that they do. A check that can't fail tells you
# nothing. As you go through parts 2 and 3, ask which checks *could* fail.

# Part 2: where does it miss? -----------------------------------------------

check <- hourly |>
  mutate(fitted = fitted(fit_gam),
         local = with_tz(start, "Etc/GMT+5"),
         day = as_date(local),
         hour = hour(local))

# `miss` is (observed - fitted) / sqrt(fitted): how far off the fit is, in
# Poisson standard deviations. If the model were right, most bars would sit
# between the dashed lines at -2 and 2.

by_day <- check |>
  group_by(day) |>
  summarise(observed = sum(n), fitted = sum(fitted)) |>
  mutate(miss = (observed - fitted) / sqrt(fitted))

by_hour <- check |>
  group_by(hour) |>
  summarise(observed = sum(n), fitted = sum(fitted)) |>
  mutate(miss = (observed - fitted) / sqrt(fitted))

by_day
ggplot(by_day, aes(day, miss)) +
  geom_col() +
  geom_hline(yintercept = c(-2, 2), linetype = "dashed") +
  labs(x = NULL, y = "miss (Poisson SDs)")

by_hour
ggplot(by_hour, aes(hour, miss)) +
  geom_col() +
  geom_hline(yintercept = c(-2, 2), linetype = "dashed") +
  labs(x = "hour of day (UTC-5)", y = "miss (Poisson SDs)")

# Do the misses follow a pattern, or are they scattered? How many bars are
# outside the dashed lines? Keep that in mind for the dispersion in part 3.

# Part 3: is anything left over? --------------------------------------------
#
# Dispersion. About 1 if the hourly counts vary as much as a Poisson model
# expects. Much more than 1 means the model is too confident.

sum(residuals(fit_gam, "pearson")^2) / df.residual(fit_gam)

# Residual autocorrelation. Does a busy hour predict a busy next hour, beyond
# what the model explains?

acf(residuals(fit_gam, "pearson"))

# Rescaled gaps. Stretch time so the fitted rate is constant, then measure the
# gaps between calls. If the model is right, the gaps follow an exponential
# distribution with mean 1, and the points sit on the line. Duplicate start
# times give gaps of exactly 0.

edges <- as.numeric(c(hourly$start, max(hourly$start) + 3600))
Lambda <- approxfun(edges, c(0, cumsum(fitted(fit_gam))))
gaps <- diff(Lambda(sort(as.numeric(calls$time))))
qqplot(qexp(ppoints(length(gaps))), gaps,
       xlab = "expected if the model is right", ylab = "rescaled gaps")
abline(0, 1)

# Points above the line on the right: silences longer than the model expects.
# Too many near zero on the left: calls arriving in bursts.
#
# Which of these checks could have failed? Which did? In one sentence, what
# would you tell a reviewer about this fit?

# Extra, only if you did the optional step 3 in exercise 06 -----------------
#
#   selfexcite <- readRDS(here::here("fit_selfexcite.rds"))
#   selfexcite[c("decay_min", "bin_width_min")]
#
# Two numbers from different parts of the code that have to agree, and R
# won't complain if they don't. The decay time is how long one call keeps
# raising the rate. The self-exciting term is measured once per bin, from the
# calls before it. If the decay time is much shorter than the bin width, the
# term only sees the last few minutes of the previous bin, and can't see one
# call triggering another.
#
# Is your decay time longer than your bin width? If not, what was the term
# actually measuring? Was the decay time estimated, or chosen by you or the
# assistant?

# =============================================================================
#   Part 4: TURN THE ASSISTANT BACK ON.
# =============================================================================
#
# Ask: "Critique `fit_gam`. What would a reviewer object to?"
#
# Name the object. The assistant sees everything in your R session, including
# `selfexcite` if you loaded it, so "this fit" could mean either.
#
# Did it find what you found? Did it find anything you missed? Did it invent a
# problem that isn't there?
#
# Write down the answer to that last question. It is the honest summary of what
# these tools are for.
