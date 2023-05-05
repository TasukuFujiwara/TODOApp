//
//  ContentView.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/14.
//

import SwiftUI


// メイン画面
struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel             // ビューモデル
    @State private var createView: Bool = false             // 新規作成画面に移るかどうか
    @State private var categoryView: Bool = false
    @State private var selectedItemID: Set<UUID> = []       // 選択したTODOアイテムを格納する
    @State fileprivate var isEditing: Bool = false          // アイテムを選択できる状態かどうか
    
    var body: some View {
        GeometryReader { geometry in
            let xOffset = geometry.size.width * 0.65
            NavigationStack {
                ZStack {
                    CategoryView()
                        //.frame(width: xOffset)
                        //.animation(.easeInOut(duration: 0.5), value: categoryView)
                    
                    List {
                        ForEach(viewModel.todoItems.freeze()) { item in
                            if !isEditing {     // アイテム選択可能状態でない時
                                NavigationLink {
                                    EditView(id: item.id, title: item.title, dueDate: item.dueDate, note: item.note)        // 詳細・編集画面へ遷移
                                        .environmentObject(ViewModel())
                                } label: {
                                    Text(item.title)      // ラベルとして，タイトルのみ表示しておく
                                }
                            } else {            // アイテム選択可能状態である時
                                HStack {
                                    Text(item.title)
                                    Spacer()
                                    ZStack {
                                        if selectedItemID.contains(item.id) {   // アイテムが選択されていたら
                                            // チェックマークをつける
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(Color.blue)
                                                .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                                        }
                                        Image(systemName: "circle")
                                            .foregroundColor(Color.gray)
                                            .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                                    }

                                }
                                .contentShape(Rectangle())
                                .onTapGesture {         // アイテムをタップした時
                                    withAnimation {
                                        if selectedItemID.contains(item.id) {       // アイテムが選択されていれば，チェックを外す
                                            selectedItemID.remove(item.id)
                                        } else {        // アイテムが選択されていなければ，チェックをつける
                                            selectedItemID.insert(item.id)
                                        }
                                    }
                                }
                            }
                        }   // ForEach
                    }   // List
                    .onTapGesture {
                        if categoryView {
                            categoryView = false
                        }
                    }
                    .navigationTitle(categoryView ? "フォルダ" : "TODOリスト")
                    .navigationBarTitleDisplayMode(.large)
                    .offset(x: (categoryView && !isEditing) ? xOffset : 0)
                    .animation(.easeInOut(duration: 0.3), value: (categoryView && !isEditing))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offset = value.translation.width
                                if offset > 0, !isEditing {
                                    categoryView = true
                                }
                            }
                            .onEnded { value in
                                let offset = value.translation.width
                                if offset < xOffset / 2, !isEditing {
                                    categoryView = false
                                }
                            }
                    )
                    // ツールバー
                    .toolbar {
                        ToolbarItem(placement:.navigationBarTrailing) {
                            Button(isEditing ? "削除" : "選択") {  // アイテムが1つ以上選択されていれば，押せる状態に
                                if isEditing {
                                    for id in selectedItemID {      // 選択したアイテムを削除
                                        viewModel.deleteItem(id)
                                        selectedItemID.remove(id)
                                    }
                                    if viewModel.todoItems.isEmpty {     // TODOアイテムがなくなったら，選択可能状態を終了
                                        isEditing = false
                                    }
                                } else {
                                    isEditing.toggle()
                                }
                            }
                            .disabled((isEditing && selectedItemID.isEmpty) || viewModel.todoItems.isEmpty)
                        }
                        if isEditing {
                            ToolbarItem(placement: .navigationBarLeading) {
                                // 選択可能状態なら，”キャンセル”，そうでなければ，”選択”
                                // TODOアイテムが1つ以上ある場合に押せる
                                Button("キャンセル") {
                                    selectedItemID = []
                                    isEditing.toggle()
                                }
                                .disabled(viewModel.todoItems.isEmpty)
                            }
                        }
                    }   // .toolbar
                    
                    // 新規作成ボタン
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if !isEditing {     // 選択可能状態でないなら，表示
                                VStack {
                                    CreateButton(createView: $createView)
                                        .padding()
                                    CategoryButton(categoryView: $categoryView)
                                }
                            }
                        }
                    }
                }   // ZStack
            }   // NavigationStack
            // モーダル遷移で新規作成画面へ
            .sheet(isPresented: $createView) {
                CreateView()
                    .environmentObject(ViewModel())
            }
        }   // GeometryReader
    }   // body
}   // MainView

// 新規作成ボタン
struct CreateButton: View {
    @Binding var createView: Bool
    var body: some View {
        Button(action: {
            createView.toggle()
        }, label: {
            // 見た目
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

// カテゴリーボタン
struct CategoryButton: View {
    @Binding var categoryView: Bool
    var body: some View {
        Button(action: {
            categoryView.toggle()
        }, label: {
            Image(systemName: "folder.fill")
                .padding()
                .frame(width: 70, height: 70)
                .imageScale(.large)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
                .font(.title)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
