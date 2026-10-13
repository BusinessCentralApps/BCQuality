---
bc-version: [all]
domain: web-services
keywords: [textencoding, text-encoding, utf8, msdos, createoutstream, createinstream, blob, file-export, character-corruption]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Set an explicit text encoding on BLOB streams whose bytes leave or enter Business Central

## Description

`Blob.CreateInStream` and `Blob.CreateOutStream` take an optional `TextEncoding`; when it is omitted, the stream uses `MSDos` (OEM) encoding, whose code page depends on the server's system locale. Text written with `WriteText` and read back with `ReadText` through streams created with the same default round-trips correctly inside Business Central, so the problem stays hidden in tests. It appears when the bytes cross a system boundary: a downloaded CSV, a file sent to a bank, an HTTP body, or an imported file produced elsewhere. Accented and non-Latin characters (for example `à`, `ß`, `ø`, `ł`) are then corrupted or replaced. In Business Central online the server locale cannot be controlled, so Microsoft recommends UTF-8 or UTF-16.

## Best Practice

Pass `TextEncoding::UTF8` (or the encoding the counterpart requires, such as `UTF16` or `Windows`) whenever a BLOB stream carries text that is downloaded, uploaded, sent over HTTP, or exchanged with another system. Use the same encoding on both the writing and the reading side. Treat `MSDos` as legacy, chosen only when the receiving system demands an OEM code page.

Do not flag the default encoding when the stream carries binary content (images, PDFs, ZIP archives) or when text is written and read back only inside Business Central through streams with the same encoding.

See sample: [`set-text-encoding-on-streams-exchanged-externally.good.al`](set-text-encoding-on-streams-exchanged-externally.good.al).

## Anti Pattern

`CreateOutStream(OutStr)` or `CreateInStream(InStr)` without an encoding argument on a BLOB whose text is then passed to `DownloadFromStream`, `File.DownloadFromStream`, an `HttpContent`, or a file-exchange or bank-export routine, or that was filled by `UploadIntoStream` from an external file. The defect is invisible with ASCII-only test data.

See sample: [`set-text-encoding-on-streams-exchanged-externally.bad.al`](set-text-encoding-on-streams-exchanged-externally.bad.al).

## References

[Blob.CreateInStream method](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/blob/blob-createinstream-method) (the default encoding is MSDos) and [File handling and text encoding](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-file-handling-and-text-encoding) (MS-DOS depends on the server's system locale; online, use UTF-8/UTF-16).
