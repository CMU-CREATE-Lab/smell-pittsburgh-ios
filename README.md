Smell Pittsburgh for iOS
========================

A client to interface with the [Smell Pittsburgh](https://github.com/CMU-CREATE-Lab/smell-pittsburgh-rails) project (Ruby on Rails) through HTTP requests, and displays the site's smell map visualization using a Web View.

The application was developed using Xcode 7.

Also uses [SwiftSSL](https://github.com/SwiftP2P/SwiftSSL) to implement its digests. NOTE: in order to build the project with SwiftSSL, you will need to modify the module.map file by commenting out the line: `link "CommonCrypto"`.
