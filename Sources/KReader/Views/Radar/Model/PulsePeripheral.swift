//
//  Untitled.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//

import SwiftUI
import BLEReaderUtility

let firstFiveOffsets: [CGSize] = [
    CGSize(width: 120, height: -120),
    CGSize(width: 120, height: 120),
    CGSize(width: -120, height: 120),
    CGSize(width: -120, height: -120)
]

//let firstFiveOffsets: [CGSize] = [
//    CGSize(width: 100, height: 100),
//    CGSize(width: -100, height: -100),
//    CGSize(width: -50, height: 130),
//    CGSize(width: 50, height: -130),
//    CGSize(width: 120, height: -50),
//]


struct PulsePeripheral: Identifiable, Hashable {
    var id = UUID().uuidString
    var deviceName: String
    var identifier: UUID
    var offset: CGSize = CGSize(width: 0, height: 0)
    
    init(deviceName: String, identifier: UUID) {
        let identiyName = deviceName.replacingOccurrences(of: BLEReaderType.accessReader.characteristic, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.deviceName = identiyName.isEmpty ? "Lecteur" : identiyName
        self.identifier = identifier
    }
}
