//
//  PeripheralEditView.swift
//  UIEstablishment
//
//  Created by vince on 31/07/2024.
//
import SwiftUI
import CoreBluetooth
import BLEReaderUtility
import Combine

@MainActor
@Observable
class DeskReaderManager {
    
    public var errorPublisher = PassthroughSubject<Error,Never>()
    public var readerSettings: ReaderSettings?
    
    private var readerPeripheralService = ReaderPeripheralService()
    private var deskReader: DeskReader
    
    private var blePasswordType:BLEPasswordType = .establishmentCustomPassword
    private var password: String
    
    init(password: String, peripheral: CBPeripheral, services:[CBUUID]) {
        self.password = password
        self.deskReader = DeskReader(peripheral: peripheral)
        self.readerPeripheralService.delegate = self
        peripheral.delegate = readerPeripheralService
        peripheral.discoverServices(services)
    }
    
    private func start() {
        deskReader.readValues { readerSettings in
            self.readerSettings = readerSettings
        }
    }
    
    public func characteristicReader(_ bleReaderProperties:BLEReaderProperties) {
        deskReader.characteristicManager.readValue(bleReaderProperties)
    }
    
    public func characteristicSetter(_ characteristicTypeSetter:CharacteristicTypeSetter) {
        deskReader.characteristicManager.setValue(characteristicTypeSetter)
    }
}

extension DeskReaderManager: ServiceBTReaderDelegate {
    
    public func serviceCharacteristicsUpdated(_ serviceCharacteristics: BLEReaderUtility.ServiceCharacteristics) {
        deskReader.characteristicManager.serviceCharacteristics  = serviceCharacteristics
        characteristicSetter(.password(password))
    }
    
    public func didUpdateValueFor(_ characteristic: CBCharacteristic) {
        guard let data = characteristic.value else { return }
        if let serviceDeviceSettings = ServiceDeviceSettings(rawValue: characteristic.uuid.uuidString) {
            switch serviceDeviceSettings {
            case .status:
                if let data = characteristic.value,
                   let bleReaderStatus = BLEReaderStatus(rawValue: Int(data.toInt8())) {
                    switch bleReaderStatus {
                    case .configurationPasswordError:
                        switch blePasswordType {
                        case .defaultConfigPassword:
                            DispatchQueue.main.async { [self] in
                                errorPublisher.send(BLEReaderError.configurationPasswordError)
                            }
                        case .establishmentCustomPassword:
                            blePasswordType = .defaultConfigPassword
                            characteristicSetter(.password(CFGPASSWORD))
                        }
                    case .userPasswordOk:
                        
                        if blePasswordType == .defaultConfigPassword {
                            characteristicSetter(.newPassword(password))
                            return
                        }
                        start()
                        
                    case .configurationPasswordChange:
                        start()
                    case .commandNotAllowed:
                        DispatchQueue.main.async { [self] in
                            errorPublisher.send(BLEReaderError.commandNotAllowed)
                        }
                    case .invalidValue:
                        DispatchQueue.main.async { [self] in
                            errorPublisher.send(BLEReaderError.commandNotAllowed)
                        }
                    case .adminPasswordError:
                        DispatchQueue.main.async { [self] in
                            errorPublisher.send(BLEReaderError.adminPasswordError)
                        }
                    default: break
                    }
                }
            case .color:
                deskReader.received(.color, data: data)
            case .neoPxlCycleDelay:
                deskReader.received(.delay, data: data)
            case .neoPxlMaxBright:
                deskReader.received(.brightness, data: data)
            case .neoPxlGlowDuration:
                deskReader.received(.duration, data: data)
            case .neoPxlOnOffGlow:
                deskReader.received(.mode, data: data)
            default: break
            }
        }
    }
    
    public func error(_ error: any Error) {
        DispatchQueue.main.async {
            self.errorPublisher.send(error)
        }
    }
}