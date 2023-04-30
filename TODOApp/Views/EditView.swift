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

    var body: some View {
        NavigationStack {
            List {
                if !isEditing {
                    TextField("タイトル", text: $title)
                        .disabled(true)
                    DatePicker("期日", selection: $dueDate)
                        .disabled(true)
                    TextField("メモ", text: $note)
                        .disabled(true)
                } else {
                    TextField("タイトル", text: $title)
                    DatePicker("期日", selection: $dueDate)
                    TextField("メモ", text: $note)
                }
            }
            .navigationTitle(isEditing ? "編集" : "詳細")
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isEditing {
                            Button("編集") {
                                isEditing.toggle()
                            }
                        } else {
                            Button("適用") {
                                viewModel.editItem(id: id, title: title, dueDate: dueDate, note: note)
                                dismiss()
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
