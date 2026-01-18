Run comprehensive pre-deployment safety checks for: {project name, default: landing-page}

Use the deployment-checker skill to orchestrate security and code review:

1. **Security Officer Review** (BLOCKING):
   - Scan for hardcoded secrets
   - Verify HTTPS configuration
   - Check environment variables setup
   - Run npm audit for vulnerabilities
   - Review security headers

2. **Code Reviewer Analysis** (NON-BLOCKING):
   - Check TypeScript configuration
   - Verify SEO meta tags
   - Test accessibility basics
   - Review performance (bundle size, images)
   - Validate best practices

Present results as:

🔴 BLOCKING ISSUES (must fix):
[List with specific fixes]

⚠️ WARNINGS (should address):
[List with suggestions]

✅ PASSED CHECKS:
[List what's good]

**DEPLOYMENT STATUS**: [BLOCKED / APPROVED WITH WARNINGS / APPROVED]

If BLOCKED, guide me through fixes and offer to re-check.
