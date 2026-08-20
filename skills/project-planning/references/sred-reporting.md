# SR&ED Work Summary & Project Organizer

Canadian Scientific Research and Experimental Development (SR&ED) tax-credit preparation: group a year of work into projects and write SR&ED-formatted project descriptions. Merged from: `sred-work-summary`, `sred-project-organizer`.

> NOTE: Eligibility is decided by the CRA. This workflow prepares documentation only. Requires GitHub, Notion, and Linear access (Notion/Linear via MCP; GitHub via MCP or `gh` CLI). If a source is inaccessible, prompt the user to grant access before proceeding.

## 1. Work Summary (upstream)

Collect all PRs, Notion docs, and Linear tickets for a given year and group them into projects.

### Process
1. **Get the year:** `date +%Y`; the previous year is current minus one.
2. **Collect info from user:** GitHub username; GitHub repos (comma-separated list, or a directory — find repos with `find . -maxdepth 2 -name ".git" -type d | sed 's/\/.git$//' | sort`); whether to include incident documents; other users who might have created Notion docs.
3. **Create a private Notion document** "SRED Work Summary [current year]". If one already exists with that name, tell the user to rename it and **stop**.
4. **Time window:** Feb 1 of the previous year → Jan 31 of the current year. Find all PRs created by the user in that window for the repos; all Notion docs the user created in the window; all Linear tickets the user was assigned in the window. Exclude incidents (`INC-X`, `INC-XXXX`) if the user declined them.
5. **Add every link** to the Work Summary document. Do NOT truncate lists or use shorteners like "...and 75 more".
6. **Group links into projects** using PR titles/descriptions, full Notion docs, and Linear ticket titles/descriptions. Every link assigned to a project.
7. **Merge relevant docs** created by the other users into the appropriate projects.
8. **Return the Notion link.**

### Work Summary format
```markdown
# Projects

## [Project Name]
*Summary*: [X] PRs, [X] Notion docs, [X] Linear tickets

### Pull Requests [X]
*[repository name]*
- [link] - [Merge date]

### Notion Docs [X]
- [link] - [Creation date]

### Linear Tickets [X]
- [link] - [Creation date]
```

## 2. Project Organizer (downstream)

Turn the Work Summary into SR&ED-formatted project documents in Notion.

### Process
1. **Get the Work Summary** Notion link (produced above). Validate its format.
2. **Classify projects** as SREDable or not. Be prescriptive — the more projects classified as SREDable the better. Review each project's docs/PRs against the SR&ED definition of a project. Output both lists.
3. **Confirm with the user** — let them manually reclassify any project.
4. **Create a private Notion document** "SRED Project Descriptions".
5. **For each SREDable project:**
   - Create a child doc "SRED Project Summary - <year> <project name>" following the project template.
   - Fill **Project Description** (≤100 words) and **Project Goals** (≤100 words).
   - Have the user review the summary before continuing.
   - Determine **Technical Uncertainties** per project. An Uncertainty answers: What was a challenge we didn't have an answer to? Is there prior art? If not, why? Confirm with the user; add each as a few sentences.
   - For each Uncertainty, list **Experiments** and **Results/Learnings/Success** (one bullet each), plus links to the relevant Notion docs/PRs/Linear tickets.
   - Put any remaining project links in **Project Documentation & Links** (all specific links, directly related).
   - Ask the user to review; remind them to fill the **Participants** section.
6. **Return the link** to the "SRED Project Descriptions" document.

## Do & Don't

| Do | Don't |
|---|---|
| Classify every project as SREDable or not | Leave projects unclassified |
| Include the full set of links (no "...and 75 more") | Truncate link lists |
| Keep descriptions/goals ≤100 words each | Write long-winded project descriptions |
| Confirm classifications & uncertainties with the user | Publish without user review |
| Link specific, project-related docs/PRs/tickets | Use general/notification links |
