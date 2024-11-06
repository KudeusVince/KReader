//
//  DeskReaderMaker.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//

import SwiftUI
import CoreBluetooth
import BLEReaderUtility

class DeskReader {
    
    private var properties:[BLEReaderProperties] = [.mode, .color, .brightness, .duration, .delay]
    
    private var readerSettings = ReaderSettings()
    
    private var dispatchGroup: DispatchGroup?
    
    var characteristicManager: CharacteristicManager
    
    init(peripheral: CBPeripheral) {
        self.characteristicManager = CharacteristicManager(peripheral: peripheral)
    }
    
    func readValues(_ completion: @escaping (ReaderSettings)->()) {
        dispatchGroup = DispatchGroup()
        for property in properties {
            dispatchGroup?.enter()
            switch property {
            case .mode:
                characteristicManager.readValue(.mode)
            case .color:
                characteristicManager.readValue(.color)
            case .brightness:
                characteristicManager.readValue(.brightness)
            case .duration:
                characteristicManager.readValue(.duration)
            case .delay:
                characteristicManager.readValue(.delay)
            default: return
            }
        }
        dispatchGroup?.notify(queue: .main) {
            self.dispatchGroup = nil
            completion(self.readerSettings)
        }
    }
    
    func received(_ bleReaderProperties:BLEReaderProperties, data:Data) {
        switch bleReaderProperties {
        case .mode:
            if let mode = BLEReaderMode(rawValue: Int(data.toInt8())) {
                readerSettings.mode = mode
            }
        case .color:
            if let hex = Color(value: data.toInt32()).toHex(), let color = Color(hex: hex) {
                readerSettings.color = color
            }
        case .brightness:
            readerSettings.brightness = CGFloat(data.toInt8())/MAX_BRIGHTNESS
        case .duration:
            readerSettings.duration = CGFloat(data.toInt8())
        case .delay:
            readerSettings.delay = CGFloat(data.toInt16())
        default: return
        }
        dispatchGroup?.leave()
    }
}
