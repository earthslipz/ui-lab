# UI Lab Results

**Course:** ITCS386 — Week 12 UI Testing Lab  
**Repository:** `earthslipz/ui-lab`  
**Selected parts:** Part 3 — Robot Framework and Part 4 — Cypress  
**Automated test date:** 23 November 2026  
**Practice sites:** [QuickPizza](https://quickpizza.grafana.com) and [Selenium web form](https://www.selenium.dev/selenium/web/web-form.html)

## Part 0: Chrome, locators, and manual QP-01

- **Step 0.1 — Chrome:** `158.0.8127.37` (64-bit), Windows 11.
- **Step 0.3 — ChromeDriver:** `158.0.8127.36` (verified with `chromedriver --version`).
- **Step 0.4 — Pizza, Please! button:** `name=pizza-please`.
- **Step 0.4 — Excluded tools:** `css=select`.
- **Step 0.4 — Must be vegetarian:** `id=default-checkbox`.
- **Step 0.4 — Custom Pizza Name:** `css=input#pizza-name`.

The locators above are recorded from the test setup. Their separate confirmation in Chrome DevTools has not been documented.

### Step 0.5 — Manual test case QP-01

The seven steps below were marked **Pass** in my notes. The exact manual pizza name, chosen tool, and calories were not included in those notes, so I have not substituted values from the automated tests.

**Manual pizza name:** Not recorded  
**Manual recommendation tool:** Not recorded  
**Manual calories per slice:** Not recorded

| Step | Expected result | Actual observation recorded | Result |
|---|---|---|---|
| 1. Open QuickPizza | Heading reads `Looking to break out of your pizza routine?` | Exact observation not written down | Pass (reported) |
| 2. Turn on Advanced | Max Calories per Slice, Excluded tools, Must be vegetarian and Custom Pizza Name appear | Field-by-field observation not written down | Pass (reported) |
| 3. Enter request | Maximum 600 calories; exclude Knife; vegetarian checked; unique name | Exact entered pizza name not written down | Pass (reported) |
| 4. Click Pizza, Please! | Same pizza name, tool other than Knife, at most 600 calories per slice | Exact name/tool/calories not written down | Pass (reported) |
| 5. Click Love it! while signed out | `Please log in first.` | Exact displayed message not separately recorded | Pass (reported) |
| 6. Open `/admin` and sign in | `Latest pizza recommendations` | Exact heading not separately recorded | Pass (reported) |
| 7. Find pizza in admin list | Matching pizza name and same tool as step 4 | Exact list entry not written down | Pass (reported) |

**Reporting note:** The manual Pass marks are based on the statuses entered in my notes. I still need to fill the actual manual observations above if the instructor requires a complete step-by-step execution record.

## Part 3: Robot Framework

- **Version:** Robot Framework `7.5.1`; SeleniumLibrary `6.9.0`.
- **First test (correct title):** PASS — 1 test, 0 failed.
- **Web form:** PASS — 1 test, 0 failed.
- **Step 3.2 — intentional wrong title:** FAIL as expected. With the assertion changed to `Title Should Be    Web Form`, Robot reported: `Title should have been 'Web Form' but was 'Web form'.` The assertion was restored to `Web form`, and `first.robot` passed again (1 test, 0 failed).

### Step 3.8 — QP-01, two complete runs

| Measurement | Run 1 | Run 2 |
|---|---|---|
| Result | **PASS** (1/1) | **PASS** (1/1) |
| Elapsed time | 10.089949 s | 9.995420 s |
| Pizza name | `Lab Pizza 20261123-201147` | `Lab Pizza 20261123-201158` |
| Recommended tool | Scissors | Scissors |
| Calories per slice | 500 | 325 |
| Excluded tool | Knife | Knife |
| Maximum calories | 600 | 600 |
| Evidence folder | `robot/results/run1/` | `robot/results/run2/` |

The tool was not Knife, and calories were below 600 in both runs. Each run produced `output.xml`, `log.html`, `report.html`, and four screenshots. Both test runs finished with 1 passed and 0 failed.

## Part 4: Cypress

- **Node.js:** `v24.14.0`.
- **npm:** Version not included in the supplied console log; use `npm.cmd --version` to record it.
- **Cypress:** `16.3.0`, Chrome `158` (headless).
- **Step 4.3 — intentional wrong title:** FAIL as expected. With `cy.title().should('eq', 'Web Form')`, Cypress reported `Timed out retrying after 10000ms`, showing the actual title `Web form` and expected title `Web Form`. The intentional failure produced 0 passing and 1 failing test, with one failure screenshot. Restore the assertion to `Web form` and confirm the single spec passes again before submission.
- **Step 4.6 — POST `/api/pizza` response:** The QP-01 spec passed its tool and calorie assertions. The exact response tool and calorie value from the Cypress run were not printed in the console log; consult the step-4 screenshot or Cypress command log to enter them.
- **Step 4.7 — admin list:** The QP-01 spec passed the check that the admin entry included the same tool. The exact list entry was not printed in the console log; inspect `cypress/cypress/screenshots/pizza-scenario.cy.js/qp01-step7-admin-list.png` for the pizza name and line.

### Step 4.8 — Two complete runs

| Measurement | Run 1 | Run 2 |
|---|---|---|
| Overall result | **PASS** | **PASS** |
| Tests | 2 passed, 0 failed | 2 passed, 0 failed |
| Full-run duration | 23 s | 23 s |
| Pizza spec duration (summary) | 19 s | 20 s |
| Web-form spec duration | 3 s | 2 s |
| QP-01 test duration (test line) | 17.318 s | 18.051 s |
| QP-01 pizza name | Not included in console log | Not included in console log |

The latest complete run generated three QP-01 screenshots (recommendation, login-required message, and admin list) and two videos (one per spec). These are located in `cypress/cypress/screenshots/` and `cypress/cypress/videos/`. Cypress may replace media from the preceding run.

- **Step 4.9 — second browser (optional):** Not attempted.
- **Compatibility note:** Cypress `16.2.1` previously raised `* is not a valid URL` when starting the second spec on Chrome 158. After upgrading to `16.3.0`, both specs passed in two full runs.

## Part B: Reflection

**1. Why use the label instead of the calories input's ID?**  
QuickPizza gives the ID `floating_filled` to three number inputs, so the ID does not uniquely identify Max Calories per Slice. Using it directly could select the wrong field. I would give each input its own unique ID, such as `max-calories`, and connect the correct label to that ID. This would make the locator more stable even if the layout changed.

**2. What type of oracle is the admin-list comparison?**  
Step 7 uses a **consistency oracle**: it checks whether the tool saved in the admin list matches the recommendation, rather than comparing only a fixed text string. It could catch a defect where the page recommends Scissors but the saved record says Knife. The test looks for its unique pizza name instead of assuming the newest row is always its own, because other students use the same site.

**3. How could QP-01 verify that the pizza is vegetarian?**  
Checking the checkbox only confirms the request, not the actual ingredients. I would inspect the returned ingredient list and verify that every ingredient is vegetarian using reliable classification data. If the page does not show these details, the test would need the API response or another trusted source. Cypress could use `cy.intercept()` to inspect `POST /api/pizza` and verify the response.

**4. Compare Robot Framework and Cypress.**  
Robot Framework uses explicit wait keywords, such as `Wait Until Page Contains`, while Cypress retries queries and assertions such as `cy.get(...).should(...)` automatically. Robot completed QP-01 in 10.09 and 10.00 seconds, whereas Cypress's QP-01 spec took 19 and 20 seconds in the two completed runs. Robot's keywords and HTML log made the test sequence clear; Cypress's JavaScript flow, command history, screenshots, and videos were convenient for reviewing browser actions. For a JavaScript-based project, I found Cypress more straightforward to work with, even though Robot ran faster in this experiment.

**5. Which tool would I choose for Project 2?**  
I would choose **Cypress** for a JavaScript-based project. First, its automatic retries help handle pages that update after clicks without adding many explicit waits. Second, `cy.intercept()` lets a test verify API responses alongside the UI. Both final Cypress runs passed 2/2 tests and produced screenshots and videos automatically. Robot Framework is a good alternative for teams that prefer readable, reusable keyword steps.

**6. Part 3 — Where would I repair a changed calories locator?**  
I would update `${MAX CALORIES}` in `robot/resources/quickpizza.resource`. The main `pizza_scenario.robot` uses reusable keywords such as `Fill In The Pizza Request` instead of repeating the XPath directly. This keeps the locator change in one place and makes the test easier to maintain.

**7. Part 4 — Why keep all of QP-01 in one Cypress test?**  
Cypress isolates tests and clears browser state such as cookies between tests. QuickPizza uses a browser cookie to help keep customer and admin requests on the same backend server. Splitting the flow across two `it(...)` blocks could lose that context and stop the admin page from finding the pizza from the first test. Keeping all seven steps together allows the same pizza and tool to be compared.

## Final checks before submission

The Robot and Cypress full-run results above are supported by the supplied console logs. Before submission, confirm the Cypress title assertion was restored and passed, record the missing npm version and actual manual observations, and copy the exact Cypress pizza name, API values, and admin-list entry from the saved evidence where available. The intentional-failure screenshot is diagnostic evidence; the primary QP-01 screenshots and videos should come from a passing run. Verify `README.md`, `.gitignore`, the source files, and both frameworks' evidence are included in the public GitHub repository.
