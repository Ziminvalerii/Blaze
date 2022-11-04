//
//  TextureType.swift
//  Snake
//
//  Created by 1 on 02.06.2022.
//

import UIKit
import SpriteKit

enum TextureType: Int, CaseIterable {
    case purple
    case blue
    case yellow
    case green
    case red
    
    var barrierTexture: SKTexture {
        switch self {
        case .purple:
            return SKTexture(imageNamed: "barrier-purple")
        case .blue:
            return SKTexture(imageNamed: "barrier-blue")
        case .yellow:
            return SKTexture(imageNamed: "barrier-yellow")
        case .green:
            return SKTexture(imageNamed: "barrier-green")
        case .red:
            return SKTexture(imageNamed: "barrier-red")
        }
    }
    
    var snakeTexture: SKTexture {
        switch self {
        case .purple:
            return SKTexture(imageNamed: "snake-purple")
        case .blue:
            return SKTexture(imageNamed: "snake-blue")
        case .yellow:
            return SKTexture(imageNamed: "snake-yellow")
        case .green:
            return SKTexture(imageNamed: "snake-green")
        case .red:
            return SKTexture(imageNamed: "snake-red")
        }
    }
    
    var color: UIColor {
        switch self {
        case .purple:
            return UIColor(red: 0.82, green: 0.21, blue: 0.82, alpha: 1.00)
        case .blue:
            return UIColor(red: 0.00, green: 0.64, blue: 0.82, alpha: 1.00)
        case .yellow:
            return UIColor(red: 0.83, green: 0.76, blue: 0.12, alpha: 1.00)
        case .green:
            return UIColor(red: 0.00, green: 0.81, blue: 0.10, alpha: 1.00)
        case .red:
            return UIColor(red: 0.93, green: 0.21, blue: 0.21, alpha: 1.00)
        }
    }
}
