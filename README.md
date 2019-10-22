<p align="center">
  <img src="https://user-images.githubusercontent.com/13930558/28665145-5cae7d82-72cb-11e7-9db3-059fd95b547d.png"/>
</p>

<div align = "center">
  <a href="https://cocoapods.org/pods/NIO">
    <img src="https://img.shields.io/cocoapods/v/NIO.svg?style=flat" />
  </a>
  <a href="https://github.com/incetro/NIO">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" />
  </a>
  <a href="https://github.com/incetro/NIO#installation">
    <img src="https://img.shields.io/badge/compatible-swift%203.0-orange.svg" />
  </a>
</div>

<div align = "center">
  <a href="https://travis-ci.org/incetro/NIO">
    <img src="https://travis-ci.org/incetro/NIO.svg?branch=master" />
  </a>
  <a href="https://cocoapods.org/pods/NIO" target="blank">
    <img src="https://img.shields.io/cocoapods/p/NIO.svg?style=flat" />
  </a>
  <a href="https://cocoapods.org/pods/NIO" target="blank">
    <img src="https://img.shields.io/cocoapods/l/NIO.svg?style=flat" />
  </a>
  <br>
  <br>
</div>

An implementation of [DAO pattern](http://www.oracle.com/technetwork/java/dataaccessobject-138824.html) for CoreData and Realm (Soon).
Now you can think less about database in your applications.

- [Features](#features)
- [Supported frameworks](#supported-frameworks)
- [Usage](#usage)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Author](#author)
- [License](#license)

## Features
- [x] CRUD operations for your database based on [Monreau](https://github.com/incetro/Monreau)
- [x] Abstraction of database objects (models) from application objects (plains)

## Supported frameworks
- [x] CoreData
- [x] Realm

## Requirements
- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 8.1, 8.2, 8.3, and 9.0
- Swift 3.0, 3.1, 3.2, and 4.0

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Nio into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target "<Your Target Name>" do
    pod "NIO"
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use any dependency managers, you can integrate Nio into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Nio as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/incetro/NIO.git
  ```

- Open the new `Nio` folder, and drag the `Nio.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Nio.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Nio.xcodeproj` folders each with two different versions of the `Nio.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `Nio.framework`.

- Select the top `Nio.framework` for iOS and the bottom one for OS X.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Nio` will be listed as either `Nio iOS`, `Nio macOS`, `Nio tvOS` or `Nio watchOS`.

- And that's it!

  > The `Nio.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
  
## Author

incetro, incetro@ya.ru

## License

NIO is available under the MIT license. See the LICENSE file for more info.
