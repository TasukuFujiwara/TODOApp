//
//  CreateView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI

// 新規作成画面
struct CreateView: View {
    @EnvironmentObject var viewModel: ViewModel         // ビューモデル
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var note: String = ""
    @Environment(\.dismiss) var dismiss                 // 遷移元に戻る
    @Environment(\.isPresented) var isPresented         // 他の画面から遷移してきたかどうか
    
    var body: some View {
        NavigationStack {
            // 入力フォーム
            List {
                TextField("タイトル", text: $title)
                DatePicker("期日", selection: $dueDate)
                    .datePickerStyle(.compact)
                TextField("メモ", text: $note)
                    .frame(height: 200)
            }
            .navigationTitle("新規作成")
            .toolbar {
                // 他の画面（メイン画面）から遷移してきた場合
                if isPresented {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // 遷移元に戻る
                        Button("キャンセル") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // データをデータベースに追加．遷移元に戻る
                        Button("追加") {
                            viewModel.addItem(
                                title: title == "" ? "New Title" : title,
                                dueDate: dueDate,
                                note: note
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .environmentObject(ViewModel())
    }
}
