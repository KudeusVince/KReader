//
//  SwiftUIView.swift
//  
//
//  Created by vince on 04/07/2024.
//

import SwiftUI
import BLEReaderUtility
import CoreBluetooth

public struct DeskReaderListView: View {
    
    @State private var deskReaderListModel: DeskReaderListModel
    @State private var errorHandling = ErrorHandling()
    @State private var cbPeripheral: CBPeripheral?

    private var title: String
    
    private var services: [CBUUID]
    
    public init(title:String, services: [CBUUID]) {
        self.title = title
        self.services = services
        self.deskReaderListModel = DeskReaderListModel(services: services)
    }
    
    public var body: some View {
        List(deskReaderListModel.readerBLEManager.peripherals.filter { $0.type == BLEReaderType.deskReader } ) { cbPeripheral in
            BluetoothRowView(cbPeripheral, isConnecting: deskReaderListModel.isConnecting) {
                if let cbPeripheral = deskReaderListModel.readerBLEManager.getPeripheral(cbPeripheral.identifier) {
                    deskReaderListModel.cbPeripheral = cbPeripheral
                }
            }
        }
        .navigationTitle(title)
        .withErrorHandling()
        .sheet(item: $cbPeripheral) { cbPeripheral in
            DeskReaderContainerView(cbPeripheral, services: services)
                .environment(deskReaderListModel)
        }
        .onReceive(deskReaderListModel.peripheralPublisher) { cbPeripheral in
            self.cbPeripheral = cbPeripheral
        }
        .onReceive(deskReaderListModel.errorPublisher) { error in
            errorHandling.handle(error: error)
        }
    }
}
