import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        let context = Storage.sharedInstance.persistentContainer.viewContext
        
        do {
            try Database.populate(context)
        } catch {
            print(error)
        }
        
        UINavigationBar.appearance().tintColor = black
        UINavigationBar.appearance().barTintColor = green
        UINavigationBar.appearance().isTranslucent = false
        UISegmentedControl.appearance().tintColor = black
        
        return true
    }
}
