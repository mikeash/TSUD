# Type-Safe User Defaults

TSUD (pronounced "tsud") stands for Type-Safe User Defaults and is an experimental Swifty wrapper around `NSUserDefaults`.


# License

Public domain. Do what you feel like. Credit is appreciated but not required.

# Example Use

To declare a key, write a `struct` conforming to the `TSUD` protocol. Inside, implement a single `static` property called `defaultValue` which contains the value to be returned if `UserDefaults` doesn't contain a value:

    struct fontSize: TSUD {
        static let defaultValue = 12.0
    }

To read or write the value, use the `value` property on the `struct`:

    let font = NSFont.systemFont(ofSize: fontSize.value)
    fontSize.value = 14.0

Since `value` is just a property, you can do disturbing and unnatural things like `+=` to it.

    fontSize.value += 5.0

If you want to be able to detect the lack of a value and handle it specially rather than getting a default value, declare `defaultValue` to be optional and set it to `nil`:

    struct username: TSUD {
        static let defaultValue: String? = nil
    }

Then use it like any other optional:

    if let username = username.value {
        field.string = username
    } else {
        username.value = promptForUsername()
    }

By default, `TSUD` types correspond to a `UserDefaults` key matching their type name. These examples would be stored under `"fontSize"` and `"username"`. If you need to override this (for example, because you want to access a key that has a space in it, or you don't like the key's capitalization in your code), implement the `stringKey` property:

    struct hasWidgets: TSUD {
        static let defaultValue = false
        static let stringKey = "Has Widgets"
    }

Arbitrary `Codable` types are supported. They are encoded as property list objects:

    struct Person: Codable {
        var name: String
        var quest: String
        var age: Int
    }
    
    struct testPerson: TSUD {
        static let defaultValue: Person? = nil
    }

If you prefer, you can also use methods to get and set the value:

    if hasWidgets.get() {
        hasWidgets.set(false)
    }

These methods allow you to specify the `UserDefaults` object to work with, in the unlikely event that you want to work with something other than `UserDefaults.standard`:

    let otherDefaults = UserDefaults(suitName: "...")!
    if hasWidgets.get(otherDefaults) {
        // That other thing has widgets!
    }

If you want to access the value in another `UserDefaults` instance as a mutable value, there's a subscript which takes a `UserDefaults` instance and provides the value. Unfortunately, Swift doesn't allow `static` subscripts, so you have to instantiate the key type:

    fontSize()[otherDefaults] += 10.0

# Code Signing
You have to set your development team as *Custom Path* in `(Xcode menu → Preferences… → Locations → Custom Paths)`
with the following properties:

| Key           | Value            |
| ---           | ---              |
| Name:         | DEVELOPMENT_TEAM |
| Display Name: | Development Team |
| Path:         | <YOUR TEAM ID>   |

**But there’s a catch!** Unfortunately, as soon as you change anything in the project (update a build setting, add a new build phase, rename a target etc.) the development team will be automatically added to the project.pbxproj file (in the TargetAttributes of the project object). This requires constant care not to commit those changes.

Thanks to 0xced for his [answer on Stackoverflow](https://stackoverflow.com/a/40424891) to the
question [How to prevent Xcode 8 from saving “development team” in .pbxproj?](https://stackoverflow.com/q/39669661)
