//
//  EditView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/23.
//

import SwiftUI


// 詳細・編集画面
struct EditView: View {
    @Environment(\.isPresented) var isPresented         // 他の画面から遷移してきたかどうか
    @Environment(\.dismiss) var dismiss                 // 遷移元の画面へ戻る
    @EnvironmentObject var viewModel: ViewModel         // ビューモデル
    @State var id: UUID
    @State var title: String
    @State var dueDate: Date
    @State var note: String
    @State fileprivate var isEditing: Bool = false      // 編集可能かどうか

    // 編集キャンセルの際に，修正前のデータに戻すために一時的に格納しておく変数
    static var tmpTitle: String! = nil
    static var tmpDueDate: Date! = nil
    static var tmpNote: String! = nil
    
    // 日付のフォーマット設定
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"       // "HH": 24時間制，"hh": 12時間制
        return formatter
    }()

    var body: some View {
        NavigationStack {
            List {
                if !isEditing {     // 詳細モード
                    Text(title)
                    HStack {
                        Text("期日")
                        Spacer()
                        Text("\(Self.dateFormatter.string(from: dueDate))")
                    }
                    Text(note)
                        .frame(height: 200)
                } else {            // 編集モード
                    TextField("タイトル", text: $title)
                    DatePicker("期日", selection: $dueDate)
                        .datePickerStyle(.compact)
                    TextField("メモ", text: $note, axis: .vertical)
                        .frame(height: 200)
                }
            }
            .navigationTitle(isEditing ? "編集" : "詳細")
            .navigationBarBackButtonHidden(true)
            // ツールバー
            .toolbar {
                if isPresented {    // 他の画面から遷移してきた場合
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isEditing {     // 詳細モード
                            Button("編集") {      // 編集モードへ移行するためのボタン
                                // 編集中のキャンセルに備えて，編集前に一時的にデータを保存
                                Self.tmpTitle = title
                                Self.tmpDueDate = dueDate
                                Self.tmpNote = note
                                isEditing.toggle()
                            }
                        } else {        // 編集モード
                            Button("適用") {      // 編集内容を保存し，遷移元に戻る
                                viewModel.editItem(id: id, title: title, dueDate: dueDate, note: note)
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !isEditing {     // 詳細モード
                            Button("< TODOリスト") {       // 遷移元に戻る
                                dismiss()
                            }
                        } else {            // 編集モード
                            Button("キャンセル") {       // 編集中にキャンセルした場合
                                // 編集前のデータに戻し，詳細モードへ移行
                                title = Self.tmpTitle
                                dueDate = Self.tmpDueDate
                                note = Self.tmpNote
                                isEditing.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let id = UUID()
        let title = ""
        let dueDate = Date()
        let note = ""
        EditView(id: id, title: title, dueDate: dueDate, note: note)
            .environmentObject(ViewModel())
    }
}
