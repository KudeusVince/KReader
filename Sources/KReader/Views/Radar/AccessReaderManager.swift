//
//  CBReaderManager.swift
//  KReader
//
//  Created by vince on 01/08/2024.
//
//import SwiftUI
//import CoreBluetooth
//import BLEReaderUtility
//import Combine
//
//@MainActor
//@Observable
//public class AccessReaderManager {
//
//    public var errorPublisher = PassthroughSubject<Error,Never>()
//    public var readerIdPublisher = PassthroughSubject<Int,Never>()
//
//    private var readerPeripheralService = ReaderPeripheralService()
//    private var characteristicManager = CharacteristicManager()
//    
//    public var accessReaderMaker = AccessReaderMaker()
//    public var readerBLEManager: ReaderBLEManager
//    
//    private var blePasswordType:BLEPasswordType = .establishmentCustomPassword
//    
//    public var password:String?
//    
//    public init() {
//        self.readerBLEManager = ReaderBLEManager(services: [Services.service_device_settings.uuid,
//                                                            Services.service_kreader.uuid])
//        self.readerPeripheralService.delegate = self
//        self.readerBLEManager.delegate = self
//    }
//    
//    public func disconnect(peripheral: CBPeripheral) {
//        readerBLEManager.disconnect(from: peripheral)
//    }
//
//    public func characteristicReader(_ bleReaderProperties:BLEReaderProperties) {
//        characteristicManager.readValue(bleReaderProperties)
//    }
//    
//    public func characteristicSetter(_ characteristicTypeSetter:CharacteristicTypeSetter) {
//        characteristicManager.setValue(characteristicTypeSetter)
//    }
//    
//    private func start() {
//        accessReaderMaker.characteristicManager = characteristicManager
//        characteristicReader(.readerId)
//    }
//}
//
//extension AccessReaderManager: ReaderBLEManagerDelegate {
//    
//    public func didDisconnect(from peripheral: CBPeripheral) {
//        DispatchQueue.main.async {
//            self.readerBLEManager.start()
//        }
//    }
//    
//    
//    public func didFailToConnect(_ error: any Error) {
//        DispatchQueue.main.async {
//            self.errorPublisher.send(error)
//        }
//    }
//    
//    public func didConnect(_ peripheral: CBPeripheral) {
//        characteristicManager.peripheral = peripheral
//        peripheral.delegate = readerPeripheralService
//        peripheral.discoverServices(readerBLEManager.services)
//    }
//}
//
//extension AccessReaderManager:ServiceBTReaderDelegate {
//    
//    public func serviceCharacteristicsUpdated(_ serviceCharacteristics: BLEReaderUtility.ServiceCharacteristics) {
//        characteristicManager.serviceCharacteristics  = serviceCharacteristics
//        if let password {
//            characteristicSetter(.password(password))
//        }
//    }
//    
//    public func didUpdateValueFor(_ characteristic: CBCharacteristic) {
//        guard let data = characteristic.value else { return }
//        if let serviceDeviceSettings = ServiceDeviceSettings(rawValue: characteristic.uuid.uuidString) {
//            switch serviceDeviceSettings {
//            case .status:
//                if let data = characteristic.value,
//                   let bleReaderStatus = BLEReaderStatus(rawValue: Int(data.toInt8())) {
//                    switch bleReaderStatus {
//                    case .configurationPasswordError:
//                        switch blePasswordType {
//                        case .defaultConfigPassword:
//                            DispatchQueue.main.async { [self] in
//                                errorPublisher.send(BLEReaderError.configurationPasswordError)
//                            }
//                        case .establishmentCustomPassword:
//                            blePasswordType = .defaultConfigPassword
//                            characteristicSetter(.password(CFGPASSWORD))
//                        }
//                    case .userPasswordOk:
//                        
//                        if blePasswordType == .defaultConfigPassword {
//                            if let password {
//                                characteristicSetter(.newPassword(password))
//                            }
//                            return
//                        }
//                        start()
//                        
//                    case .configurationPasswordChange:
//                        start()
//                    case .commandNotAllowed:
//                        DispatchQueue.main.async { [self] in
//                            errorPublisher.send(BLEReaderError.commandNotAllowed)
//                        }
//                    case .invalidValue:
//                        DispatchQueue.main.async { [self] in
//                            errorPublisher.send(BLEReaderError.commandNotAllowed)
//                        }
//                    case .adminPasswordError:
//                        DispatchQueue.main.async { [self] in
//                            errorPublisher.send(BLEReaderError.adminPasswordError)
//                        }
//                    default: break
//                    }
//                }
//                
//            case .readerId:
//                
//                if let dispatchGroup = accessReaderMaker.dispatchGroup {
//                    accessReaderMaker.dispatchGroup?.leave()
//                    return
//                }
//                
//                guard let data = characteristic.value else { return }
//                let readerId = Int(data.toInt8())
//                DispatchQueue.main.async { [self] in
//                    readerIdPublisher.send(readerId)
//                }
//                
//            case .deviceName, .authority:
//                accessReaderMaker.dispatchGroup?.leave()
//                
//            default: break
//            }
//        }
//    }
//    
//    public func error(_ error: any Error) {
//        DispatchQueue.main.async {
//            self.errorPublisher.send(error)
//        }
//    }
//}
