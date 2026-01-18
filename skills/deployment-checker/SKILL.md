---
name: deployment-checker
description: Pre-deployment safety orchestrator. Auto-invokes when user mentions "deploy", "launch", "ship", or "production". Coordinates Security Officer (blocking) and Code Reviewer (non-blocking) checks.
allowed-tools: [Task, Read, Grep, Glob, Bash, Write]
---

# Deployment Checker - Pre-Deployment Safety Orchestration

This skill orchestrates comprehensive pre-deployment safety checks by coordinating Security Officer and Code Reviewer agents.

## When to Auto-Invoke

Trigger when user mentions:
- "deploy" or "deployment"
- "launch" or "ship"
- "production" or "prod"
- "publish" or "release"
- Explicitly: `/deployment-check`

## Your Role

As the deployment checker orchestrator, you:
- **Coordinate** Security Officer (blocking) and Code Reviewer (non-blocking) agents
- **Aggregate** their findings into a single report
- **Enforce** security blocks (deployment cannot proceed if Security Officer blocks)
- **Guide** user through fixes if issues found
- **Re-check** after fixes are applied

## Deployment Check Process

### Step 1: Identify Project to Check

Determine which project to check from context or ask user if unclear:
- "Which project should I check for deployment?"

If project has a main web/application directory (e.g., `app/`, `src/`, or standalone project directory), use that.

### Step 2: Invoke Security Officer (BLOCKING)

Use Task tool to spawn security-officer agent:

```
Prompt template:
"Perform comprehensive security review for deployment of: {project_path}

Run all security checks from your checklist:
1. Scan for hardcoded secrets (API keys, passwords, tokens)
2. Verify .env is in .gitignore and not committed
3. Check HTTPS configuration
4. Run npm audit for critical vulnerabilities
5. Review environment variable setup

Provide detailed report with:
🔴 BLOCKING ISSUES (must fix before deploy)
⚠️ WARNINGS (should address but non-blocking for MVP)
✅ PASSED CHECKS

Include specific file:line locations and exact fixes for all issues.

DEPLOYMENT STATUS: [BLOCKED / APPROVED WITH WARNINGS / APPROVED]"
```

Wait for Security Officer's response.

### Step 3: Invoke Code Reviewer (NON-BLOCKING)

Use Task tool to spawn code-reviewer agent:

```
Prompt template:
"Perform code review for deployment of: {project_path}

Check best practices:
1. TypeScript configuration and type safety
2. SEO meta tags (title, description, OG tags)
3. Accessibility basics (alt text, semantic HTML, ARIA)
4. Performance (bundle size, image optimization, lazy loading)
5. Code quality (ESLint, unused code, console.logs)

Provide report with:
⚠️ SUGGESTIONS (non-blocking improvements)
✅ GOOD PRACTICES (what's done well)

Include specific recommendations with file locations."
```

Wait for Code Reviewer's response.

### Step 4: Aggregate Results

Combine both reports into unified deployment report:

```markdown
# 🚀 DEPLOYMENT REVIEW - {project_name}

## 🔴 BLOCKING ISSUES
{Security Officer's blocking issues, or "None found ✅"}

## ⚠️ WARNINGS & SUGGESTIONS
{Combined warnings from Security Officer + suggestions from Code Reviewer}

## ✅ PASSED CHECKS
{What's working well from both agents}

---

**DEPLOYMENT STATUS**: {BLOCKED / APPROVED WITH WARNINGS / APPROVED}

{If BLOCKED}
**Action Required**: Fix all blocking issues above, then run `/deployment-check` again.

{If APPROVED WITH WARNINGS}
**Recommendation**: Address warnings before launch, but you can deploy for MVP testing.

{If APPROVED}
**Ready to deploy!** All critical checks passed.
```

### Step 5: Handle Blocked Deployments

If Security Officer blocks:

1. **Clearly explain** each blocking issue
2. **Provide specific fixes** (file locations, code changes)
3. **Offer to help** implement fixes
4. **Verify fixes** by re-running checks after user fixes issues

Example interaction:
```
Assistant: 🔴 DEPLOYMENT BLOCKED

Security Officer found critical issues:

1. Hardcoded API key in [project-name]/src/app/api/checkout/route.ts:5
   Fix: Move to environment variable

Would you like me to:
1. Help you move the secret to .env
2. Update the code to use process.env
3. Verify .gitignore is configured

Which would you prefer?
```

### Step 6: Re-check After Fixes

When user says they've fixed issues or you help fix them:

1. Re-run Security Officer check on the same project
2. Report new status
3. Repeat until approved or user stops

## Auto-Invocation Detection

Monitor user messages for deployment intent:

**Definite triggers**:
- "I want to deploy"
- "Ready to ship this"
- "Let's launch the landing page"
- "Going to production"
- `/deployment-check`

**Probable triggers** (confirm first):
- "Think this is ready?"
- "What do we need before launch?"
- "Is this safe to publish?"

**False positives to ignore**:
- "When we eventually deploy..." (future tense)
- "After deployment, we should..." (post-deployment planning)
- "How do deployments work?" (informational)

## Communication Style

- **Safety-first**: Never minimize security issues
- **Clear severity**: Distinguish blocking vs non-blocking
- **Actionable**: Provide fixes, not just problems
- **Efficient**: Run both checks in parallel when possible
- **Helpful**: Offer to implement fixes

## Example Full Flow

### Scenario: User says "Ready to deploy [project-name]"

**Step 1: Acknowledge**
```
I'll run comprehensive pre-deployment checks on [project-name]/.

Running security review (blocking) and code review (non-blocking) in parallel...
```

**Step 2: Spawn Agents**
- Task tool → security-officer agent
- Task tool → code-reviewer agent

**Step 3: Wait for Results**
{Both agents complete their checks}

**Step 4: Present Unified Report**
```markdown
# 🚀 DEPLOYMENT REVIEW - [project-name]

## 🔴 BLOCKING ISSUES
None found ✅

## ⚠️ WARNINGS & SUGGESTIONS

**Security (Non-blocking for MVP)**:
1. Security headers not configured (next.config.js)
   - Add Content-Security-Policy, X-Frame-Options
   - Recommended: Add post-launch

2. npm audit shows 2 moderate vulnerabilities
   - Dev dependencies only
   - Plan to update in next sprint

**Code Quality**:
1. Missing SEO meta tags in app/layout.tsx:15
   - Add description and OG tags
   - Impacts discoverability

2. Images not optimized (public/hero.png is 2.3MB)
   - Use Next.js Image component with optimization
   - Consider WebP format

## ✅ PASSED CHECKS
- No hardcoded secrets
- HTTPS configured (Vercel automatic)
- .env properly excluded from git
- No critical vulnerabilities
- TypeScript strict mode enabled
- Accessibility: semantic HTML present

---

**DEPLOYMENT STATUS**: APPROVED WITH WARNINGS ✅

**Recommendation**: Project is safe to deploy for MVP testing. Address SEO and image optimization for better user experience, but not blocking.

Ready to proceed with deployment?
```

**Step 5: User Decides**
- If user approves → Deployment proceeds
- If user wants to fix warnings → Help implement fixes
- If user wants details → Provide more context

## Integration with Commands

The `/deployment-check` command should invoke this skill:

```markdown
Run comprehensive pre-deployment safety checks for: {project name or path}
{rest of command prompt delegates to this skill}
```

## Edge Cases

### Multiple Projects
If user says "deploy everything":
- Ask which project to check first
- Run checks sequentially (don't mix contexts)

### Partial Fixes
If user fixes some but not all blocking issues:
- Re-run full check
- Report remaining issues clearly
- Track progress ("2 of 3 issues resolved")

### Emergency Deploys
If user insists on deploying despite blocks:
- Strongly warn about risks
- Document that you advised against it
- Do NOT assist with deployment if critical security issues present

### False Positives
If Security Officer flags false positives (e.g., .env.example):
- Verify the context
- Override if clearly safe
- Update Security Officer's scan patterns if needed

## Success Criteria

- **Security issues caught**: 100% of hardcoded secrets, missing HTTPS, critical vulns
- **Clear severity**: User understands what must fix vs should fix
- **Fast feedback**: Both checks complete in <2 minutes
- **Actionable**: User knows exactly what to fix and how
- **Re-check works**: Can verify fixes without starting over

## Relationship to Security Standards

This skill enforces `.claude/rules/security-standards.md`:

**BLOCKING (from security-standards.md)**:
- Secrets in code
- No HTTPS
- Critical vulnerabilities
- Public .env file

**NON-BLOCKING (from security-standards.md)**:
- Security headers
- Moderate vulnerabilities
- Input validation improvements
- Performance optimizations

## Tools Usage

- **Task**: Spawn security-officer and code-reviewer agents
- **Read**: Review specific files if needed for context
- **Grep**: Help find issues if agents need assistance
- **Bash**: Run npm audit, git checks if needed
- **Write**: Create fix scripts or updated config files if helping user

## Key Reminders

1. **Security Officer has veto power** - If they block, deployment stops
2. **Run checks in parallel** - Don't make user wait unnecessarily
3. **Be helpful with fixes** - Don't just report problems
4. **Re-check is easy** - Make it simple to verify fixes
5. **MVP pragmatism** - Warnings are acceptable for MVP, blocks are not

## Post-Check Actions

After deployment approved:
- No automatic deployment (user controls deployment)
- Optionally: Log check results to session logs
- Optionally: Suggest next steps (monitoring, analytics setup)

Remember: Your job is to prevent unsafe deployments while being pragmatic about MVP needs. Security blocks are non-negotiable, but minor improvements can wait until post-launch.
