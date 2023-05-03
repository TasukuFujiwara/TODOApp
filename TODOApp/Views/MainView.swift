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
    @State private var selectedItemID: Set<UUID> = []       // 選択したTODOアイテムを格納する
    @State fileprivate var isEditing: Bool = false          // アイテムを選択できる状態かどうか
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                                if selectedItemID.contains(item.id) {   // アイテムが選択されていたら
                                    Image(systemName: "checkmark")      // チェックマークをつける
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {         // アイテムをタップした時
                                withAnimation {
                                    if selectedItemID.contains(item.id) {       // アイテムが選択されていれば，チェックを外す
                                        selectedItemID.remove(item.id)
//                                        if viewModel.todoItems.count == 0 {
//                                            isEditing = false
//                                        }
                                    } else {        // アイテムが選択されていなければ，チェックをつける
                                        selectedItemID.insert(item.id)
                                    }
                                }
                            }
                        }

                    }
                }
                .navigationTitle("TODOリスト\(selectedItemID.count)")
                .navigationBarTitleDisplayMode(.large)
                // ツールバー
                .toolbar {
                    if isEditing {  // 選択可能状態
                        ToolbarItem(placement:.navigationBarTrailing) {
                            Button("削除") {  // アイテムが1つ以上選択されていれば，押せる状態に
                                for id in selectedItemID {      // 選択したアイテムを削除
                                    viewModel.deleteItem(id)
                                    selectedItemID.remove(id)
                                }
                                if viewModel.todoItems.count == 0 {     // TODOアイテムがなくなったら，選択可能状態を終了
                                    isEditing = false
                                }
                            }
                            .disabled(selectedItemID.isEmpty)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        // 選択可能状態なら，”キャンセル”，そうでなければ，”選択”
                        // TODOアイテムが1つ以上ある場合に押せる
                        Button(isEditing ? "キャンセル" : "選択") {
                            isEditing.toggle()
                        }
                        .disabled(viewModel.todoItems.isEmpty)
                    }
                }
                // 新規作成ボタン
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if !isEditing {     // 選択可能状態でないなら，表示
                            CreateButton(createView: $createView)
                                .padding()
                        }
                    }
                }
            }
        }
        // モーダル遷移で新規作成画面へ
        .sheet(isPresented: $createView) {
            CreateView()
                .environmentObject(ViewModel())
        }
    }
}

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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
