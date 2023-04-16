//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todoItems.freeze()) { item in
                    Text("\(item.title)")
                }
            }
            .navigationTitle("TODOリスト")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CreateView()
                            .environmentObject(ViewModel())
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
