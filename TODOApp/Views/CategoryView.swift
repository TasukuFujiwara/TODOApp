//
//  CategoryView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/05/04.
//

import SwiftUI


struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ViewModel
    
    @State var createNewFolder: Bool = false
    
    @Binding var nowCategory: String
    @Binding var categoryView: Bool
    
    let categoryList = ["仕事", "重要"]
    
    var body: some View {
        let textColor: Color = colorScheme == .light ? .black : .white
        GeometryReader { geometry in
            //let width = geometry.size.width, height = geometry.size.height
            NavigationStack {
                ZStack(alignment: .leading) {
                    Color.blue
                    VStack {
                        Button("全てのTODO") {
                            nowCategory = "なし"
                            categoryView = false
                        }
                        .padding()
                        ForEach(viewModel.categories, id: \.self) { key in
                            
                            Button(key) {
                                nowCategory = key
                                categoryView = false
                            }
                            .padding()

                        }
                        
                        Button("+ 新規フォルダ") {
                            createNewFolder.toggle()
                        }
                        .padding()
                            
                    }

                }
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(textColor)
            }   // NavigationStack
            .fullScreenCover(isPresented: $createNewFolder) {
                CreateNewFolderView(createNewFolder: $createNewFolder)
            }
        }   // GeometryReader
    }   // body
}   // CategoryView

struct CreateNewFolderView: View {
    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) var dismiss
    
    @State private var newFolderName = ""
    
    @Binding var createNewFolder: Bool

    var body: some View {
        NavigationStack {
            Form {
                TextField("新規フォルダ名", text: $newFolderName)
            }
            .toolbar {
                if isPresented {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("キャンセル") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("追加") {
                            // カテゴリーリストに追加
                            // 既に同名のフォルダが存在する場合，追加せずにエラーメッセージを出す
                            dismiss()
                        }
                    }
                }   // if isPresented
            }   // toolbar
        }   // NavigationStack
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(nowCategory: Binding.constant("なし"), categoryView: Binding.constant(true))
            .environmentObject(ViewModel())
    }
}
