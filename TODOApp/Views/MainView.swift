//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI

struct MainView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var viewModel: ViewModel
    @State private var createView: Bool = false
    @State private var selectedItemID: Set<UUID> = []
    @State fileprivate var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(selection: $selectedItemID) {
                    ForEach(viewModel.todoItems.freeze()) { item in
                        NavigationLink {
                            EditView(id: item.id, title: item.title, dueDate: item.dueDate, note: item.note)
                                .environmentObject(ViewModel())
                        } label: {
                            Text(item.title)
                        }
                    }
                }
                .navigationTitle("TODOリスト\(selectedItemID.count)")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    if isEditing {
                        ToolbarItem(placement:.navigationBarTrailing) {
                            Button("削除") {
                                for id in selectedItemID {
                                    viewModel.deleteItem(id)
                                }
                                selectedItemID = []
                                if viewModel.todoItems.count == 0 {
                                    editMode?.wrappedValue = .inactive
//                                    isEditing = false
                                }
                                isEditing.toggle()
                            }
                            .disabled(selectedItemID.isEmpty)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        MyEditButton(isEditing: $isEditing, selectedItemId: $selectedItemID)
                            .environmentObject(ViewModel())
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if !isEditing {
                            CreateButton(createView: $createView)
                                .padding()
                        }
                    }
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
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isEditing: Bool
    @Binding var selectedItemId: Set<UUID>
    
    var body: some View {
        Button(action: {
            if editMode?.wrappedValue.isEditing == true {
                editMode?.wrappedValue = .inactive
//                isEditing = false
            } else {
                editMode?.wrappedValue = .active
//                isEditing = true
            }
            isEditing.toggle()
            selectedItemId = []
        }, label: {
            isEditing ? Text("キャンセル") : Text("選択")
        })
        .disabled(viewModel.todoItems.isEmpty)
    }
}

struct CreateButton: View {
    @Binding var createView: Bool
    var body: some View {
        Button(action: {
            createView.toggle()
        }, label: {
            Image(systemName: "plus")
                .padding()
                .frame(width: 70, height: 70)
                .imageScale(.large)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
                .font(.title)
        })
        .padding(.top, 50.0)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
