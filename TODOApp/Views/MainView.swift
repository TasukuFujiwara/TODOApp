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
    @State private var selectedItemID: Set<UUID> = []
    @State fileprivate var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.todoItems.freeze()) { item in
                        if !isEditing {
                            NavigationLink {
                                EditView(id: item.id, title: item.title, dueDate: item.dueDate, note: item.note)
                                    .environmentObject(ViewModel())
                            } label: {
                                Text(item.title)
                            }
                        } else {
                            HStack {
                                Text(item.title)
                                Spacer()
                                if selectedItemID.contains(item.id) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    if selectedItemID.contains(item.id) {
                                        selectedItemID.remove(item.id)
                                        if selectedItemID.count == 0 {
                                            isEditing = false
                                        }
                                    } else {
                                        selectedItemID.insert(item.id)
                                    }
                                }
                            }
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
                                    isEditing = false
                                }
                            }
                            .disabled(selectedItemID.isEmpty)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(isEditing ? "キャンセル" : "選択") {
                            isEditing.toggle()
                        }
                        .disabled(viewModel.todoItems.isEmpty)
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
