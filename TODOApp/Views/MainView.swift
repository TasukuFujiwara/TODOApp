//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var createView: Bool = false
    @State private var hideButton: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todoItems.freeze()) { item in
                    //@State var todoItem: TODOItem = item
                    NavigationLink {
                        EditView(id: item.id, title: item.title)
                            .environmentObject(ViewModel())
                    } label: {
                        Text(item.title)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.deleteItem(viewModel.todoItems[index].id)
                    }
                }
            }
            .navigationTitle("TODOリスト")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createView.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .disabled(hideButton)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    MyEditButton(hideButton: $hideButton)
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
    @Binding var hideButton: Bool
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                    hideButton.toggle()
                } else {
                    editMode?.wrappedValue = .active
                    hideButton.toggle()
                }
            }
        }, label: {
            if let isEditing = editMode?.wrappedValue.isEditing {
                isEditing ? Text("終了") : Text("編集")
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
