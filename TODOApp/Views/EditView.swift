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

    var body: some View {
        NavigationStack {
            List {
                TextField("タイトル", text: $title)
            }
            .navigationTitle("編集")
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("適用") {
                            viewModel.editItem(id: id, title: title)
                            dismiss()
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
        EditView(id: id, title: title)
            .environmentObject(ViewModel())
    }
}
