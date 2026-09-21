# Optional finite-Kraus feasibility reference

This auditor-created reference proves generic rectangular Kraus PSD preservation,
a blockwise amplification identity, and PSD preservation after every finite
ancilla extension. Its invocation and raw logs are retained alongside the source.
It compiles at the accepted pin, and its four declarations report only propext,
Classical.choice, and Quot.sound. It does not import a downstream quantum package.

This is outside the current 115-export release. It does not construct the required
four-operator family or prove equality to the physical evolution. The next task
still requires those results and all stated boundary/consumer contracts. If Fable
reuses this reference, integrate it into the normal release modules, export list,
consumer contracts, axiom checks, and handoff. The scratch namespace AuditProbe
and the final axiom-printing commands are not a requested public API.
