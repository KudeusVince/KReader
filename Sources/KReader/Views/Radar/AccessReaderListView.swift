//
//  AccessReaderListView.swift
//  KReader
//
//  Created by vince on 07/11/2024.
//

import SwiftUI
import BLEReaderUtility
import CoreBluetooth

public struct AccessReaderListView: View {
    
    @State private var deskReaderListModel: DeskReaderListModel
    
    @State private var errorHandling = ErrorHandling()
    @State private var cbPeripheral: CBPeripheral?
    
    
    @State private var startAnimation = false
    @State private var finishAnimation = false
    @State private var pulse1 = false
    @State private var pulse2 = false
    @State private var foundPeripherals : [PulsePeripheral] = []

    private var title: String
    
    private var services: [CBUUID]
    
    public init(title:String, services: [CBUUID]) {
        self.title = title
        self.services = services
        self.deskReaderListModel = DeskReaderListModel(services: services)
    }
    
    public var body: some View {
        VStack{

            ZStack{
                
                Circle()
                    .stroke(Color.primary.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse1 ? 3.3 : 0)
                    .opacity(pulse1 ? 0 : 1)
                
                Circle()
                    .stroke(Color.primary.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse2 ? 3.3 : 0)
                    .opacity(pulse2 ? 0 : 1)
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 130, height: 130)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                
                Circle()
                    .stroke(Color.white,lineWidth: 1.4)
                    .frame(width: finishAnimation ? 70 : 30, height: finishAnimation ? 70 : 30)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .opacity(finishAnimation ? 1 : 0)
                    )
                
                ZStack{
                    
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.white,lineWidth: 1.4)
                    
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.white,lineWidth: 1.4)
                        .rotationEffect(.init(degrees: -180))
                }
                .frame(width: 70, height: 70)
                // rotating view...
                .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                
                // showing found peripherals..
                ForEach($foundPeripherals) { $pulsePeripheral in
                    PulsePeripheralView(pulsePeripheral) {
//                        if let peripheral = accessReaderManager.readerBLEManager.getPeripheral(pulsePeripheral.identifier) {
//                            sheetCoordinator.presentSheet(.accessPeripheral(peripheral))
//                        }
                    }
                }
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity)
        }
        .onAppear {
//            accessReaderManager.readerBLEManager.start()
            animateView()
            self.deskReaderListModel.readerBLEManager.start()
        }
        .onChange(of: deskReaderListModel.readerBLEManager.peripherals) { _, cbPeripherals in
            print("YEAH")
            print(cbPeripherals)
            handlePeripherals(cbPeripherals)
        }
    }
    
    func handlePeripherals(_ peripherals:[CBPeripheral]) {
        
        if peripherals.isEmpty {
            withAnimation {
                foundPeripherals.removeAll()
            }
            return
        }
        
        let filteredPeripherals = peripherals.filter { $0.type == BLEReaderType.accessReader }
        
        print(filteredPeripherals)
        
        for (index, pulsePeripheral) in foundPeripherals.enumerated() {
            if !peripherals.contains(where: { $0.identifier == pulsePeripheral.identifier }) {
                withAnimation {
                    foundPeripherals.remove(at: index)
                }
            }
        }
        
        for peripheral in filteredPeripherals {
            if !foundPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
                verifyAndAddPeople(peripheral)
            }
        }
        
    }
    
    func verifyAndAddPeople(_ cbPeripheral:CBPeripheral){
        if foundPeripherals.count < 5 {
            withAnimation{
                var pulsePeripheral = PulsePeripheral(deviceName: cbPeripheral.deviceName, identifier: cbPeripheral.identifier)
                pulsePeripheral.offset = firstFiveOffsets[foundPeripherals.count]
                foundPeripherals.append(pulsePeripheral)
            }
        }
    }
    
    func animateView() {
        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
            startAnimation.toggle()
        }
        
        withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
            pulse1.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
                pulse2.toggle()
            }
        }
    }
}

//List(deskReaderListModel.readerBLEManager.peripherals.filter { $0.type == BLEReaderType.deskReader } ) { cbPeripheral in
//    BluetoothRowView(cbPeripheral, isConnecting: deskReaderListModel.isConnecting) {
//        if let cbPeripheral = deskReaderListModel.readerBLEManager.getPeripheral(cbPeripheral.identifier) {
//            deskReaderListModel.cbPeripheral = cbPeripheral
//        }
//    }
//}
//.navigationTitle(title)
//.withErrorHandling()
//.sheet(item: $cbPeripheral) { cbPeripheral in
//    DeskReaderContainerView(cbPeripheral, services: services)
//        .environment(deskReaderListModel)
//}
//.onReceive(deskReaderListModel.peripheralPublisher) { cbPeripheral in
//    self.cbPeripheral = cbPeripheral
//}
//.onReceive(deskReaderListModel.errorPublisher) { error in
//    errorHandling.handle(error: error)
//}
