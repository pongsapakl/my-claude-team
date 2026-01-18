# Git Commit Workflow

## Auto-Trigger on Keywords

When user says: "commit", "add and commit", "git commit", "create commit", or similar phrases:

1. **Always check actual git state first** - don't assume what changed based on session work
2. Analyze changes to determine commit strategy
3. Create commit(s) automatically

---

## Pre-Commit Analysis (Quick, Not Extensive)

Before committing, run these commands in parallel:

```bash
git status                    # See what files changed
git diff --stat              # Quick overview of changes
git diff                     # Full diff for understanding
```

**Goal**: Understand what actually changed in working directory, not just what happened in current session.

**Keep it fast**: Don't do extensive research or file reading beyond the git diff. Just understand the changes shown in the diff.

---

## Commit Splitting Strategy

### Create Multiple Commits When:
- Changes span **unrelated concerns** (e.g., feature + docs + config)
- Changes affect **different subsystems** (e.g., frontend + backend)
- Changes have **different purposes** (e.g., bugfix + refactor)

**Example - Split into 3 commits:**
```
Commit 1: Add ONNX Runtime integration to CMake and plugin
Commit 2: Update documentation (README, SETUP.md)
Commit 3: Clean up .gitignore and repository structure
```

### Create Single Commit When:
- Changes are **part of same feature** (even if large)
- Changes are **tightly coupled** (changing one requires the other)
- Changes affect **same subsystem/component**

**Example - Single commit OK:**
```
Commit 1: Add chorus effect with UI controls and audio processing
  (even if this touches PluginProcessor.h, .cpp, and PluginEditor.cpp)
```

### Decision Process:
1. Look at files changed
2. Group by logical concern/purpose
3. If 2+ clear groups → split commits
4. If all related → single commit

---

## Commit Message Style

### Current Problem:
- Messages too granular (listing every tiny detail)
- Too many bullet points for small related changes
- Hard to scan quickly

### New Style - Consolidate Bullets to Main Ideas:

**Before (too granular):**
```
Add ONNX Runtime integration

- Download ONNX Runtime v1.19.2 for macOS ARM64
- Create EmbeddingEngine.h with class interface
- Create EmbeddingEngine.cpp with constructor implementation
- Add embed() method to EmbeddingEngine
- Add tokenize() helper method
- Add runInference() method with tensor creation
- Add meanPooling() method
- Add normalize() method
- Add ONNX Runtime to CMakeLists.txt
- Configure dynamic library linking
- Set rpath for runtime loading
- Add include directories for ONNX headers
- Verify library exists at build time
- Update .gitignore to ignore third_party/onnxruntime/
- Test ONNX model loading in plugin constructor
- Add debug logging for success/failure
```

**After (consolidated main ideas, still using bullets):**
```
Add ONNX Runtime integration for NLP embeddings

- Integrate ONNX Runtime C++ API (v1.19.2) with EmbeddingEngine wrapper class
- Implement tokenization, inference, mean pooling, and L2 normalization pipeline
- Configure CMake with dynamic linking and rpath for macOS
- Plugin successfully loads Sentence-BERT model and generates 384-dim embeddings

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Guidelines:
- **First line**: Concise summary (50-72 chars if possible)
- **Bullets**: 2-5 consolidated ideas, not exhaustive implementation details
- **Group related changes** ("Configure CMake build system" not separate bullets for each CMake line)
- **Focus on WHAT and WHY**, not every file/function
- **Keep technical specifics** that matter (version numbers, key algorithms, architectural choices)
- **Always include** Claude attribution footer

---

## Commit Message Template

```
{Verb} {Component/Feature} {brief what}

- {Main idea 1 - can combine multiple related changes}
- {Main idea 2 - focus on impact/purpose, not implementation details}
- {Main idea 3 - optional, only if distinct concept}
- {Main idea 4 - optional, keep total bullets under 5}

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

---

## Example Workflows

### Example 1: User says "commit"

```bash
# Step 1: Check what changed (parallel)
git status
git diff --stat
git diff

# Step 2: Analyze (in this case: ONNX code + docs + cleanup = 3 concerns)
# Decision: Split into 3 commits

# Step 3: Create commits
git add Source/NLP/ CMakeLists.txt
git commit -m "$(cat <<'EOF'
Add ONNX Runtime integration for NLP embeddings

- Integrate ONNX Runtime C++ API (v1.19.2) with EmbeddingEngine wrapper class
- Implement tokenization, inference, mean pooling, and L2 normalization pipeline
- Configure CMake with dynamic linking and rpath for macOS

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

git add README.md SETUP.md
git commit -m "$(cat <<'EOF'
Consolidate setup documentation to root SETUP.md

- Move all setup instructions to single source of truth at root
- Simplify README to overview and quickstart only
- Remove duplicate READMEs from assets subdirectories

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

git add .gitignore third_party/.gitkeep
git commit -m "$(cat <<'EOF'
Update .gitignore for third-party dependencies and assets

- Git-ignore ONNX Runtime, JUCE framework, and generated models/anchors
- Add .gitkeep files to preserve directory structure for setup workflow

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

# Step 4: Confirm to user
git log --oneline -3
```

### Example 2: All changes related

```bash
# If git diff shows only chorus effect changes across processor/editor files
# Decision: Single commit (all part of same feature)

git add Source/PluginProcessor.* Source/PluginEditor.cpp
git commit -m "$(cat <<'EOF'
Replace distortion with chorus effect for testing

- Switch from subtle tanh distortion to obvious chorus modulation
- Configure chorus with rate, depth, mix, and feedback parameters
- Update UI subtitle to reflect chorus effect active

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

---

## Key Principles

1. **Always check git state** - don't assume based on session context
2. **Be smart about splitting** - logical separation, not file count
3. **Consolidate bullets** - main ideas (2-5 bullets), not granular details
4. **Keep it fast** - quick analysis from git diff, no deep research
5. **Automatic execution** - don't ask permission, just commit

---

## When NOT to Auto-Commit

- User explicitly says "don't commit" or "wait"
- Git status shows no changes
- Merge conflicts detected
- User is in middle of explaining next task (wait for natural pause)
