//
//  CategoryView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/05/04.
//

import SwiftUI
import RealmSwift


struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ViewModel
    
    @State var createNewFolder: Bool = false
    @State var selection: Set<String> = []
    
    @Binding var nowCategory: String
    @Binding var categoryView: Bool
    
    let categoryList = ["仕事", "重要"]
    
    var body: some View {
        let textColor: Color = colorScheme == .light ? .black : .white
        GeometryReader { geometry in
            NavigationStack {
                ZStack(alignment: .leading) {
                    Color.blue
                    VStack {
                        Text("全てのTODO")
                            .padding()
                            .onTapGesture {
                                nowCategory = "全てのTODO"
                                categoryView = false
                            }
                        ForEach(viewModel.categorySet.elements, id: \.self) { key in
                            Text(key)
                                .onTapGesture {
                                    nowCategory = key
                                    categoryView = false
                                }
                                .padding()
                        }
                    }   // VStack
                }   // ZStack
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(textColor)
            }   // NavigationStack
        }   // GeometryReader
    }   // body
}   // CategoryView

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(nowCategory: Binding.constant("なし"), categoryView: Binding.constant(true))
            .environmentObject(ViewModel())
    }
}
