//
//  CreateView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI

struct CreateView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var note: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        NavigationStack {
            List {
                TextField("タイトル", text: $title)
                DatePicker("期日", selection: $dueDate)
                    .datePickerStyle(.compact)
                TextField("メモ", text: $note)
                    .frame(height: 200)
            }
            .navigationTitle("新規作成")
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("キャンセル")
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.addItem(
                                title: title == "" ? "New Title" : title,
                                dueDate: dueDate,
                                note: note)
                            if isPresented {
                                dismiss()
                            }
                        }, label: {
                            Text("追加")
                        })
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
