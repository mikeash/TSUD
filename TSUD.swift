import Foundation

public protocol TSUD {
    associatedtype ValueType: Codable
    
    init()
    
    static var defaultValue: ValueType { get }
    
    static var stringKey: String { get }
}

public extension TSUD {
    static var stringKey: String {
        let s = String(describing: Self.self)
        if let index = s.index(of: " ") {
            return String(s[..<index])
        } else {
            return s
        }
    }
}

private protocol OptionalP {
    var isNil: Bool { get }
}

extension Optional: OptionalP {
    var isNil: Bool { return self == nil }
}

extension TSUD {
    public static var value: ValueType {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }
    
    public static func get(_ nsud: UserDefaults = .standard) -> ValueType {
        return self.init()[nsud]
    }
    
    public static func set(_ value: ValueType, _ nsud: UserDefaults = .standard) {
        self.init()[nsud] = value
    }
    
    public subscript(nsud: UserDefaults) -> ValueType {
        get {
            return decode(nsud.object(forKey: Self.stringKey)) ?? Self.defaultValue
        }
        nonmutating set {
            nsud.set(encode(newValue), forKey: Self.stringKey)
        }
    }
    
    private func decode(_ plist: Any?) -> ValueType? {
        guard let plist = plist else { return nil }
        
        switch ValueType.self {
        case is Date.Type,
             is Data.Type:
            return plist as? ValueType
            
        default:
            let data = try? PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: 0)
            guard let dataUnwrapped = data else { return nil }
            return try? PropertyListDecoder().decode(ValueType.self, from: dataUnwrapped)
        }
    }
    
    private func encode(_ value: ValueType) -> Any? {
        switch value {
        case let value as OptionalP where value.isNil: return nil
        case is Date: return value
        case is Data: return value
        
        default:
            let data = try? PropertyListEncoder().encode([value])
            guard let dataUnwrapped = data else { return nil }
            let wrappedPlist = (try? PropertyListSerialization.propertyList(from: dataUnwrapped, options: [], format: nil)) as? [Any]
            return wrappedPlist?[0]
        }
    }
}
