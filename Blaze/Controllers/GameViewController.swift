//
//  GameViewController.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController, ControllerDelegate {
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var centerXGuideConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var guideImageView: UIImageView! {
        didSet {
            guideImageView.isHidden = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: CGSize(width: 1125, height: 2436))
            scene.controllerDelegate = self
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
        AudioPlayer.shared.setupMusic()
        AudioPlayer.shared.playMusic()
        AudioPlayer.shared.changeVolume(volume: 0.8)
    }
    
    func soundButton(isShow: Bool) {
        soundButton.isHidden = !isShow
        privacyButton.isHidden = !isShow
    }
    
    func showGuide(block: @escaping () -> ()) {
        guideImageView.isHidden = false
        centerXGuideConstraint.constant = -100
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.centerXGuideConstraint.constant = 100
            UIView.animate(withDuration: 2) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.guideImageView.isHidden = true
                block()
            }
        }
    }
    
    @IBAction func soundButton(_ sender: Any) {
        if Application.shared.isMuteSound {
            soundButton.setImage(UIImage(named: "unmute"), for: .normal)
            AudioPlayer.shared.playMusic()
        } else {
            soundButton.setImage(UIImage(named: "mute"), for: .normal)
            AudioPlayer.shared.stopMusic()
        }
        Application.shared.isMuteSound.toggle()
    }
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://docs.google.com/document/d/1TRwCbnRK-7OKf4QPP8i9xCazc8za8SWOBxTWN8NhHNM/edit?usp=sharing") else {return}
        let vc = PrivacyPolicyViewController(url: url)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
}
