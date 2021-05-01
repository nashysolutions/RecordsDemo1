import UIKit

class PerformancesViewController: UIViewController {
  
    let performancesController = PerformanceController<PerformancesTableView>()
    
    private lazy var tableViewHandler = PerformanceTableViewHandler(performancesController)
  
    @IBOutlet private weak var tableView: PerformancesTableView! {
        didSet {
            tableView.dataSource = tableViewHandler
            tableView.delegate = tableViewHandler
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Performances"
        
        performancesController.delegate = tableView
        
        tableViewHandler.didSelect = { performance in
            let group = performance.group_.rawValue
            guard let value = performance.performers.first else {
                preconditionFailure(message4)
            }
            let name = value.firstName
            print("Selected " + group.lowercased() + " containing: " + name)
        }
    }
}
