# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.3.0] - 2019-05-26

### Added
- added support for local encoding options ("(?u:\w)", "(?a)[[:word:]]")

## [3.2.0] - 2019-05-18

### Added
- added support for absence groups ("(?~foo)")

### Fixed
- fixed `#to_s` output being syntactically invalid in JS when converting an empty Regexp
- fixed missing codepoints in "\R" replacement (vertical tab, form feed, nextline)

## [3.1.1] - 2018-09-24

### Fixed
- relaxed unnecessarily strict dependency on character_set 1.0.x

## [3.1.0] - 2018-09-17

### Added
- added support for conditionals ("(a)?(?(1)b|c)")
- added support for forward-referring subexpression calls ("\g<+2>")

### Fixed
- empty alternation branches ("(a|)") are no longer removed since the potential for a zero-width match might be intended
- fixed conversion of astral plane literals with lengths greater than one
- fixed handling of locally case-insensitive literals (following e.g. "(?i)") with lengths greater than one
- fixed a rare bug where backreferences, atomic groups and subexpression calls weren't handled correctly if preceded by either the linebreak type ("\R") or an option group with children ("(?i:...)")

## [3.0.0] - 2018-09-04
Major refactoring adding [character_set](https://github.com/jaynetics/character_set) and [regexp_property_values](https://github.com/jaynetics/regexp_property_values) as dependencies.

### Changed
- changed default options: the `g` flag is no longer automatically set, use `JsRegex.new(//, options: 'g')` to force it (#5)
- changed handling of unicode properties (\p{...}) and posix classes ([:...:]); their replacements now match the same codepoints as the host ruby version
- changed required ruby version from 1.9.3 to 2.1.0

### Added
- added support for moderately sized astral plane properties (e.g. \p{emoji})
- added full support for set nesting (e.g. "[a[^123]]")
- added full support for set ranges (including non-literal, e.g. "[\x00-\b]")
- added support for astral plane set members
- added support for set intersections (e.g. "[a-z&&[^aeiou]]")
- added support for set intersections (e.g. "[a-z&&[^aeiou]]")
- added support for all types of subexpression calls (e.g. "(foo)\g<1>")
- added support for bell and escape shortcuts ("\a", "\e")
- added warnings for ranges and unicode properties with large astral plane parts

### Fixed
- fixed handling of escaped alternation chars a.k.a. pipes ("\\|")

## [2.2.2] - 2018-07-09
### Fixed
- fixed errors on new Ruby versions by upgrading regexp_parser dependency

## [2.2.1] - 2018-03-15
### Fixed
- fixed handling of superfluous forward slash escapes; thanks to https://github.com/JasonBarnabe for the cue
- fixed quantification of astral plane literals by wrapping their surrogate pair substitution in a passive group

## [2.2.0] - 2018-03-04
### Added
- added support for the most recent unicode age properties (BMP parts only)

### Fixed
- fixed handling of \p{Pc}, \p{Nl} and several other, older unicode properties; thanks to https://github.com/mojavelinux

## [2.1.0] - 2017-11-03
### Added
- added support for option groups and switches ("(?-m:.)", "(?i)a", etc.)
- added warning for unsupported encoding options ("(?d:\w)", "(?u)", etc.)

### Fixed
- fixed handling of whitespace following x-switches ("(?x)", "(?-x)")

## [2.0.0] - 2017-09-25
Major refactoring. Using Regexp::Parser instead of Regexp::Scanner internally allows for higher-level conversions.

### Changed
- word boundaries \b and \B now cause warnings (see README for details)

### Added
- added support for possessive quantifiers ("++", "\*+", etc.)
- added support for backreferences ("\2") following atomic groups
- added support for \k-style numeric backreferences ("\k'2'")
- added support for relative backreferences ("\k'-1'")
- added support for named backreferences ("\k'foo'")
- added support for the generic linebreak type \R
- added support for control and meta escapes ("\cX", "\C-X", "\M-X", "\M-\C-X", etc.)

### Fixed
- when dropping unsupported expressions, their quantifiers are now dropped as well
- fixed handling of hex types and backspace ("\h", "\H", "\b") within negated sets
- double-negated properties ("\P{^...}") are now correctly treated as positive
- conditionals are now replaced with passive instead of capturing alternation groups

## [1.2.3] - 2017-04-12
### Fixed
- fixed handling of escaped parentheses ("\\(" and "\\)"); thanks to https://github.com/owst
- fixed handling of codepoint lists (e.g. \u{61 63 1F601}}.

## [1.2.0] - 2016-12-05
### Added
- added support for hex escapes in character sets.

### Fixed
- fixed an exotic bug with multiple stacked quantifiers (e.g. /a{2}{3}{4}/). they are now all removed instead of breaking the regex.

## [1.1.0] - 2016-11-28
### Added
- added support for astral plane literals outside of sets by converting them to surrogate pairs
- added support for the backspace pseudo set ([\b])
- added support for surrogate properties, (e.g. \p{surrogate})

### Fixed
- fixed a bug with atomic groups nested in atomic groups. they are now made non-atomic with a warning instead of breaking the regex.
- fixed a bug with negated properties (\p{^...} and \P{...}) in sets. they are now correctly extracted from sets.

## [1.0.19] - 2016-11-15
### Fixed
- fixed handling of escaped bol/eol anchors (\^ and \$); thanks to https://github.com/tomca32

## [1.0.18] - 2016-09-04
### Fixed
- fixed handling of carriage return escape sequences ("\r"); thanks to https://github.com/mrcthms
