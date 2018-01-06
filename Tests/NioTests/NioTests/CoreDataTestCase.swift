//
//  CoreDataTestCase.swift
//  Nio
//
//  Created by incetro on 16/07/2017.
//
//

@testable
import Nio
import XCTest
import CoreData

@testable
import Monreau

// MARK: - CoreDataTestCase

class CoreDataTestCase: XCTestCase {
    
    lazy var context: NSManagedObjectContext = {
        guard let bundle = Bundle(identifier: "com.incetro.Nio") else {
            fatalError()
        }
        return CoreDataConfigurator.setup(withBundle: bundle, config: CoreStorageConfig(containerName: "NioModel", storeType: .memory))
    }()
    
    func createPlainCategories(count: Int, positionsCount: Int, additivesCount: Int) -> [CategoryPlainObject] {
        var result: [CategoryPlainObject] = []
        for i in 0..<count {
            let category = CategoryPlainObject(with: "Category #\(i + 1)", id: Int64(i + 1))
            for j in 0..<positionsCount {
                let id = Int64(i * positionsCount + j + 1)
                let position = PositionPlainObject(with: "Position #\(id)", price: Double(arc4random() % 1000), id: id)
                for k in 0..<additivesCount {
                    let id = Int64(Int(id - 1) * additivesCount + k + 1)
                    let additive = AdditivePlainObject(with: "Additive #\(id)", price: Double(arc4random() % 1000), id: id)
                    position.additives.append(additive)
                }
                category.positions.append(position)
            }
            result.append(category)
        }
        return result
    }
    
    func testCategories() {
        
        let dao = Nio.coredata(withContext: self.context, model: CategoryModelObject.self, plain: CategoryPlainObject.self)
        
        do {
            
            let categoriesCount = 10
            let positionsCount  = 5
            let additivesCount  = 2
            
            var input: [CategoryPlainObject] = self.createPlainCategories(count: categoriesCount, positionsCount: positionsCount, additivesCount: additivesCount)
            
            try dao.persist(input, erase: false)
            
            let categories = try dao.read().sorted(by: { (first, second) -> Bool in
                first.id < second.id
            })
            
            XCTAssertEqual(categories.count, input.count)
            XCTAssertEqual(categoriesCount,  input.count)
            
            for i in 0..<categoriesCount {
                
                XCTAssertEqual(categories[i].id,    input[i].id)
                XCTAssertEqual(categories[i].name,  input[i].name)
                XCTAssertEqual(categories[i].nioID, input[i].nioID)
                
                let positions = categories[i].positions.sorted(by: { (first, second) -> Bool in
                    first.id < second.id
                })
                
                XCTAssertEqual(positions.count, input[i].positions.count)
                XCTAssertEqual(positionsCount, input[i].positions.count)
                
                for j in 0..<positions.count {
                    
                    XCTAssertEqual(positions[j].id, input[i].positions[j].id)
                    XCTAssertEqual(positions[j].name, input[i].positions[j].name)
                    XCTAssertEqual(positions[j].price, input[i].positions[j].price)
                    XCTAssertEqual(positions[j].nioID, input[i].positions[j].nioID)
                    XCTAssertEqual(positions[j].additives.count, input[i].positions[j].additives.count)
                    XCTAssertEqual(additivesCount, input[i].positions[j].additives.count)
                    
                    let additives = positions[j].additives.sorted(by: { (first, second) -> Bool in
                        first.id < second.id
                    })
                    
                    for k in 0..<additives.count {
                        XCTAssertEqual(additives[k].id, input[i].positions[j].additives[k].id)
                        XCTAssertEqual(additives[k].name, input[i].positions[j].additives[k].name)
                        XCTAssertEqual(additives[k].price, input[i].positions[j].additives[k].price)
                        XCTAssertEqual(additives[k].nioID, input[i].positions[j].additives[k].nioID)
                    }
                }
            }
            
            try dao.erase(byPrimaryKeys: categories.map {
                $0.nioID
            })
            
            XCTAssertEqual(try dao.read().count, 0)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
