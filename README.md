# ITCS386 Week 12 – UI Testing Lab

This is my individual Week 12 UI testing lab. I chose **Part 3 (Robot Framework)** and **Part 4 (Cypress)**. Both automate test case **QP-01**, which checks a custom pizza with restrictions, the login requirement for ratings, and the matching pizza in the admin list. I also tested Selenium's practice web form.

The automated tests were run on Windows 11 with Chrome 158. Their results and evidence are in `RESULTS.md`, `robot/results/`, and the Cypress screenshot/video folders. The manual QP-01 observations and intentional-failure exercises are documented separately where available.

## Project contents

- `robot/` — Robot Framework tests (`first.robot`, `web_form.robot`, `pizza_scenario.robot`), reusable locators/keywords in `resources/`, and two complete QP-01 runs in `results/run1/` and `results/run2/`.
- `cypress/` — JavaScript tests for the web form and QP-01, a custom admin login command, screenshots, and videos.
- `RESULTS.md` — environment versions, observed results, evidence, and Part B reflection.
