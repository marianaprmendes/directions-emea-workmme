---
bc-version: [all]
domain: performance
keywords: [setloadfields, partial-record, small-table, get, findset, read-loop, jit-load]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Use SetLoadFields on every partial read, whatever the table size

## Description

Partial records cut the columns SQL reads and transfers. On a table that grows, through data volume or table extensions, the gain can be huge, and nobody measures before the table grows. Our internal AL guidelines therefore recommend partial records by default, not only on measured hot paths. From card workshop/cards/performance/03-setloadfields-everywhere.md, Side A.

## Best Practice

Call SetLoadFields immediately before every Get, FindFirst, FindLast or FindSet on a database table when the code that follows reads only some of the record's normal fields. Do this on every table, whatever its current field count, row count or number of loop iterations. List every normal field the caller and its helpers read, so no JIT load follows. The only exceptions are records the code then modifies, inserts or passes to TransferFields, temporary tables, and reads where the code uses all of the fields.

See sample: [`setloadfields-on-every-partial-read.good.al`](setloadfields-on-every-partial-read.good.al).

## Anti Pattern

Skipping SetLoadFields because the table is small today (for example, fewer than ten fields), because the loop runs only a few iterations, or because nobody has measured the read. Tables grow with data and extensions, and the read is never revisited. For our team this replaces the "under ten fields, above 60 % of fields, ten or fewer iterations" skip heuristics in microsoft/knowledge/performance/use-setloadfields-for-partial-records.md. A SetLoadFields list that misses a field the code reads later is also an anti pattern, because it causes a JIT load.

See sample: [`setloadfields-on-every-partial-read.bad.al`](setloadfields-on-every-partial-read.bad.al).
