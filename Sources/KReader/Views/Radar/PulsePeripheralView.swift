//
//  SwiftUIView.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//

import SwiftUI

struct PulsePeripheralView:View {
    
//    @ObservedResults(RLMReader.self) private var rlmReaders
    
    @State private var deviceName:String?
    private var pulsePeripheral:PulsePeripheral
    private var action: () -> ()
    
    init(_ pulsePeripheral:PulsePeripheral, action: @escaping ()->()) {
        self.pulsePeripheral = pulsePeripheral
        self.action = action
    }
    
    var body: some View {
        VStack {
            Image("box", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
//                            .shadow(color: Color.black.opacity(0.4), radius: 3, x: 3, y: 3)
            Text(deviceName ?? "Lecteur")
                .lineLimit(1)
                .font(.caption2)
        }
        
        .frame(width: 120, height: 100)
        .padding()
        .offset(pulsePeripheral.offset)
        .onTapGesture {
            action()
        }
        .onAppear {
//            $rlmReaders.filter = NSPredicate(format: "deviceName = %@", argumentArray: [pulsePeripheral.deviceName])
//            deviceName = rlmReaders.first?.name
        }
    }
}
