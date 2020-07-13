//
//  Grid.swift
//  Memorizable
//
//  Created by Samuel Pinheiro Junior on 08/07/20.
//  Copyright © 2020 Samuel Pinheiro Junior. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemForView>: View where Item: Identifiable, ItemForView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemForView
    
    init (_ item: [Item], viewForItem: @escaping (Item) -> ItemForView) {
        self.items = item
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size) )
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
        
    }
}
