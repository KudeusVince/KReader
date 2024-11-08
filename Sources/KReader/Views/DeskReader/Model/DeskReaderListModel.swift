//
//  CoreBluetoothManager.swift
//  UIEstablishment
//
//  Created by vince on 31/07/2024.
//
import SwiftUI
import CoreBluetooth
import BLEReaderUtility
import Combine

@Observable
class DeskReaderListModel {
    
    var peripheralPublisher = PassthroughSubject<CBPeripheral?,Never>()
    var errorPublisher = PassthroughSubject<Error,Never>()
    
    var isConnecting:Bool = false
    
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
//        self.readerBLEManager.start()
    }
    
    private func connect(to cbPeripheral:CBPeripheral) {
        isConnecting = true
        readerBLEManager.connect(to: cbPeripheral)
    }
    
    func disconnect() {
        guard let cbPeripheral = cbPeripheral else { return }
        isConnecting = false
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
        DispatchQueue.main.async {
            self.peripheralPublisher.send(nil)
        }
    }
}
