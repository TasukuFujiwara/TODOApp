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
    @Published var model: DBModel = DBModel()           // データベースモデル呼び出し
    private var token: NotificationToken?               // データベースの変化を取得するトークン
    @Published var itemList: [TODOItem] = []            // TODOアイテムを格納しているリスト
    
    init() {
        // データベースの変化を検知
        token = model.items.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.itemList = self?.todoItems.map{ $0 } ?? []
            case .update(let record, deletions: let deletion, insertions: let insertion, modifications: let modification):
                // 消去
                if deletion != [] {
                    for index in deletion {
                        self?.itemList.remove(at: index)
                    }
                }
                // 追加
                if insertion != [] {
                    for index in insertion {
                        self?.itemList.append(record[index])
                    }
                }
                // 編集
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
    
    // デイニシャライザ
    deinit {
        token?.invalidate()
    }
    
    // TODOアイテムを格納している．期日の近い順にソート
    var todoItems: Results<TODOItem> {
        model.items.sorted(by: \.dueDate)
    }
    
    // データベースへアイテム追加依頼
    func addItem(title: String, dueDate: Date, note: String) {
        let newItem = TODOItem()
        newItem.id = UUID()
        newItem.title = title
        newItem.dueDate = dueDate
        newItem.note = note
        model.addItem(newItem)
    }
    
    // データベースからアイテム削除依頼
    func deleteItem(_ id: TODOItem.ID) {
        guard let item = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.deleteItem(item)
    }
    
    // データベース中の特定のアイテムデータを編集依頼
    func editItem(id: TODOItem.ID, title: String, dueDate: Date, note: String) {
        guard let _ = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.editItem(id: id, title: title, dueDate: dueDate, note: note)
    }
}
