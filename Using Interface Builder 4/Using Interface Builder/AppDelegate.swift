import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var artists: [Artist] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create an instance of ArtistViewController
        let artistViewController = CustomerViewController()

        // Pass the artists array to the ArtistViewController instance
        artistViewController.artists = self.artists

        return true
    }
}

