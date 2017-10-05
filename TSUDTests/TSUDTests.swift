import XCTest
import TSUD


let nsud = UserDefaults.standard

class TSUDTests: XCTestCase {
    func testBool() {
        struct testBool: TSUD {
            static let defaultValue = false
        }
        
        XCTAssertEqual(testBool.stringKey, "testBool")
        
        nsud.removeObject(forKey: testBool.stringKey)
        
        XCTAssertEqual(testBool.value, false)
        testBool.value = true
        XCTAssertEqual(testBool.value, true)
        XCTAssertEqual(nsud.object(forKey: "testBool") as? NSObject, true as NSNumber)
        testBool.value = false
        XCTAssertEqual(testBool.value, false)
        XCTAssertEqual(nsud.object(forKey: "testBool") as? NSObject, false as NSNumber)
    }
    
    func testInt() {
        struct testInt: TSUD {
            static let defaultValue = 42
        }
        
        XCTAssertEqual(testInt.stringKey, "testInt")
        
        nsud.removeObject(forKey: testInt.stringKey)
        
        XCTAssertEqual(testInt.value, 42)
        testInt.value += 10
        XCTAssertEqual(testInt.value, 52)
        XCTAssertEqual(nsud.integer(forKey: "testInt"), 52)
        nsud.set(999, forKey: "testInt")
        XCTAssertEqual(testInt.value, 999)
    }
    
    func testString() {
        struct testString: TSUD {
            static let defaultValue = ""
        }
        
        XCTAssertEqual(testString.stringKey, "testString")
        
        nsud.removeObject(forKey: testString.stringKey)
        
        XCTAssertEqual(testString.value, "")
        testString.value = "Hello"
        XCTAssertEqual(testString.value, "Hello")
        XCTAssertEqual(nsud.string(forKey: "testString"), "Hello")
        testString.value.append(", World")
        XCTAssertEqual(testString.value, "Hello, World")
        XCTAssertEqual(nsud.string(forKey: "testString"), "Hello, World")
    }
    
    func testDate() {
        struct testDate: TSUD {
            static let defaultValue = Date(timeIntervalSinceReferenceDate: 0)
        }
        
        XCTAssertEqual(testDate.stringKey, "testDate")
        
        nsud.removeObject(forKey: testDate.stringKey)
        
        XCTAssertEqual(testDate.value, Date(timeIntervalSinceReferenceDate: 0))
        let now = Date()
        testDate.value = now
        XCTAssertEqual(testDate.value, now)
        XCTAssertEqual(nsud.object(forKey: "testDate") as? Date, now)
    }
    
    func testData() {
        struct testData: TSUD {
            static let defaultValue = Data()
        }
        
        XCTAssertEqual(testData.stringKey, "testData")
        
        nsud.removeObject(forKey: testData.stringKey)
        
        XCTAssertEqual(testData.value, Data())
        let data = "Hello, World".data(using: .utf8)!
        testData.value = data
        XCTAssertEqual(testData.value, data)
        XCTAssertEqual(nsud.data(forKey: "testData"), data)
    }
    
    func testCodable() {
        struct Person: Codable {
            var name: String
            var quest: String
            var age: Int
        }
        
        struct testPerson: TSUD {
            static let defaultValue: Person? = nil
        }
        
        XCTAssertEqual(testPerson.stringKey, "testPerson")
        
        nsud.removeObject(forKey: "testPerson")
        
        XCTAssertNil(testPerson.value)
        testPerson.value = Person(name: "Sir Arthur", quest: "To find the Holy Grail", age: 42)
        XCTAssertEqual(testPerson.value?.name, "Sir Arthur")
        XCTAssertEqual(testPerson.value?.quest, "To find the Holy Grail")
        XCTAssertEqual(testPerson.value?.age, 42)
        XCTAssertEqual(nsud.object(forKey: "testPerson") as? [String: NSObject] ?? ["failed": "cast" as NSObject], [
            "name": "Sir Arthur" as NSObject,
            "quest": "To find the Holy Grail" as NSObject,
            "age": 42 as NSObject
        ])
    }
}
