NIO
==========

[![Build Status](https://travis-ci.org/incetro/NIO.svg?branch=master)](https://travis-ci.org/incetro/NIO)
[![CocoaPods](https://img.shields.io/cocoapods/v/NIO.svg)](https://img.shields.io/cocoapods/v/NIO.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/incetro/NIO/master/LICENSE.md)
[![Platforms](https://img.shields.io/cocoapods/p/NIO.svg)](https://cocoapods.org/pods/NIO)

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
- [x] Universal built-in Translator based on [Transformer](https://github.com/incetro/Transformer) with nested object support
- [x] Universal built-in Refresher with nested objects support
- [x] Custom translators
- [x] Custom refreshers
- [x] Abstraction of database objects (models) from application objects (plains)

## Supported frameworks
- [x] CoreData
- [ ] Realm

## Usage
The first thing you should know is that the primary key is a field named ```nioID```. And you must add this field (with String type) to your CoreData models (only in CoreData scheme). Next, I'll explain everything in the example with 3 models (```CategoryModelObject```, ```PositionModelObject``` and ```AdditiveModelObject```) and 3 plain objects (```CategoryPlainObject```, ```PositionPlainObject``` and ```AdditivePlainObject```)
### Protocols and classes
NIO contains several main classes and protocols:
- ManagedModel (class)
- TransformablePlain (protocol)
- Plain (protocol)
- Model (protocol)
### ManagedModel
All of your your CoreData models must conform this protocol.
```swift
// MARK: - CategoryModelObject
class CategoryModelObject: ManagedModel {
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var positions: NSSet
}

// MARK: - PositionModelObject
class PositionModelObject: ManagedModel {
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var price: Double
    @NSManaged var additives: NSSet
    @NSManaged var category: CategoryModelObject?
}

// MARK: - AdditiveModelObject
class AdditiveModelObject: ManagedModel {
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var price: Double
    @NSManaged var position: PositionModelObject?
}
```
### TransformablePlain
This protocol lets you use built-in Translator
```swift
// MARK: - CategoryPlainObject
class CategoryPlainObject: TransformablePlain {
    
    let name: String
    let id: Int64
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    var positions: [PositionPlainObject] = []
    
    init(name: String, id: Int64) {
        self.name  = name
        self.id    = id
    }
    
    required init(with resolver: Resolver) throws {
        self.id    = try resolver.value("id")
        self.name  = try resolver.value("name")
        
        self.positions = (try? resolver.value("positions")) ?? []
    }
}

// MARK: - PositionPlainObject
class PositionPlainObject: TransformablePlain {
    
    let id: Int64
    let name: String
    let price: Double
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    init(name: String, price: Double, id: Int64) {
        self.name  = name
        self.id    = id
        self.price = price
    }
    
    var category: CategoryPlainObject? = nil
    var additives: [AdditivePlainObject] = []
    
    required init(with resolver: Resolver) throws {
        
        self.id        =  try  resolver.value("id")
        self.name      =  try  resolver.value("name")
        self.price     =  try  resolver.value("price")
        self.category  =  try? resolver.value("category")
        self.additives = (try? resolver.value("additives")) ?? []
    }
}

// MARK: - AdditivePlainObject
class AdditivePlainObject: TransformablePlain {

    let id: Int64
    let name: String
    let price: Double  
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    init(name: String, price: Double, id: Int64) {
        self.name  = name
        self.id    = id
        self.price = price
    }
    
    var position: PositionPlainObject? = nil
    
    required init(with resolver: Resolver) throws {
        
        self.id       = try  resolver.value("id")
        self.name     = try  resolver.value("name")
        self.price    = try  resolver.value("price")
        self.position = try? resolver.value("position")
    }
}
```
### Plain
If you want to use custom Translator, use this protocol - just conform it and write your own Translator. [Example](#custom-translators)
### Initialization
```swift
/// Standard initializer with built-in Translator and Refresher
let dao = Nio.coredata(named: "AppModel", model: UserModelObject.self, plain: UserPlainObject.self)

/// Initializer with with built-in Translator and custom Refresher
let dao = Nio.coredata(named: "AppModel", refresher: refresher)

/// Initializer with custom Translator and built-in Refresher
let dao = Nio.coredata(named: "AppModel", translator: translator)

/// Initializer with custom Translator and Refresher
let dao = Nio.coredata(named: "AppModel", refresher: refresher, translator: translator)

/// Standard initializer for unit testing with built-in Translator and Refresher
let dao = Nio.coredataInMemory(named: "AppModel", model: UserModelObject.self, plain: UserPlainObject.self)

/// Initializer for unit testing with with built-in Translator and custom Refresher
let dao = Nio.coredataInMemory(named: "AppModel", refresher: refresher)

/// Initializer for unit testing with custom Translator and built-in Refresher
let dao = Nio.coredataInMemory(named: "AppModel", translator: translator)

/// Initializer for unit testing with custom Translator and Refresher
let dao = Nio.coredataInMemory(named: "AppModel", refresher: refresher, translator: translator)

/// Standard initializer with context, built-in Translator and Refresher
let dao = Nio.coredata(withContext: context, model: UserModelObject.self, plain: UserPlainObject.self)

/// Standard initializer with context, built-in Translator and custom Refresher
let dao = Nio.coredata(withContext: context, refresher: refresher)

/// Standard initializer with context, custom Translator and built-in Refresher
let dao = Nio.coredata(withContext: context, translator: translator)

/// Standard initializer with context, custom Translator and Refresher
let dao = Nio.coredata(withContext: context, translator: translator, refresher: refresher)
```
### CRUD operations
#### Create
```swift
let category = CategoryPlainObject(name: "Category #1", id: 1)
let position = PositionPlainObject(name: "Position #1", price: 225.0, id: 1)

position.additives = [
    AdditivePlainObject(name: "Additive #1", price: 20.0, id: 1),
    AdditivePlainObject(name: "Additive #2", price: 30.0, id: 2)
]

category.positions = [position]

/// Add model to your database (positions and additives will be added automatically)
try dao.create(category)
```
#### Read
```swift
/// Read all models
let categories = try dao.read()

/// Read models by filter
let categories = try dao.read(byPredicate: "id > 5")

/// Read models by NSPredicate
let predicate  = NSPredicate(format: "name = %@", name)            
let categories = try dao.read(byPredicate: predicate, orderedBy: "name", ascending: true)

/// Read model by primary key
let categories = try dao.read(byPrimaryKey: category.nioID)

/// Read models by filter with sorting
let categories = try dao.read(byPredicate: "id > 5", orderedBy: "name", ascending: true)
```
#### Update
```swift
/// Update your model
try dao.persist(category)

/// Update your models
/// if erase == true then dao remove all categories
/// whicn is in the given array but are not in databse (subtraction)
/// Example:
/// array:    [1, 2, 3, 4]
/// database: [2, 4, 6, 7]
/// erase == true:  db --> [1(created), 2(upd), 3(created), 4(upd)] and 6, 7, will be deleted
/// erase == false: db --> [1(created), 2(upd), 3(created), 4(upd), 6(without changes), 7(without changes)]
try dao.persist(categories, erase: true)

/// We recommend to use it in the following cases:
/// 1. If you have big and complex database schema (many entities, many relationships)
/// 2. If you have thousands of objects (> 10K)
try dao.persistAsync(categories, erase: false, success: {   
    /// Success
}, failure: { error in
    /// Error       
})
```
#### Delete
```swift
/// Delete all models
try dao.erase()

/// Delete concrete models
try dao.erase(plains: categories)

/// Delete models by filter
try dao.erase(byPredicate: "id < 5")

/// Delete model by primary key
try dao.erase(byPrimaryKey: category.nioID)

/// Delete models by primary keys
try dao.erase(byPrimaryKeys: keys)
```
### Custom Translators
If you want to use custom Translator, your PlainObject class must conform ```Plain``` protocol and your ModelObject class (CoreData, Realm objects...) must conform ```Model``` protocol
```swift
class CategoryTranslator: Translator {
    
    func translate(model: CategoryModelObject) throws -> CategoryPlainObject {
        /// Make plain from model here
    }
}

/// Create DAO instance
let dao = Nio.coredata(named: "AppModel", translator: CategoryTranslator())
```
### Custom Refreshers
If you want to use custom Refresher, your PlainObject class must conform ```Plain``` protocol and your ModelObject class (CoreData, Realm objects...) must conform ```Model``` protocol
```swift
class CategoryRefresher: Refresher {
    
    func refresh(_ model: CategoryModelObject, withPlain plain: CategoryPlainObject) throws {
        /// Fill model from plain here
    }
}

/// Create DAO instance
let dao = Nio.coredata(named: "AppModel", refresher: CategoryRefresher())
```
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
