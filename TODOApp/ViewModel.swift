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
    @Published var categoryList: [String] = ["仕事", "プライベート", "重要"]
    @Published var itemDict: [String:[TODOItem]] = [:]  // TODOアイテムをカテゴリーごとに分けて格納している辞書
    
    init() {
        // データベースの変化を検知
        token = model.items.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.itemList = self?.todoItems.map{ $0 } ?? []
//                if let keys = self?.itemDict.keys {
//                    for category in keys {
//                        if self?.categoryList.contains(category) != nil {
//                            self?.categoryList.append(category)
//                        }
//                    }
//                }
//                if let todoItems = self?.todoItems {
//                    for todoItem in todoItems {
//                        let key = todoItem.category
//                        self?.itemDict[key]!.append(todoItem)
//                    }
//                } else { self?.itemDict = [:] }
            case .update(let record, deletions: let deletion, insertions: let insertion, modifications: let modification):
                // 消去
                if deletion != [] {
                    for index in deletion {
                        self?.itemList.remove(at: index)
                        let deleteItem = record[index]
                        //self?.itemDict[deleteItem.category]!.removeAll(where: { $0.id == deleteItem.id })
                    }
                }
                // 追加
                if insertion != [] {
                    for index in insertion {
                        let appendItem = record[index]
//                        if var categoryList = self?.categoryList {
//                            if !categoryList.contains(appendItem.category) {
//                                categoryList.insert(appendItem.category)
//                            }
//                        }
                        self?.itemList.append(appendItem)
                        //self?.itemDict[appendItem.category]!.append(record[index])
                    }
                }
                // 編集
                if modification != [] {
                    for index in modification {
                        let editedItem = record[index]      // 編集後アイテムを取得
//                        if let oldEditedItem = self?.itemList[index] {      // 編集前アイテムを取得
//                            if editedItem.category != oldEditedItem.category {      // 編集前と編集後でカテゴリーが変わっている場合
//                                self?.itemDict[oldEditedItem.category]!.removeAll(where: { $0.id == editedItem.id})     // 編集前のカテゴリーをキーとする配列から該当要素を削除
//                                self?.itemDict[editedItem.category]!.append(editedItem)     // 新しいカテゴリーをキーとする配列に編集後アイテムを格納
//                            } else {        // 編集前とカテゴリーが同じ場合
//                                // 辞書中の該当するカテゴリーをキーとする配列から編集前データを取り出し，編集後データで書き換え
//                                if var list = self?.itemDict[oldEditedItem.category] {
//                                    if let oldEditedItemIndex = list.firstIndex(where: {$0.id == oldEditedItem.id}) {
//                                        list[oldEditedItemIndex] = editedItem
//                                    }
//                                }
//                            }
//                        }
                        self?.itemList[index] = editedItem
                    }
                }   // if modification != []
            case .error(_):
                fatalError("error")
            }   // switch
        }   // token
    }   // init
    
    // デイニシャライザ
    deinit {
        token?.invalidate()
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
