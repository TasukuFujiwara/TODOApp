//
//  ViewModel.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import Foundation
import RealmSwift


// ViewModel: ビューとDBのインタフェースとなるモデル
class ViewModel: ObservableObject {
    @Published var model: DBModel = DBModel()
    
    var todoItems: Results<TODOItem> {
        model.items
    }
    
    func addItem(_ title: String) {
        let newItem = TODOItem()
        newItem.id = UUID()
        newItem.title = title
        model.addItem(newItem)
    }
    
    func deleteItem(_ id: TODOItem.ID) {
        guard let item = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.deleteItem(item)
    }
}
