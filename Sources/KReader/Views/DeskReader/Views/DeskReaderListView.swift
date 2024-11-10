//
//  SwiftUIView.swift
//  
//
//  Created by vince on 04/07/2024.
//

import SwiftUI
import BLEReaderUtility
import CoreBluetooth
import Combine

@Observable
class DeskReaderListModel: @unchecked Sendable {
    
    var peripheralPublisher = PassthroughSubject<CBPeripheral?,Never>()
    var errorPublisher = PassthroughSubject<Error,Never>()
    
    var readerBLEManager: ReaderBLEManager
    
    var cbPeripheral:CBPeripheral? {
        didSet {
            guard let cbPeripheral else { return }
            connect(to: cbPeripheral)
        }
    }
    
    init(services: [CBUUID]) {
        self.readerBLEManager = ReaderBLEManager(services: services)
        self.readerBLEManager.delegate = self
    }
    
    private func connect(to cbPeripheral:CBPeripheral) {
        readerBLEManager.connect(to: cbPeripheral)
    }
    
    func disconnect() {
        guard let cbPeripheral = cbPeripheral else { return }
        readerBLEManager.disconnect(from: cbPeripheral)
    }
}

extension DeskReaderListModel: ReaderBLEManagerDelegate {
    
    func didFailToConnect(_ error: any Error) {
        DispatchQueue.main.async {
            self.errorPublisher.send(error)
        }
    }
    
    func didConnect(_ peripheral: CBPeripheral) {
        DispatchQueue.main.async {
            self.peripheralPublisher.send(peripheral)
        }
    }
    
    func didDisconnect(from peripheral: CBPeripheral) {
        cbPeripheral = nil
        DispatchQueue.main.async {
            self.peripheralPublisher.send(nil)
        }
    }
}

extension CBPeripheral: @unchecked Sendable {}

public struct DeskReaderListView: View {
    
    private var deskReaderListModel: DeskReaderListModel
    
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
            BluetoothRowView(cbPeripheral, isConnecting: deskReaderListModel.cbPeripheral == cbPeripheral) {
                if let cbPeripheral = deskReaderListModel.readerBLEManager.getPeripheral(cbPeripheral.identifier) {
                    deskReaderListModel.cbPeripheral = cbPeripheral
                }
            }
        }
        .navigationTitle(title)
        .withErrorHandling()
        .onAppear {
            DispatchQueue.main.async {
                deskReaderListModel.readerBLEManager.start()
            }
        }
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
