//
//  CategoryView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/05/04.
//

import SwiftUI


struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        var textColor: Color = colorScheme == .light ? .black : .white
        NavigationStack {
            ZStack(alignment: .leading) {
                Color.blue
                Text("Hello, World!")
                    .padding()
            }
            .edgesIgnoringSafeArea(.all)
            .foregroundColor(textColor)
            
            
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
