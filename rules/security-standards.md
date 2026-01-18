# Security Standards for Deployment

## Non-Negotiable (BLOCKING)

These issues **MUST** be fixed before deployment:

### 1. No Secrets in Code
- ❌ Hardcoded API keys, passwords, tokens
- ❌ `.env` file committed to git
- ✅ All secrets in environment variables
- ✅ `.env` in `.gitignore`
- ✅ `.env.example` with placeholder values only

### 2. HTTPS Enforced
- ❌ HTTP in production
- ❌ Mixed content (HTTPS page loading HTTP resources)
- ✅ HTTPS redirect configured
- ✅ All resources loaded via HTTPS

### 3. No Critical Vulnerabilities
- ❌ npm audit shows CRITICAL severity issues
- ✅ Critical vulnerabilities patched or mitigated
- ⚠️ Moderate/Low issues acceptable for MVP (plan to fix)

### 4. Environment Variables Properly Configured
- ❌ Secrets exposed in client-side code
- ✅ Server-only secrets not prefixed with `NEXT_PUBLIC_`
- ✅ Client-safe variables properly prefixed

## Important (Should Fix for MVP)

These improve security significantly:

### Security Headers
- Content-Security-Policy
- X-Frame-Options (clickjacking protection)
- X-Content-Type-Options
- Strict-Transport-Security (HSTS)

### Input Validation
- Sanitize user input (if forms exist)
- Prevent XSS (Cross-Site Scripting)
- Prevent injection attacks

### Error Handling
- Don't leak sensitive info in error messages
- Generic errors to users, detailed logs server-side

## Nice to Have (Post-MVP)

Can wait until after initial launch:

- Rate limiting on APIs
- CORS fine-tuning
- Security audit by third party
- Penetration testing
- WAF (Web Application Firewall)

## Security Review Process

### Pre-Deployment Checklist

Security Officer MUST verify:

1. ✅ Scan for secrets (grep patterns)
2. ✅ Check `.gitignore` includes `.env`
3. ✅ Verify HTTPS configuration
4. ✅ Run `npm audit` and review results
5. ✅ Test deployment configuration (env vars set correctly)

### Post-Deployment Verification

After deployment, verify:

1. Site loads via HTTPS
2. No console errors revealing sensitive info
3. Security headers present (use curl or browser dev tools)
4. Environment variables properly loaded

## Common Security Mistakes to Avoid

1. **Committing .env to git**
   - Check: `git ls-files | grep ".env$"` should be empty

2. **Hardcoding secrets**
   - Bad: `const API_KEY = "sk_live_abc123"`
   - Good: `const API_KEY = process.env.STRIPE_SECRET_KEY`

3. **Client-side secrets**
   - Bad: `NEXT_PUBLIC_SECRET_KEY` (exposed to browser!)
   - Good: `SECRET_KEY` (server-only)

4. **Mixed content**
   - Bad: `<img src="http://example.com/image.jpg">` on HTTPS page
   - Good: `<img src="https://example.com/image.jpg">`

5. **Ignoring npm audit**
   - Always review critical/high vulnerabilities
   - Update or mitigate before deploying

## When in Doubt

If you're unsure whether something is a security issue:

1. Ask Security Officer agent for review
2. Default to caution (better safe than sorry)
3. Reference OWASP Top 10: https://owasp.org/www-project-top-ten/
4. Consult Next.js security best practices

## Emergency Response

If secret is accidentally committed:

1. **Immediately**: Rotate/revoke the exposed secret
2. Remove from git history (not just delete the file)
3. Force push cleaned history
4. Update environment with new secret
5. Audit for any unauthorized usage

Remember: Security is not optional. MVP can ship with missing features, but NOT with security vulnerabilities that expose user data or system access.
