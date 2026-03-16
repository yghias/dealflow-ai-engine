# Strategy Prompt Template Notes

The production prompt should:
- Ground on explicit evidence.
- Separate reasoning from output contract.
- Capture uncertainty and missing inputs.
- Emit stable JSON for automation and validation.
- Reference ranked queue fields, CRM context, and source evidence ids rather than free-form summaries.
- Keep approval-sensitive actions clearly separated from informational recommendations.
