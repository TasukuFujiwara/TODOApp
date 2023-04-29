//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI
import Combine


enum viewMode {
    case main, edit
}

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var createView: Bool = false
    @State private var selectedItemID: Set<UUID> = []
    @State private var hideDeleteButton: Bool = false
    @State fileprivate var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                .navigationTitle("TODOリスト\(selectedItemID.count)")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    if isEditing {
                        ToolbarItem(placement:.navigationBarTrailing) {
                            Button("削除") {
                                for id in selectedItemID {
                                    if viewModel.itemList.contains(where: { $0.id == id }) {
                                        viewModel.deleteItem(id)
                                    }
                                }
                                //hideDeleteButton.toggle()
                            }
                            .disabled(hideDeleteButton)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        MyEditButton(isEditing: $isEditing)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CreateButton(createView: $createView)
                            .padding()
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
    @Binding var isEditing: Bool
    
    var body: some View {
        Button(action: {
            if editMode?.wrappedValue.isEditing == true {
                editMode?.wrappedValue = .inactive
                isEditing = false
            } else {
                editMode?.wrappedValue = .active
                isEditing = true
            }
        }, label: {
            if let _isEditing = editMode?.wrappedValue.isEditing {
                _isEditing ? Text("キャンセル") : Text("選択")
            }
        })
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
