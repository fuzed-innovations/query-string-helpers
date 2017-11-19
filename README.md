# QueryStringHelpers

A set of extensions on String and [String: String] for:
- Encoding/decoding strings for use in query strings (with control over spaces encoding as + or %20)
- Converting between query strings and dictionaries (and vice versa)
- Adding query string dictionaries to exisiting query strings

Notes:
- Repeating query keys are handled as 'last set'
