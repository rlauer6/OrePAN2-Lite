# OrePAN2::Lite

A lightweight fork of [OrePAN2](https://metacpan.org/pod/OrePAN2) — a DarkPAN
manager for hosting private Perl module archives — with `LWP::UserAgent`
replaced by `HTTP::Tiny` throughout, reducing the dependency footprint for
environments where image size matters (Lambda, containers, minimal build hosts).

## What is a DarkPAN?

A DarkPAN is a private CPAN-compatible mirror. It holds tarballs you've built
yourself — internal distributions, forks of CPAN modules, or anything you want
to install via `cpanm`/`cpm` without publishing to CPAN. Tools like `cpanm`
and `cpm` can be pointed at a DarkPAN mirror the same way they talk to CPAN.

## What's different from OrePAN2?

`OrePAN2::Lite` makes two changes to the upstream `OrePAN2` distribution:

1. **`OrePAN2::Auditor` uses `HTTP::Tiny` instead of `LWP::UserAgent`.**
   The auditor compares your DarkPAN's `02packages.details.txt.gz` against
   a CPAN mirror's copy to identify outdated or private-only packages.
   Upstream uses `LWP::UserAgent` for the HTTP fetch; this fork uses
   `HTTP::Tiny` (a core module since Perl 5.14), eliminating the full
   `libwww-perl` stack and its C-compiled dependencies (`HTML::Parser`,
   `WWW::RobotRules`, `HTTP::Negotiate`, etc.) from the install.

2. **`LWP::UserAgent` is removed from the declared dependencies.**
   `Injector.pm` (for downloading tarballs) already used `HTTP::Tiny`
   in upstream. With `Auditor.pm` ported, `LWP::UserAgent` is no longer
   needed anywhere in the distribution.

Everything else — indexing, injection, garbage collection, index merging —
is unchanged from upstream.

## Installation

```bash
cpanm OrePAN2::Lite
```

Or via `cpm`:

```bash
cpm install OrePAN2::Lite
```

## Usage

### Inject a tarball into your DarkPAN

```bash
orepan2-inject /path/to/MyModule-1.0.0.tar.gz /path/to/darkpan/
```

Or from a URL:

```bash
orepan2-inject https://cpan.metacpan.org/authors/id/A/AU/AUTHOR/Module-1.0.tar.gz \
    /path/to/darkpan/
```

### Rebuild the index

```bash
orepan2-indexer /path/to/darkpan/
```

### Install from your DarkPAN

```bash
cpanm --mirror-only --mirror=file:///path/to/darkpan/ MyModule
```

Or with `cpm`, pointing at an S3/CloudFront-hosted DarkPAN:

```bash
cpm install --resolver 02packages,https://your-darkpan.example.com/ MyModule
```

### Audit your DarkPAN against CPAN

```bash
orepan2-audit \
    --cpan https://cpan.metacpan.org/modules/02packages.details.txt \
    --darkpan /path/to/darkpan/modules/02packages.details.txt.gz \
    --show outdated-modules
```

## Scripts

| Script | Description |
|--------|-------------|
| `orepan2-inject` | Inject a tarball (local file or URL) into a DarkPAN |
| `orepan2-indexer` | Rebuild `02packages.details.txt.gz` from injected tarballs |
| `orepan2-audit` | Compare DarkPAN and CPAN indexes to find outdated/private packages |
| `orepan2-gc` | Remove tarballs not referenced by the current index |
| `orepan2-merge-index` | Merge two DarkPAN indexes |

## Why fork rather than patch upstream?

`OrePAN2` is a well-maintained, actively-used CPAN module. The `LWP::UserAgent`
dependency is a reasonable default for a general-purpose CLI tool. However for
environments with strict size budgets (AWS Lambda, minimal container images,
build environments that avoid C compilation), the full LWP stack is significant
overhead for what amounts to a single HTTP GET call in one optional sub-command.

Rather than upstream a change that might not suit all users, this fork provides
a drop-in replacement for environments that care about the footprint difference.

## See Also

- [OrePAN2](https://metacpan.org/pod/OrePAN2) — the upstream distribution
- [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) — the replacement HTTP client
- [OrePAN2::S3](https://github.com/rlauer6/orepan2-s3) — S3/SQS-backed
  DarkPAN indexing for AWS Lambda, which motivated this fork

## License

Same as OrePAN2: Artistic License 2.0.
