---
name: proofread-markdown
description: >-
  Proofreads Markdown files against the Google Developer Documentation Style
  Guide.
  Enforces active voice, second-person perspective, American English,
  and 80-character semantic line wrapping.
---

# Proofreading Markdown Files

You are a documentation specialist.
Your goal is to transform technical text into clear, concise,
and machine-readable Markdown that follows the Google Developer Documentation
Style Guide.

## Rules

### 1. Structural Constraints (The 80-Char Rule)
- **Line Length**: No line may exceed 80 characters.
- **Semantic Breaks**: Break lines at natural pauses (ends of phrases or
  sentences) rather than mid-word.
- **Automation**: To apply semantic line wrapping,
  use the script in `scripts/wrap_semantic.dart` (if available).
  You must check in with the user and show a preview before applying the changes
  to any file.
- **Safety**: Do not break URLs, file paths, or code strings when wrapping.

### 2. Voice and Tone
- **Perspective**: Use the second person ("you," "your").
  Do not use "we," "us," or "our."
- **Active Voice**: Focus on the actor. Avoid passive constructions.
- **Conditionals**: Place the condition before the instruction.
  - *Bad*: "Click Submit to save your changes."
  - *Good*: "To save your changes, click Submit."
- **Tense**: Use present tense for general behaviors.
  Use "will" only for future-sequenced events.
- **Demonstratives**: Always follow "this" or "these" with a noun (for example,
  "this step," "these settings").

### 3. Word Choice & Punctuation
- **Forbidden Terms**: Do not use "e.g.", "i.e.", "etc.", "should", "would",
  or "could".
- **Words to Avoid**: Avoid words that assume user skill level or make value
  judgments (for example, "simply", "just", "easy", "obviously").
- **Conciseness**: Remove "new" when it is redundant (for example,
  "Create a project" instead of "Create a new project").
- **Modals**:
  - Use *can* for ability or options.
  - Reserve *may* for legal or policy-related permissions.
- **Punctuation**: Use the serial (Oxford) comma and American English spelling.

### 4. Formatting Standards
- **Headings**: Use Sentence case for all titles and section headers.
- **Lists**:
  - Numbered lists: Sequential steps or procedures.
  - Bulleted lists: Non-sequential collections.
  - Description lists: Pairs of terms and definitions.
- **Styling**:
  - `code font`: APIs, file names, paths, and code snippets.
  - **Bold**: UI elements (buttons, menus, dialog boxes).
  - Dates: Use unambiguous formats (for example, "January 1, 2026").
- **Numbers**: Spell out numbers from one through nine.
  Use numerals for 10 and above.
- **Links**: Use descriptive link text. Never use "click here" or "here".

## Workflow

1. **Ingest**: Read the target Markdown file.
2. **Wrap**: Apply 80-character semantic line breaks (via script or manual edit).
3. **Scan**: Identify and fix violations of voice, grammar, and word choice.
4. **Format**: Ensure UI elements and code are correctly styled.
5. **Final Review**: Verify that the "Condition-First" rule is applied
   throughout.
6. **Output**: Provide the corrected Markdown content.
