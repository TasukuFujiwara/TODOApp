//
//  Model.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import Foundation
import RealmSwift

// TODOModel: データベースを管理するクラス
class DBModel: ObservableObject {
    var config: Realm.Configuration
    
    init() {
        config = Realm.Configuration()
    }
    
    var realm: Realm {
        return try! Realm(configuration: config)
    }
    
    var items: Results<TODOItem> {
        realm.objects(TODOItem.self)
    }
    
    func itemFromID(_ id: TODOItem.ID) -> TODOItem? {
        items.first(where: {$0.id == id})
    }
    
    func addItem(_ item: TODOItem) {
        self.objectWillChange.send()
        try! realm.write {
            realm.add(item)
        }
    }
    
    func deleteItem(_ item: TODOItem) {
        self.objectWillChange.send()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func editItem(id: UUID, title: String) {
        guard let item = itemFromID(id) else { fatalError("id: \(id) not exists") }
        self.objectWillChange.send()
        try! realm.write {
            item.title = title
        }
    }
}

// TODOItem: TODOを管理するクラス
class TODOItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String
}
