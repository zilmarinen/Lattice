//
//  Kite.swift
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille

extension Triangle {
    
    public enum Kite: String,
                      CaseIterable,
                      Identifiable {
        
        case delta
        case epsilon
        case gamma
        case kappa
        case lambda
        case omega
        case phi
        case psi
        case sigma
        
        public var id: String { rawValue.capitalized }
        
        public var vertices: [Stencil.Vertex] {
            
            switch self {
                
            case .delta: [.v0, .v1, .v2]
            case .epsilon: [.v0, .v5, .center, .v7]
            case .gamma: [.v0, .v5, .v6, .v9, .v10, .v7]
            case .kappa: [.v0, .v5, .v7]
            case .lambda: [.v0, .v5, .v9, .v10, .v6, .v7]
            case .omega: [.v0, .v5, .v9, .v10, .v7]
            case .phi: [.v0, .v5, .v6, .v10, .v7]
            case .psi: [.v0, .v5, .v9, .v6, .v7]
            case .sigma: [.v0, .v5, .v9, .v6, .v10, .v7]
            }
        }
    }
}

extension Triangle.Kite {
    
    public enum Tile: String,
                      CaseIterable,
                      Identifiable {
        
        case descartes
        case euclid
        case euler
        case gauss
        case mobius
        case pascal
        case thales
        
        public var id: String { rawValue.capitalized }
        
        public var kites: [Triangle.Kite] {
            
            switch self {
                
            case .descartes: [.epsilon, .epsilon, .epsilon]
            case .euclid: [.lambda, .delta, .sigma]
            case .euler: [.psi, .delta, .omega]
            case .gauss: [.lambda, .psi, .psi]
            case .mobius: [.delta, .gamma, .sigma]
            case .pascal: [.phi, .gamma, .phi]
            case .thales: [.delta, .phi, .omega]
            }
        }
    }
}
