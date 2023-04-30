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

    static var tmpTitle: String! = nil
    static var tmpDueDate: Date! = nil
    static var tmpNote: String! = nil
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            List {
                if !isEditing {
                    Text(title)
                    HStack {
                        Text("期日")
                        Spacer()
                        Text("\(Self.dateFormatter.string(from: dueDate))")
                    }
                    Text(note)
                        .frame(height: 200)
                } else {
                    TextField("タイトル", text: $title)
                    DatePicker("期日", selection: $dueDate)
                        .datePickerStyle(.compact)
                    TextField("メモ", text: $note, axis: .vertical)
                        .frame(height: 200)
                }
            }
            .navigationTitle(isEditing ? "編集" : "詳細")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !isEditing {
                            Button("編集") {
                                Self.tmpTitle = title
                                Self.tmpDueDate = dueDate
                                Self.tmpNote = note
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
