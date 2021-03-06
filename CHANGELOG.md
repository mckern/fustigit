## Changelog
All notable changes to this project will be documented in this file.
This project attempts to adhere to [Semantic Versioning](http://semver.org/).
This changelog attempts to adhere to [Keep a CHANGELOG](http://keepachangelog.com/).

## [0.2.0] - 24 October 2019
### Changed
- Updated semantics to address use of frozen string literals
- Updated minitest semantics to address global `must_equal` deprecations
- Dropped support for Ruby versions older than 2.5.0
- Numerous Rubocop related fixups

## [0.1.4] - 06 March 2017
### Added
- Fixed a missing '-' in the regex pattern that defined the parts of a triplet
- Numerous Rubocop related fixups

## [0.1.3] - 07 July 2016
### Added
- Triplets#split method returns the expected array of values for parsed triplets

### Changed
- Improved Triplets#triplet? functionality

## [0.1.2] - 07 July 2016
### Added
- Triplets#triplet? method allows for fast testing on parsed triplets

## [0.1.1] - 09 May 2016
### Added
- Fix Ruby 2.2.0 and 2.3.0 support
- Add JRuby to Travis checks
- Make Rubocop print cop names by default

## [0.1.0] - 09 May 2016
### Added
- Initial release
- README covers usage, licensing, and rationale

[0.1.4]: https://github.com/mckern/fustigit/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/mckern/fustigit/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/mckern/fustigit/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/mckern/fustigit/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/mckern/fustigit/tree/0.1.0
