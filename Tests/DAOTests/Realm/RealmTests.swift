//
//  RealmTests.swift
//  SDAO
//
//  Created by incetro on 26/08/2018.
//

import RealmSwift
import Monreau
import XCTest
import SDAO

// MARK: - RealmTests

class RealmTests: XCTestCase {

    // MARK: - Properties

    private let configuration = RealmConfiguration(inMemoryIdentifier: "DAO")
    private lazy var dao = DAO(
        storage: RealmStorage<UserModelObject>(
            configuration: configuration
        ),
        translator: UsersTranslator()
    )
    
    // MARK: - Helpers
    
    func printTimeElapsedWhenRunningCode(title: String, operation: () throws -> ()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        do {
            try operation()
        } catch {
            XCTFail(error.localizedDescription)
        }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
    }
    
    // MARK: - Tests
    
    /// Tests `create` and `read by primary key` methods
    func testDAO1() {

        /// given

        let usersCount = 10
        let users = UsersFactory().users(count: usersCount)
        
        let objectsCount = users.reduce(0) { (result, user) in
            result + user.dialogs.reduce(0) { (result, dialog) in
                result + dialog.messages.count
            }
        }

        print("Test objects count: \(objectsCount)")
        
        /// when
        
        printTimeElapsedWhenRunningCode(title: "create") {
            XCTAssertNoThrow(try dao.create(users))
        }
        
        /// then
        
        do {
            XCTAssertEqual(usersCount, try dao.read().count)
            for user in users {
                guard let object = try dao.read(byPrimaryKey: user.uniqueId) else {
                    XCTFail("Object must exist here")
                    return
                }
                XCTAssertEqual(user.id, object.id)
                XCTAssertEqual(user.age, object.age)
                XCTAssertEqual(user.name, object.name)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    /// Tests `persist` and `read by primary key` methods
    func testDAO2() {

        /// given
        
        let usersCount = 10
        let users = UsersFactory().users(count: usersCount)
        
        let objectsCount = users.reduce(0) { (result, user) in
            result + user.dialogs.reduce(0) { (result, dialog) in
                result + dialog.messages.count
            }
        }

        print("Test objects count: \(objectsCount)")

        /// when

        printTimeElapsedWhenRunningCode(title: "create") {
            XCTAssertNoThrow(try dao.create(users))
        }

        let newAge = 13
        let newUsers = users.map {
            UserPlainObject(
                id: $0.id,
                name: $0.name,
                age: newAge,
                dialogs: $0.dialogs
            )
        }

        printTimeElapsedWhenRunningCode(title: "persist") {
            XCTAssertNoThrow(try dao.persist(newUsers))
        }

        /// then

        do {
            XCTAssertEqual(usersCount, try dao.read().count)
            for user in newUsers {
                guard let object = try dao.read(byPrimaryKey: user.uniqueId) else {
                    XCTFail("Object must exist here")
                    return
                }
                XCTAssertEqual(user.id, object.id)
                XCTAssertEqual(user.age, object.age)
                XCTAssertEqual(user.name, object.name)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
