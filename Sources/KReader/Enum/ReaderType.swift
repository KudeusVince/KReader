//
//  ReaderType.swift
//  KGate
//
//  Created by vince on 31/10/2024.
//

import Foundation

public enum ReaderType:Int, Identifiable, CaseIterable, CustomStringConvertible {
    
    public var id:Int {
        return self.rawValue
    }
    
    case none
    case enter
    case exit
    case both
    
    public var description: String {
        switch self {
        case .none: return "Inactif/Fermé"
        case .enter: return "Entrée"
        case .exit: return "Sortie"
        case .both: return "Entrée/Sortie"
        }
    }
}
