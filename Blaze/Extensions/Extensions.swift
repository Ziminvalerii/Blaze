//
//  Extensions.swift
//  Snake
//
//  Created by 1 on 06.06.2022.
//

import SpriteKit

extension SKScene {
    
     func random(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        return CGFloat(Array(Int(min)...Int(max)).randomElement() ?? 0)
    }
}
