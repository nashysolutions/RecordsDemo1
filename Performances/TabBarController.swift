import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
    }
    
    func disablePerformersTableViewControllerAnimations() {
        guard let controller = extractPerformersTableViewController() else {
            assertionFailure()
            return
        }
        controller.tableViewHandler.animationsEnabled = false
    }
    
    func enablePerformersTableViewControllerAnimations() {
        guard let controller = extractPerformersTableViewController() else {
            assertionFailure()
            return
        }
        controller.tableViewHandler.animationsEnabled = true
    }
    
    /// important to loop through and get a fresh pointer each time we want to access this controller, because UISplitViewControllerDelegate may rebuild a controller or two during it's lifecycle.
    private func extractPerformersTableViewController() -> PerformersTableViewController? {
        for case let navigationController as UINavigationController in viewControllers ?? [] {
            if let controller = navigationController.topViewController as? PerformersTableViewController {
                return controller
            }
        }
        return nil
    }
}
