//
//  SelectedItems.swift
//  TODOApp
//
//  Created by 藤原輔 on 2023/04/29.
//

import Foundation

class SelectedItems: ObservableObject {
    @Published var selectedItemID: Set<UUID> = []
}
