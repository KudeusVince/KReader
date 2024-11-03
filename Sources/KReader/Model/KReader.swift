//
//  Untitled.swift
//  KReader
//
//  Created by vince on 31/10/2024.
//

import SwiftUI
import FormBuilder

public struct KReader: Identifiable, Equatable, Hashable {
    
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var type: Int
    
    public init(id: String? = nil, name: String, type: Int) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.type = type
    }
}
