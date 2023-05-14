//
//  ViewModel.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import Foundation
import RealmSwift
import OrderedCollections


// ViewModel: ビューとDBのインタフェースとなるモデル
class ViewModel: ObservableObject {
    @Published var model: DBModel = DBModel()           // データベースモデル呼び出し
    private var tokenTODO: NotificationToken?               // データベースの変化を取得するトークン
    private var tokenCategory: NotificationToken?
    @Published var itemList: [TODOItem] = []            // TODOアイテムを格納しているリスト
    @Published var categorySet: OrderedSet<String> = []
    @Published var itemDict: [String:[TODOItem]] = [:]
    
    init() {
        // データベースの変化を検知
        tokenTODO = model.items.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.itemList = self?.todoItems.map({$0}) ?? []
                self?.itemDict = Dictionary(grouping: self?.todoItems.map({$0}) ?? [], by: { $0.category })
                self?.categorySet = OrderedSet(self?.todoItems.map{ $0.category }.filter({ $0 != "なし"}) ?? [])
                
            case .update(let record, deletions: let deletion, insertions: let insertion, modifications: let modification):
                // 消去
                if deletion != [] {
                    for index in deletion {
                        self?.itemList.remove(at: index)
                    }
                    self?.itemDict = Dictionary(grouping: self?.todoItems.map({$0}) ?? [], by: { $0.category })
                    self?.categorySet = OrderedSet(self?.todoItems.map{ $0.category }.filter({ $0 != "なし"}) ?? [])
                }
                // 追加
                if insertion != [] {
                    for index in insertion {
                        self?.itemList.append(record[index])
                        self?.itemDict[record[index].category]?.append(record[index])
                        self?.categorySet.append(record[index].category)
                    }
                    self?.itemDict = Dictionary(grouping: self?.todoItems.map({$0}) ?? [], by: { $0.category })
                    self?.categorySet = OrderedSet(self?.todoItems.map{ $0.category }.filter({ $0 != "なし"}) ?? [])
                }
                // 編集
                if modification != [] {
                    for index in modification {
                        self?.itemList[index] = record[index]
                    }
                    self?.itemDict = Dictionary(grouping: self?.todoItems.map({$0}) ?? [], by: { $0.category })
                    self?.categorySet = OrderedSet(self?.todoItems.map{ $0.category }.filter({ $0 != "なし"}) ?? [])
                }   // if modification != []
            case .error(_):
                fatalError("error")
            }   // switch
        }   // tokenTODO
    }   // init
    
    // デイニシャライザ
    deinit {
        tokenTODO?.invalidate()
    }
    
    // TODOアイテムを格納している．期日の近い順にソート
    var todoItems: Results<TODOItem> {
        model.items.sorted(by: \.dueDate)
    }

    // データベースへアイテム追加依頼
    func addItem(title: String, dueDate: Date, note: String, category: String) {
        let newItem = TODOItem()
        newItem.id = UUID()
        newItem.title = title
        newItem.dueDate = dueDate
        newItem.note = note
        newItem.category = category
        model.addItem(newItem)
    }
    
    // データベースからアイテム削除依頼
    func deleteItem(_ id: TODOItem.ID) {
        guard let item = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.deleteItem(item)
    }
    
    // データベース中の特定のアイテムデータを編集依頼
    func editItem(id: TODOItem.ID, title: String, dueDate: Date, note: String, category: String) {
        guard let _ = model.itemFromID(id) else { fatalError("id: \(id) not exists") }
        model.editItem(id: id, title: title, dueDate: dueDate, note: note, category: category)
    }

}
