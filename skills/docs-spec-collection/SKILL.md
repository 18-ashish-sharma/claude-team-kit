---
name: docs-spec-collection
description: Use when an API endpoint is added, changed or removed - path, payload, response, headers, error codes or auth. An endpoint change is not done until the docs, the generated API spec and the API collection (Bruno, Postman or similar) are all updated, in that order.
---

# Docs, then spec, then collection

Any endpoint change is finished only when all three are updated, **in this order**:

1. **Document it.** Update the endpoint reference **and** the flow description that tells a client developer which calls to make in what order. Service-level notes (config, jobs, limits) go in the service's own page.
2. **Regenerate the API spec from code.** Never hand-edit a spec file.
   - Code-first tools (tsoa, NestJS Swagger, springdoc and the like): run the generator and commit the output.
   - Runtime-generated specs (FastAPI and the like): start the service, confirm the served spec shows the change, and confirm the client still generates from it.
   - A generator can exit successfully while silently dropping a broken controller. Check that the changed endpoint is actually in the output.
3. **Update the API collection.** Add, change or remove the matching request. Keep the sequence numbering in step with the flow, keep the response-shape assertions, and confirm every file parses.

## Why this order

The doc is the intent. The spec is the contract generated from code. The collection is the runnable proof. Writing the collection first means asserting against a contract nobody agreed to.

## Checks

- The doc, the spec and the collection name the same path, the same fields and the same error codes.
- Examples in the doc are real responses from a local run, not typed from memory.
- Removed endpoints are removed from all three.
- The collection runs green against the **local** server and database only. Never against a shared environment. See the `safe-db-targets` skill.
- Docs claims are checked against the running API, not against the code.
