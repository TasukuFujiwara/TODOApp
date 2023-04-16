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
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("タイトル", text: $title)
                    .padding()
                Button(action: {
                    viewModel.addItem(title)
                    MainView()
                        .environmentObject(ViewModel())
                }, label: {
                    Text("追加")
                })
            }
            .navigationTitle("新規作成")
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .environmentObject(ViewModel())
    }
}
