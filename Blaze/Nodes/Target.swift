//
//  Target.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import SpriteKit

class Target: SnakeBody {
    
    var targetTexture: TextureType = .purple
    
    func configureNode() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = BodyType.target.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.snakeHead.rawValue
    }
}
