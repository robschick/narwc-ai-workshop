# Setup check 1 of 2: Posit Assistant

Use the workshop API key I emailed you.

1. Open the workshop project in Posit Cloud, or in **Positron** or **RStudio**
   on your own computer.
2. Open the assistant pane, choose **Anthropic** as the provider, and paste in
   your key. Paste it into the pane only, never into a file in the project.
   Then check the model menu shows the model named in the email.
3. In the R console, run:
   `calls <- readRDS(here::here("data/narw_upcalls.rds"))`
4. Ask the assistant: *"How many rows are in `calls`, and what are the column types?"*

You are set if the answer matches what `str(calls)` tells you.

If the assistant **guesses** instead of looking, it cannot see your session.
In Positron, check that the assistant has session access enabled. In RStudio,
the chat may not have live session context — that is expected, and everything in
the workshop still works; you will just paste more context by hand.

::: Falling back
If you already have your own Posit AI Pass, or your own OpenAI or Gemini
key, Posit Assistant takes those too. Any of them works for every exercise.
:::
