//
//  CreateView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI
import RealmSwift

// エラーの列挙
enum Error: LocalizedError {
    case none                   // エラーなし
    case nameIsEmpty            // 名前が空
    case folderAlreadyExists    // 同名のフォルダが既に存在
    
    // エラーメッセージ
    var errorDescription: String? {
        switch self {
        case .none:
            return nil
        case .nameIsEmpty:
            return "新しいフォルダ名を入力してください"
        case .folderAlreadyExists:
            return "その名前のフォルダは既に作成済みです"
        }
    }
}

// 新規作成画面
struct CreateView: View {
    @EnvironmentObject var viewModel: ViewModel         // ビューモデル
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var note: String = ""
    @State private var category: String = "なし"
    @State private var tmpCategory: String = ""
    
    @State fileprivate var showAlert: Bool = false      // アラートを表示するかどうか
    @State fileprivate var displayError: Error = .none  // エラー
    
    @Environment(\.dismiss) var dismiss                 // 遷移元に戻る
    @Environment(\.isPresented) var isPresented         // 他の画面から遷移してきたかどうか
    
    @Binding var nowCategory: String
    
    var body: some View {
        NavigationStack {
            // 入力フォーム
            Form {
                TextField("タイトル", text: $title)
                DatePicker("期日", selection: $dueDate)
                    .datePickerStyle(.compact)
                Picker("フォルダ", selection: $category) {
                    let categories = ["なし"] + viewModel.categorySet + ["+ 新規フォルダ"]
                    ForEach(categories, id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
                .onAppear {     // デフォルトの選択
                    category = nowCategory == "全てのTODO" ? "なし" : nowCategory
                }
                .onChange(of: category) { newValue in
                    if newValue == "+ 新規フォルダ" {     // これが選択されたら，アラート表示
                        showAlert = true
                    }
                }
                .alert("新規フォルダ作成", isPresented: $showAlert, actions: {      // アラート
                    TextField("新規フォルダ名", text: $tmpCategory)
                    Button("キャンセル") {
                        category = "なし"
                    }
                    Button("作成") {
                        if tmpCategory == "" {          // フォルダ名が空
                            displayError = .nameIsEmpty
                            category = "なし"
                        } else if viewModel.categorySet.contains(tmpCategory) {         // 同名のフォルダが既に存在
                            displayError = .folderAlreadyExists
                            category = tmpCategory
                        } else {            // 正常処理
                            viewModel.categorySet.append(tmpCategory)
                            category = tmpCategory
                        }
                    }
                })
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
                            if category == "+ 新規フォルダ" && tmpCategory == "" {        // 新規フォルダ名が空
                                displayError = .nameIsEmpty
                            } else if category == "+ 新規フォルダ" && viewModel.categorySet.contains(tmpCategory) {       // 同名のフォルダが既に存在
                                displayError = .folderAlreadyExists
                            } else {        // 正常処理
                                viewModel.addItem(
                                    title: title == "" ? "New Title" : title,
                                    dueDate: dueDate,
                                    note: note,
                                    category: category == "+ 新規フォルダ" ? tmpCategory : (category == "" ? "なし" : category)
                                )
                                dismiss()
                            }
                        }
                    }
                }   // if isPresented
            }   // toolbar

            // エラーメッセージ
            if let errorMessage = displayError.errorDescription {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

        }   // NavigationStack
    }   // body
}   // CreateView

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(nowCategory: Binding.constant("なし"))
            .environmentObject(ViewModel())
    }
}
