//
//  SaleItemListView.swift
//  ShoB
//
//  Created by Dara Beng on 6/18/19.
//  Copyright © 2019 Dara Beng. All rights reserved.
//

import SwiftUI

struct SaleItemListView: View {
    
    @State var items = sampleItems()
    
    /// Action to perform when an item is selected.
    ///
    /// Set this block to do custom action.
    /// Otherwise, The view will show the item details.
    var onItemSelected: ((SaleItem, SaleItemListView) -> Void)?
    
    
    var body: some View {
        List(items) { item in
            if self.onItemSelected == nil { // default behavior, show item details
                NavigationLink(item.name, destination: Text(item.name))
            } else { // custom behavior
                Button(item.name, action: { self.onItemSelected?(item, self) })
            }
        }
//        .modifier(CommitNavigationItems(
//            onCancel: nil,
//            onCommit: {},
//            commitTitle: "Update",
//            modalCommitTitle: "Add"
//        ))
    }
}

#if DEBUG
struct SaleItemList_Previews : PreviewProvider {
    static var previews: some View {
        SaleItemListView()
    }
}
#endif


func sampleItems() -> [SaleItem] {
    let context = CoreDataStack.current.mainContext
    var items = [SaleItem]()
    for i in 1...20 {
        let item = (SaleItem(context: context))
        item.name = "Item #\(i)"
        item.price = Cent(i * 10)
        items.append(item)
    }
    return items
}