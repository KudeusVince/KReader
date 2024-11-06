//
//  AccessReaderRadarView.swift
//  KudeusKit
//
//  Created by vince on 06/11/2024.
//
//
//import SwiftUI
//import BLEReaderUtility
//import CoreBluetooth
//
//public struct AccessReaderRadarView: View {
//    
////    @Environment(SheetCoordinator<SheetType>.self) private var sheetCoordinator
//    @Environment(AccessReaderManager.self) private var accessReaderManager
//    
//    @State private var startAnimation = false
//    @State private var finishAnimation = false
//    @State private var pulse1 = false
//    @State private var pulse2 = false
//    @State private var foundPeripherals : [PulsePeripheral] = []
//    
//    public var body: some View {
//        
//        VStack{
//
//            ZStack{
//                
//                Circle()
//                    .stroke(Color.primary.opacity(0.6))
//                    .frame(width: 130, height: 130)
//                    .scaleEffect(pulse1 ? 3.3 : 0)
//                    .opacity(pulse1 ? 0 : 1)
//                
//                Circle()
//                    .stroke(Color.primary.opacity(0.6))
//                    .frame(width: 130, height: 130)
//                    .scaleEffect(pulse2 ? 3.3 : 0)
//                    .opacity(pulse2 ? 0 : 1)
//                
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 130, height: 130)
//                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
//                
//                Circle()
//                    .stroke(Color.white,lineWidth: 1.4)
//                    .frame(width: finishAnimation ? 70 : 30, height: finishAnimation ? 70 : 30)
//                    .overlay(
//                        Image(systemName: "checkmark")
//                            .font(.largeTitle)
//                            .foregroundColor(.green)
//                            .opacity(finishAnimation ? 1 : 0)
//                    )
//                
//                ZStack{
//                    
//                    Circle()
//                        .trim(from: 0, to: 0.4)
//                        .stroke(Color.white,lineWidth: 1.4)
//                    
//                    Circle()
//                        .trim(from: 0, to: 0.4)
//                        .stroke(Color.white,lineWidth: 1.4)
//                        .rotationEffect(.init(degrees: -180))
//                }
//                .frame(width: 70, height: 70)
//                // rotating view...
//                .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
//                
//                // showing found peripherals..
//                ForEach($foundPeripherals) { $pulsePeripheral in
//                    PulsePeripheralView(pulsePeripheral) {
////                        if let peripheral = accessReaderManager.readerBLEManager.getPeripheral(pulsePeripheral.identifier) {
////                            sheetCoordinator.presentSheet(.accessPeripheral(peripheral))
////                        }
//                    }
//                }
//            }
//            .frame(maxWidth:.infinity, maxHeight: .infinity)
//        }
//        .overlay(alignment: .top) {
//            Text("Scanner la carte de paramètrage\n sur un lecteur pour l'afficher.")
//                .foregroundStyle(.tertiary)
//                .multilineTextAlignment(.center)
//                .padding()
//                .padding(.top, 20)
//        }
//        .onAppear {
//            accessReaderManager.readerBLEManager.start()
//            animateView()
//        }
////        .onChange(of: accessReaderManager.readerBLEManager.peripheralAdvertismentDatas) { _, peripheralAdvertismentDatas in
////            handlePeripherals(peripheralAdvertismentDatas)
////        }
//    }
//
//    func handlePeripherals(_ peripherals:[CBPeripheral]) {
//        
//        if peripherals.isEmpty {
//            withAnimation {
//                foundPeripherals.removeAll()
//            }
//            return
//        }
//        
//        let filteredPeripherals = peripherals.filter { $0.type == BLEReaderType.accessReader }
//        
//        for (index, pulsePeripheral) in foundPeripherals.enumerated() {
//            if !peripherals.contains(where: { $0.identifier == pulsePeripheral.identifier }) {
//                withAnimation {
//                    foundPeripherals.remove(at: index)
//                }
//            }
//        }
//        
//        for peripheral in filteredPeripherals {
//            if !foundPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
//                verifyAndAddPeople(peripheral)
//            }
//        }
//        
//    }
//    
//    func verifyAndAddPeople(_ cbPeripheral:CBPeripheral){
//        if foundPeripherals.count < 5 {
//            withAnimation{
//                var pulsePeripheral = PulsePeripheral(deviceName: cbPeripheral.deviceName, identifier: cbPeripheral.identifier)
//                pulsePeripheral.offset = firstFiveOffsets[foundPeripherals.count]
//                foundPeripherals.append(pulsePeripheral)
//            }
//        }
//    }
//    
//    func animateView() {
//        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
//            startAnimation.toggle()
//        }
//        
//        withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
//            pulse1.toggle()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
//                pulse2.toggle()
//            }
//        }
//    }
//}
