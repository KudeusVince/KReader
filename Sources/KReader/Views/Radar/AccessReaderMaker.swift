//
//  AccessReaderMaker.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//

import SwiftUI
import KModel
import BLEReaderUtility

public class AccessReaderMaker {
    
    private var properties:[BLEReaderProperties] = [.readerId, .deviceName, .authority]
    
    var dispatchGroup: DispatchGroup?
    
    var characteristicManager: CharacteristicManager?
    
    public init() {}
    
    public func setValue(for reader: KReader, authority:String, completion: @escaping ()->()) {
        guard let characteristicManager = characteristicManager else { return }
        dispatchGroup = DispatchGroup()
        for property in properties {
            dispatchGroup?.enter()
            switch property {
            case .readerId:
                characteristicManager.setValue(.readerId(reader.readerId))
            case .deviceName:
                characteristicManager.setValue(.deviceName(reader.name))
            case .authority:
                characteristicManager.setValue(.authority(authority))
            default: return
            }
        }
        dispatchGroup?.notify(queue: .main) {
            self.dispatchGroup = nil
            completion()
        }
    }
}
