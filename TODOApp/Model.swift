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
        config = Realm.Configuration(
            schemaVersion: 9
        )          // モデル定義を変更したら，schemaVersionの値を増やさないといけない
    }
    
    var realm: Realm {
        return try! Realm(configuration: config)
    }
    
    // TODOアイテムを格納する
    var items: Results<TODOItem> {
        realm.objects(TODOItem.self)
    }
    
    // idからTODOアイテムを取得する
    func itemFromID(_ id: TODOItem.ID) -> TODOItem? {
        items.first(where: {$0.id == id})
    }
    
    // アイテムをデータベースに追加
    func addItem(_ item: TODOItem) {
        self.objectWillChange.send()
        try! realm.write {
            realm.add(item)
        }
    }
    
    // データベースからアイテムを削除
    func deleteItem(_ item: TODOItem) {
        self.objectWillChange.send()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    // データベースにあるアイテムを編集
    func editItem(id: UUID, title: String, dueDate: Date, note: String, category: String) {
        guard let item = itemFromID(id) else { fatalError("id: \(id) not exists") }     // idからアイテムを検索．なかったらエラー
        self.objectWillChange.send()
        // アイテムのデータを編集
        try! realm.write {
            item.title = title
            item.dueDate = dueDate
            item.note = note
            item.category = category
        }
    }
}

// TODOItem: TODOを管理するクラス
class TODOItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()          // id
    @Persisted var title: String                                // タイトル
    @Persisted var dueDate: Date                                // 期日
    @Persisted var note: String                                 // メモ
    @Persisted var category: String                             // カテゴリー
}
