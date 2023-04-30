//
//  EditView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    @State var id: UUID
    @State var title: String
    @State var dueDate: Date
    @State var note: String
    @State fileprivate var isEditing: Bool = false

    @State var tmpTitle: String! = nil
    @State var tmpDueDate: Date! = nil
    @State var tmpNote: String! = nil
    
    //var tmpItem: TODOItem = TODOItem()

    var body: some View {
        NavigationStack {
            List {
                TextField("タイトル", text: $title)
                DatePicker("期日", selection: $dueDate)
                    .datePickerStyle(.compact)
                TextField("メモ", text: $note, axis: .vertical)
                    .frame(height: 200)
            }
            .disabled(!isEditing)
            .navigationTitle(isEditing ? "編集" : "詳細")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isEditing {
                            Button("編集") {
                                tmpTitle = title
                                tmpDueDate = dueDate
                                tmpNote = note
                                isEditing.toggle()
                            }
                        } else {
                            Button("適用") {
                                viewModel.editItem(id: id, title: title, dueDate: dueDate, note: note)
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !isEditing {
                            Button("< TODOリスト") {
                                dismiss()
                            }
                        } else {
                            Button("キャンセル") {
                                title = tmpTitle
                                dueDate = tmpDueDate
                                note = tmpNote
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
