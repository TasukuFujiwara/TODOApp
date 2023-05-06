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
    @Binding var nowCategory: String
    @Binding var categoryView: Bool
    
    var body: some View {
        let textColor: Color = colorScheme == .light ? .black : .white
        NavigationStack {
            ZStack(alignment: .leading) {
                Color.blue
                VStack {
                    Button("全てのTODO") {
                        nowCategory = "なし"
                        categoryView = false
                    }
                    .padding()
                    ForEach(Array(viewModel.categoryList), id: \.self) { key in
                        
                        Button(key) {
                            nowCategory = key
                            categoryView = false
                        }
                        .padding()

                    }
                        
                }

            }
            .edgesIgnoringSafeArea(.all)
            .foregroundColor(textColor)
        }   // NavigationStack
    }   // body
}   // CategoryView

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(nowCategory: Binding.constant("なし"), categoryView: Binding.constant(true))
            .environmentObject(ViewModel())
    }
}
