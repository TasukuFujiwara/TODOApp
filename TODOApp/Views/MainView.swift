//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI


enum viewMode {
    case main, edit
}

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var createView: Bool = false
    @State private var selectedItemID: Set<UUID> = []
    @State private var nowViewMode: viewMode = .main
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedItemID) {
                ForEach(viewModel.todoItems.freeze()) { item in
                    NavigationLink {
                        EditView(id: item.id, title: item.title)
                            .environmentObject(ViewModel())
                    } label: {
                        Text(item.title)
                    }
                }
            }
            .navigationTitle("TODOリスト")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        switch nowViewMode {
                        case .main:
                            createView.toggle()
                        case .edit:
                            for id in selectedItemID {
                                viewModel.deleteItem(id)
                            }
                        }
                    }, label: {
                        switch nowViewMode {
                        case .main:
                            Image(systemName: "plus")
                        case .edit:
                            Text("削除")
                        }
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    MyEditButton(nowViewMode: $nowViewMode)
                }
            }
        }
        .sheet(isPresented: $createView) {
            CreateView()
                .environmentObject(ViewModel())
        }
    }
}

struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    @Binding var nowViewMode: viewMode
    
    var body: some View {
        Button(action: {
            if editMode?.wrappedValue.isEditing == true {
                editMode?.wrappedValue = .inactive
                nowViewMode = .main
            } else {
                editMode?.wrappedValue = .active
                nowViewMode = .edit
            }
        }, label: {
            if let isEditing = editMode?.wrappedValue.isEditing {
                isEditing ? Text("キャンセル") : Text("選択")
            }
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
