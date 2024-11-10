//
//  EditReaderView.swift
//  KReader
//
//  Created by vince on 06/11/2024.
//

import SwiftUI
import BLEReaderUtility

struct EditReaderView: View {

    @Environment(DeskReaderListModel.self) private var deskReaderListModel
    @Environment(DeskReaderManager.self) private var deskReaderManager
    
    @State private var readerSettings:ReaderSettings
    
    init(_ readerSettings:ReaderSettings) {
        self.readerSettings = readerSettings
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section(BLEReaderProperties.mode.title) {
                    ReaderModeView(mode: $readerSettings.mode)
                        .onChange(of: readerSettings.mode) { _, mode in
                            deskReaderManager.characteristicSetter(.mode(mode))
                        }
                }
                .expandSection()
                
                Section(BLEReaderProperties.color.title) {
                    ReaderColorView(color: $readerSettings.color)
                        .onChange(of: readerSettings.color) { _, color in
                            guard let hex = color.toHex(), let value = Int(hex, radix: 16) else { return }
                            deskReaderManager.characteristicSetter(.color(value))
                        }
                }
                .expandSection()
                
                Section(BLEReaderProperties.brightness.title) {
                    CompactSliderView(value: $readerSettings.brightness, image:"lightbulb.max.fill", text: "%") //MAX_BRIGHTNESS
                        .onChange(of: readerSettings.brightness) { _, brightness in
                            deskReaderManager.characteristicSetter(.brightness(Int((brightness*MAX_BRIGHTNESS)/100)))
                        }
                }
                .expandSection()
                
                Section(BLEReaderProperties.duration.title) {
                    CompactSliderView(value: $readerSettings.duration, image:"timer", text: "sec", max: MAX_GLOWING_DURATION) //MAX_GLOWING_DURATION
                        .onChange(of: readerSettings.duration) { _, duration in
                            deskReaderManager.characteristicSetter(.duration(Int(duration)))
                        }
                }
                .expandSection()
                
                Section(BLEReaderProperties.delay.title) {
                    CompactSliderView(value: $readerSettings.delay, image:"shuffle", text: "sec", max: MAX_CYCLE_DELAY)//MAX_CYCLE_DELAY
                        .onChange(of: readerSettings.delay) { _, delay in
                            deskReaderManager.characteristicSetter(.delay(Int(delay)))
                        }
                }
                .expandSection()
            }
            .navigationTitle(BLEReaderUI.parameters.title)
            .navigationBarItems(leading: CloseBtn())
        }
    }
    
    @ViewBuilder
    private func CloseBtn() -> some View {
        Button("Valider") {
            deskReaderListModel.disconnect()
        }
    }
}
