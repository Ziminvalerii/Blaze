//
//  Application.swift
//  Snake
//
//  Created by 1 on 06.06.2022.
//

import UIKit

final class Application {
    
    static var shared = Application()
    
    private init() {}
    
    //    var isFirstInitial = false
    
    var isMuteSound = false
    
    var bestResult: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.bestResult.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.bestResult.rawValue)
        }
    }
    
    var isInitializedApp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.isInitializedApp.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.isInitializedApp.rawValue)
        }
    }
    
    enum UserDefaultsKey: String {
        case bestResult
        case isInitializedApp
    }
}

