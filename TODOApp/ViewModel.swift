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
    private var token: NotificationToken?
    @Published var itemList: [TODOItem] = []
    
    init() {
        token = model.items.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.itemList = self?.todoItems.map{ $0 } ?? []
            case .update(let record, deletions: let deletion, insertions: let insertion, modifications: let modification):
                if deletion != [] {
                    for index in deletion {
                        self?.itemList.remove(at: index)
                    }
                }
                if insertion != [] {
                    for index in insertion {
                        self?.itemList.append(record[index])
                    }
                }
                if modification != [] {
                    for index in modification {
                        self?.itemList[index] = record[index]
                    }
                }
            case .error(_):
                fatalError("error")
            }
            
        }
    }
    
    deinit {
        token?.invalidate()
    }
    
    var todoItems: Results<TODOItem> {
        model.items.sorted(by: \.dueDate)
    }
    
    func addItem(title: String, dueDate: Date, note: String) {
        let newItem = TODOItem()
        newItem.id = UUID()
        newItem.title = title
        newItem.dueDate = dueDate
        newItem.note = note
        model.addItem(newItem)
    }
    
    func deleteItem(_ id: TODOItem.ID) {
        guard let item = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.deleteItem(item)
    }
    
    func editItem(id: TODOItem.ID, title: String, dueDate: Date, note: String) {
        guard let _ = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.editItem(id: id, title: title, dueDate: dueDate, note: note)
    }
}
