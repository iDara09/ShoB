//
//  OrderListView.swift
//  ShoB
//
//  Created by Dara Beng on 6/14/19.
//  Copyright © 2019 Dara Beng. All rights reserved.
//

import SwiftUI
import CoreData

struct OrderListView: View {
    
    @EnvironmentObject var dataSource: FetchedDataSource<Order>

    @State private var currentSegment = Segment.today
    
    @State private var segments = [Segment.today, .tomorrow, .past7Days]
    
    /// A flag used to present or dismiss `placeOrderForm`.
    @State private var showPlaceOrderForm = false
    
    
    var body: some View {
        List {
            // MARK: Segment Control
            SegmentedControl(selection: $currentSegment) {
                ForEach(segments, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            
            // MARK: Order Rows
            ForEach(dataSource.fetchController.fetchedObjects ?? []) { order in
                OrderRow(sourceOrder: order, dataSource: self.dataSource.cud, onUpdated: nil)
            }
        }
        .navigationBarItems(trailing: placeNewOrderNavItem)
        .sheet(
            isPresented: $showPlaceOrderForm,
            onDismiss: dismissPlaceOrderForm,
            content: { self.placeOrderForm }
        )
    }
    
    
    var placeNewOrderNavItem: some View {
        Button(action: {
            self.dataSource.cud.discardNewObject()
            self.dataSource.cud.prepareNewObject()
            self.dataSource.cud.willChange.send()
            self.showPlaceOrderForm = true
        }, label: {
            Image(systemName: "plus").imageScale(.large)
        })
        .accentColor(.accentColor)
    }
    
    /// Construct an order form.
    /// - Parameter order: The order to view or pass `nil` get a create mode form.
    var placeOrderForm: some View {
        NavigationView {
            CreateOrderForm(
                cudDataSource: self.dataSource.cud,
                onPlacedOrder: dismissPlaceOrderForm,
                onCancelled: dismissPlaceOrderForm
            )
        }
    }
    
    
    func dismissPlaceOrderForm() {
        self.dataSource.cud.discardCreateContext()
        self.showPlaceOrderForm = false
    }
}


extension OrderListView {
    
    enum Segment: String {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case past7Days = "Past 7 Days"
        case all = "All"
    }
}


#if DEBUG
struct OrderList_Previews : PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
#endif
