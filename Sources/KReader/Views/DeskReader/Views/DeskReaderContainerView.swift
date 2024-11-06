//
//  DeskReaderContainerView.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//
import SwiftUI
import CoreBluetooth
import BLEReaderUtility

struct DeskReaderContainerView:View {
    
    @Environment(DeskReaderListModel.self) private var deskReaderListModel
    
    @State private var errorHandling = ErrorHandling()
    @State private var deskReaderManager: DeskReaderManager
    
    init(_ cbPeripheral:CBPeripheral, services:[CBUUID]) {
        self.deskReaderManager = DeskReaderManager(password: "PASSWORD", peripheral: cbPeripheral, services: services)
    }
    
    var body: some View {
        Content()
            .withErrorHandling()
            .interactiveDismissDisabled()
            .onReceive(deskReaderManager.errorPublisher) { error in
                errorHandling.handle(error: error) {
                    deskReaderListModel.disconnect()
                }
            }
    }
    
    @ViewBuilder
    private func Content() -> some View {
        if let readerSettings = deskReaderManager.readerSettings {
            EditReaderView(readerSettings)
                .environment(deskReaderManager)
        } else {
            VStack {
                ProgressView()
                Text(BLEReaderUI.connexion.title)
            }
        }
    }
}
