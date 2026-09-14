# OrePAN2::Lite 2.0.0

**Released:** 2026-09-14  
**Author:** Rob Lauer <rclauer@gmail.com>

---

## Overview

2.0.0 is a major, breaking release. The distribution has been substantially
slimmed down: all command-line scripts and the auditor have been removed, and
the heavy dependency tree they required has been replaced with lighter
alternatives. `OrePAN2::Lite` is now a **library only** — drive it from your
own code rather than the old `orepan2-*` scripts.

---

## Breaking Changes

### All CLI scripts removed

The following scripts have been deleted from the distribution:

- `orepan2-inject`
- `orepan2-indexer`
- `orepan2-gc`
- `orepan2-merge-index`
- `orepan2-audit`

`OrePAN2::Lite` is now a library. Use the Perl API directly (see
[Usage](#usage) below).

### Modules removed

| Module | Reason |
|--------|--------|
| `OrePAN2::Auditor` | Removed with `orepan2-audit`; pulled `MooX::Options` and `List::Compare` |
| `OrePAN2::CLI::Indexer` | Removed with `orepan2-indexer` |
| `OrePAN2::CLI::Inject` | Removed with `orepan2-inject` |

### `OrePAN2::Index` — `merge` and `write_gzip` removed

Index merging (previously exposed via `orepan2-merge-index`) and gzip writing
are no longer part of `OrePAN2::Index`. Gzip writing is handled by
`OrePAN2::Indexer`.

### MetaCPAN integration removed from the indexer

`OrePAN2::Indexer` no longer consults MetaCPAN to shortcut `provides` scanning.
It always scans the local tarball. The `metacpan` constructor option and the
`do_metacpan_lookup` / `_maybe_index_from_metacpan` methods have been removed.

---

## Dependency Changes

### Removed

| Removed Dependency | Replaced By |
|--------------------|-------------|
| `Moo` / `Moo::Role` | `Class::Accessor::Fast` + `Role::Tiny` |
| `MooX::Options` | *(removed with CLI scripts)* |
| `MetaCPAN::Client` | `HTTP::Tiny` + `JSON::PP` (single API call) |
| `Archive::Extract` | `Archive::Tar` |
| `List::Compare` | *(removed with `OrePAN2::Auditor`)* |
| `namespace::clean` | *(removed)* |
| `Type::Params` | *(removed)* |
| `Types::Standard` | *(removed)* |
| `Types::Common::Numeric` | *(removed)* |
| `Types::Path::Tiny` | *(removed)* |
| `Types::Self` | *(removed)* |
| `Types::URI` | *(removed)* |
| `Try::Tiny` | *(removed)* |
| `Parse::CPAN::Packages::Fast` | *(removed with `OrePAN2::Auditor`)* |
| `LWP::UserAgent` | *(was already removed in 1.x)* |

### Added / Changed

| Dependency | Notes |
|------------|-------|
| `Class::Accessor::Fast` >= 0.51 | Replaces `Moo` for all classes |
| `Role::Tiny` >= 2.002004 | Replaces `Moo::Role` |
| `Role::Tiny::With` >= 2.002004 | New |
| `JSON::PP` >= 4.16 | Used for MetaCPAN API response parsing in the injector |
| `CPAN::Meta` requirement relaxed | 2.150010 → 2.131560 |

### Recommended (soft dependency)

- `IO::Socket::SSL` — required for HTTPS injection. If absent, a clear runtime
  error is raised when an `https://` URL is used; `http://` and local-file
  injection work without it.

### Test dependency added

- `Test::RequiresInternet` — gates live network tests.

### Current required dependency set

```
CPAN::Meta            >= 2.131560
Class::Accessor::Fast >= 0.51
File::pushd           >= 1.016
HTTP::Tiny            >= 0.088
IO::File::AtomicChange >= 0.08
JSON::PP              >= 4.16
Parse::LocalDistribution >= 0.20
Path::Tiny            >= 0.150
Role::Tiny            >= 2.002004
Role::Tiny::With      >= 2.002004
autodie               >= 2.37
```

---

## Changes by Module

### `OrePAN2`

- Added `$VERSION`.

### `OrePAN2::Index`

- Replaced `Moo` with `Class::Accessor::Fast` (`parent`) + `Role::Tiny::With`.
- Added explicit `new` constructor.
- Added `use strict; use warnings`.
- PBP-style refactoring throughout.

### `OrePAN2::Indexer`

- Replaced `Moo` with `Class::Accessor::Fast` + `Role::Tiny::With`.
- Added explicit `new` constructor.
- `make_index`: removed `Type::Params` signature, removed MetaCPAN lookup path.
- `add_index`: replaced `Archive::Extract` with `Archive::Tar`.
- `scan_provides`: PBP refactoring; uses `$EVAL_ERROR` (`English`).
- `_maybe_index_from_metacpan`: **removed**.
- `do_metacpan_lookup`: **removed**.
- `list_archive_files`: uses character-class regex syntax; `no_chdir => 1` retained.

### `OrePAN2::Injector`

- Replaced `Moo` with `Class::Accessor::Fast`.
- Added explicit `new` constructor.
- `inject` (by module name): replaced `MetaCPAN::Client` full client with a
  single `HTTP::Tiny` GET to `fastapi.metacpan.org/v1/download_url/<Module>`,
  decoded with `JSON::PP`.
- `inject_from_http`: added explicit SSL availability check with a clear error
  message when `IO::Socket::SSL` is absent and an `https://` URL is used.
- `tarpath` / `_detect_author`: replaced `Archive::Extract` with `Archive::Tar`.
- Added `author_subdir` accessor.

### `OrePAN2::Logger`

- Replaced `Moo` with `Role::Tiny`.
- Added `use strict; use warnings`.
- `info` / `warn` now use indirect filehandle syntax (`print {*STDERR} ...`).

### `OrePAN2::Repository`

- Replaced `Moo` with `Class::Accessor::Fast`.
- Added explicit `new` constructor; lazy builders are now called from `new`.
- Added `use strict; use warnings`.
- `has_cache` / `save_cache`: delegated via thin wrappers (no Moo `handles`).
- PBP refactoring throughout.

### `OrePAN2::Repository::Cache`

- Replaced `Moo` with `Class::Accessor::Fast`.
- Added explicit `new` constructor; builders called from `new`.
- Added `use strict; use warnings`.
- Uses `$RS` from `English` for slurp-read.
- PBP refactoring throughout.

### `OrePAN2::Role::HasLogger`

- Replaced `Moo::Role` with `Role::Tiny`.
- `log` accessor implemented as a plain sub with lazy initialisation via
  `$self->{log}` rather than a Moo lazy attribute.

---

## Test Suite

### New tests

- `t/00_compile.t`
- `t/01_indexer.t`
- `t/02_no_index.t`
- `t/03_inject.t`
- `t/04_repository.t`
- `t/06_inject_live.t`
- `t/index.t`

### Removed tests

- `t/07_auditor.t` — removed with `OrePAN2::Auditor`
- `t/dat/auditor/cpan/02packages.details.txt` — removed
- `t/dat/auditor/darkpan/02packages.details.txt` — removed

### Test data

- Added `t/lib/Local/Util.pm` to the distribution's extra-files.

---

## Build System

The following `CPAN::Maker::Bootstrapper`-managed files were updated:

- `.gitignore` — added `**/*.raw`, `buildspec.yml.current`, `extra-files.mk`, `local/**`
- `.includes/git.mk` — new `repo` target for creating GitHub repositories
- `.includes/help.mk` — help output now uses a pager; updated variable list
- `.includes/perl.mk` — multiple improvements:
  - `PERLINCLUDE` now includes `local/lib/perl5`
  - `PERLCRITIC_SEVERITY` and `PERLCRITIC_THEME` variables added (default: severity 5, theme `pbp`)
  - Syntax checking and templating combined back into a single `%.pm` / `%.pl` pattern rule
  - `deps.mk` now depends on `.pm.in` / `.pl.in` source files rather than built `.pm` / `.pl` targets, eliminating the `make clean` forced-rebuild cycle
  - `check-syntax` sentinel files (`%.pm.checked`, `%.pl.checked`) removed
  - `PERL5LIB` explicitly cleared during `perl -wc` syntax checks to avoid interference
  - `cpm` / `carton` detection added (`CPM`, `CARTON`, `CPAN_INSTALLER` variables)
- `.includes/release-notes.mk` — now calls `cmb release-notes` (was `bootstrapper release-notes`)
- `.includes/update.mk` — `post-update` now merges `.gitignore` entries from the bootstrapper; `bash-completion.mk`, `modulino.mk`, and `local.mk` added to `MANAGED_FILES`; Makefile update order fixed
- `.includes/version.mk` — `release`, `minor`, `major` targets now run `clean` first
- `.includes/local.mk` — new managed file
- `.includes/modulino.mk` — new
- `.includes/bash-completion.mk` — new
- `Makefile`:
  - `BOOTSTRAPPER` now resolves to `cmb` (was `bootstrapper`)
  - `SCANDEPS` now resolves to `scandeps-static` (was `scandeps-static.pl`)
  - `MD_UTILS` now resolves to `markdown-render` (was `md-utils.pl`)
  - `GITHUB_ACTIONS` variable added (resolves `gha-aws`)
  - `TEMPLATE_VARS` list added; template substitution uses `cmb resolve-vars` throughout (replaces `sed` calls)
  - `cpanfile` generation split into `cpanfile.requires`, `cpanfile.recommends`, `cpanfile.suggests` intermediate targets
  - `recommends` and `suggests` targets added
  - Dependency scanning refactored: single grouped scan produces `requires.raw`, `recommends.raw`, `suggests.raw`; reconciliation via `cmb filter`
  - `extra-files.mk` target added to track distribution extra-files changes
  - `package` target added (`clean` + `LINT=on SCAN=on`)
  - `DOCKER_CPAN_INSTALLER` replaces `INSTALLER`; `build-ci` mounts the working directory into the container
  - `GIT_SHA` and `GIT_DIRTY` variables added

---

## Usage

### Inject a distribution

```perl
use OrePAN2::Injector ();

my $injector = OrePAN2::Injector->new( directory => '/path/to/darkpan' );

$injector->inject('/path/to/MyModule-1.0.0.tar.gz');           # local file
$injector->inject('https://cpan.metacpan.org/.../Module-1.0.tar.gz'); # URL
$injector->inject('git://github.com/you/My-Module.git@1.0.0'); # git
$injector->inject('Some::Module');                              # by name via MetaCPAN
```

### Rebuild the index

```perl
use OrePAN2::Repository ();

my $repo = OrePAN2::Repository->new( directory => '/path/to/darkpan' );
$repo->make_index;
```

### Install from your DarkPAN

```bash
cpanm --mirror-only --mirror=file:///path/to/darkpan/ MyModule
cpm install --resolver 02packages,https://your-darkpan.example.com/ MyModule
```

---

## See Also

- [OrePAN2](https://metacpan.org/pod/OrePAN2) — upstream distribution
- [OrePAN2::S3](https://github.com/rlauer6/orepan2-s3) — S3/SQS-backed DarkPAN indexing for AWS Lambda