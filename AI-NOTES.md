# 🤖 AI-NOTES.md — How AI Was Used in This Project

This file documents where and how AI tooling assisted in building `chalk-it-up`. See [AI-WORKFLOW.md](https://github.com/melscodingcave/the-playbook/blob/main/AI-WORKFLOW.md) in `the-playbook` for the full philosophy.

---

## Log

### Scope Decision — 9-Ball Only
**What happened:** AI initially suggested supporting both 8-ball and 9-ball.

**What I decided:** 9-ball only. A focused tool does one thing well. Adding game type selection adds UI complexity with no portfolio value.

**Why it matters:** Scope decisions are engineering decisions. Knowing what to leave out is as important as knowing what to build.

---

### Race Length — Number Input Over Dropdown
**What happened:** AI suggested a dropdown with preset race lengths (5, 7, 9).

**What I decided:** Number input with validation (1-20). More flexible, reflects real league play where handicapped races vary.

**Why it matters:** A dropdown assumes you know every valid value upfront. A validated number input respects that race lengths vary by format, venue, and handicap.

---

### Widget Test Ambiguity — Finder Specificity
**What happened:** `find.text('Allen')` matched both the player panel name and the break button label causing ambiguity errors identical to Playwright's strict mode violations.

**What I changed:** Used `.first` to target the player panel specifically.

**Why it matters:** Same lesson across three testing frameworks (SpecFlow, Playwright, Flutter) — always use the most specific finder available when text appears in multiple contexts. The pattern is universal even when the syntax differs.

---

### AI Trash Talk — API Key Security
**What happened:** API key is hardcoded in match_screen.dart for portfolio purposes.

**What I documented:** In production this would be proxied through a backend service. The league-api would be a natural proxy candidate — the Flutter app calls the API, the API calls Anthropic with a server-side key.

**Why it matters:** Demonstrating awareness of the security concern is more valuable than pretending the concern doesn't exist. Honest documentation of known limitations is professional engineering practice.

---

### Test Coverage — Developer-Driven Scenarios
**What happened:** AI generated tests after the app was built.

**What I defined:** Full test scenario list before tests were written — happy path, validation, and locked state categories. Tests were written to match the scenarios, not the other way around.

**Why it matters:** Test scenarios should be driven by requirements, not by what's easy to test. Defining scenarios first ensures coverage is intentional.

---

### API Key Security — .env Implementation
**What happened:** API key was initially hardcoded in match_screen.dart.

**What I changed:** Moved to .env file loaded via flutter_dotenv package. 
Key is excluded from version control via .gitignore.

**Why it matters:** Hardcoded keys in source code are a security risk even 
in portfolio projects — anyone cloning the repo would have access to the key. 
.env files are a standard mitigation. The production solution remains a 
backend proxy, but .env is the correct portfolio-level approach.