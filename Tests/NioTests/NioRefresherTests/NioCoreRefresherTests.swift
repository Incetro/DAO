//
//  NioCoreRefresherTests.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

@testable
import Nio
import XCTest
import Monreau
import CoreData

// MARK: - NioCoreRefresherTests

class NioCoreRefresherTests: XCTestCase {
    
    lazy var context: NSManagedObjectContext = {
        guard let bundle = Bundle(identifier: "com.incetro.Nio") else {
            fatalError()
        }
        return CoreDataConfigurator.setup(withBundle: bundle, config: CoreStorageConfig(containerName: "NioModel", storeType: .memory))
    }()
    
    lazy var categoriesCRUD: CoreStorage<CategoryModelObject> = {
        return CoreStorage<CategoryModelObject>(context: self.context)
    }()
    
    lazy var positionsCRUD: CoreStorage<PositionModelObject> = {
        return CoreStorage<PositionModelObject>(context: self.context)
    }()
    
    
    lazy var additivesCRUD: CoreStorage<AdditiveModelObject> = {
        return CoreStorage<AdditiveModelObject>(context: self.context)
    }()
    
    let refresher = NioCoreRefresher(model: CategoryModelObject.self, plain: CategoryPlainObject.self)
    
    func createCategoriesInCoreData(count: Int, positionsCount: Int, additivesCount: Int) {
        do {
            for i in 0..<count {
                let category = try self.categoriesCRUD.create { category in
                    category.id    = Int64(i + 1)
                    category.nioID = "\(i + 1)"
                    category.name  = "Category #\(i + 1)"
                }
                
                for j in 0..<positionsCount {
                    let position = try self.positionsCRUD.create { position in
                        let id = Int64(i * positionsCount + j + 1)
                        position.id    = id
                        position.nioID = "\(id)"
                        position.name  = "Position #\(id)"
                        position.price = Double(arc4random() % 1000)
                        position.category = category
                    }
                    for k in 0..<additivesCount {
                        _ = try self.additivesCRUD.create { additive in
                            let id = Int64(j * additivesCount + k + 1)
                            additive.id    = id
                            additive.nioID = "\(id)"
                            additive.name  = "Additive #\(id)"
                            additive.price = Double(arc4random() % 1000)
                            additive.position = position
                        }
                    }
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func createPlainCategories(count: Int, positionsCount: Int, additivesCount: Int) -> [CategoryPlainObject] {
        var categories: [CategoryPlainObject] = []
        for i in 0..<count {
            let category = CategoryPlainObject(with: "Category #\(i + 1)", id: Int64(i + 1))
            category.positions = (0..<positionsCount).map { j in
                let id = Int64(i * positionsCount + j + 1)
                let position = PositionPlainObject(with: "Position #\(id)", price: Double(arc4random() % 1000), id: id)
                position.additives = (0..<additivesCount).map { k in
                    let id = Int64(j * additivesCount + k + 1)
                    return AdditivePlainObject(with: "Additive #\(id)", price: Double(arc4random() % 1000), id: id)
                }
                return position
            }
            categories.append(category)
        }
        return categories
    }
    
    func testSimpleRefreshing() {
        do {
            
            // given
            
            let model = try self.categoriesCRUD.create { category in
                category.id    = 1
                category.name  = "Category"
                category.nioID = "1"
            }

            let plain = self.createPlainCategories(count: 1, positionsCount: 2, additivesCount: 4)[0]
            
            // when
            
            try refresher.refresh(model, withPlain: plain)
            try categoriesCRUD.save()
            
            // then
            
            XCTAssertEqual(model.id,   plain.id)
            XCTAssertEqual(model.name, plain.name)
            
            XCTAssertEqual(model.positions.count, plain.positions.count)
            
            let positionModelObjects = (model.positions.allObjects as? [PositionModelObject])?.sorted(by: { $0.id < $1.id }) ?? []
            let positionPlainObjects = plain.positions.sorted(by: { $0.id < $1.id })
            
            for i in 0..<positionModelObjects.count {
                
                XCTAssertEqual(positionModelObjects[i].id, positionPlainObjects[i].id)
                XCTAssertEqual(positionModelObjects[i].name, positionPlainObjects[i].name)
                XCTAssertEqual(positionModelObjects[i].price, positionPlainObjects[i].price)
                XCTAssertNotNil(positionModelObjects[i].category)
                XCTAssertEqual(positionModelObjects[i].category?.objectID, model.objectID)
                XCTAssertEqual(positionModelObjects[i].additives.count, positionPlainObjects[i].additives.count)
                
                let additiveModelObjects = (positionModelObjects[i].additives.allObjects as? [AdditiveModelObject])?.sorted(by: { $0.id < $1.id }) ?? []
                let additivePlainObjects = positionPlainObjects[i].additives.sorted(by: { $0.id < $1.id })
                
                for j in 0..<additiveModelObjects.count {
                    XCTAssertEqual(additiveModelObjects[j].id, additivePlainObjects[j].id)
                    XCTAssertEqual(additiveModelObjects[j].name, additivePlainObjects[j].name)
                    XCTAssertEqual(additiveModelObjects[j].price, additivePlainObjects[j].price)
                    XCTAssertEqual(positionModelObjects[i].objectID, additiveModelObjects[j].position?.objectID)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
