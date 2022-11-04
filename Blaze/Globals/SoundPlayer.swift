//
//  SoundPlayer.swift
//  Snake
//
//  Created by 1 on 06.06.2022.
//

import SpriteKit

class SoundPlayer {
    
    private var scene: SKScene!
    private var contactSound: SKAction!
    private var failContactSound: SKAction!
    private var targetSound: SKAction!
    private var winSound: SKAction!
    private var loseSound: SKAction!
    
    init(scene: SKScene) {
        self.scene = scene
        contactSound = SKAction.playSoundFileNamed("contact.wav", waitForCompletion: false)
        failContactSound = SKAction.playSoundFileNamed("fail-contact.wav", waitForCompletion: false)
        targetSound = SKAction.playSoundFileNamed("target.wav", waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed("winner.wav", waitForCompletion: false)
        loseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
    }
    
    func playLose() {
        guard !Application.shared.isMuteSound else { return }
        playSoundEffect(sound: loseSound)
    }
    
    func playWin() {
        guard !Application.shared.isMuteSound else { return }
        playSoundEffect(sound: winSound)
    }
    
    func playContact() {
        guard !Application.shared.isMuteSound else { return }
        playSoundEffect(sound: contactSound)
    }
    
    func playFailContact() {
        guard !Application.shared.isMuteSound else { return }
        playSoundEffect(sound: failContactSound, volume: 0.01)
    }
    
    func playTarget() {
        guard !Application.shared.isMuteSound else { return }
        playSoundEffect(sound: targetSound)
    }
    
    private func playSoundEffect(sound: SKAction, volume: Float = 0.03) {
        let changeVolumeAction = SKAction.changeVolume(to: volume, duration: 3)
        let effectAudioGroup = SKAction.group([sound, changeVolumeAction])
        scene.run(effectAudioGroup)
    }
}

