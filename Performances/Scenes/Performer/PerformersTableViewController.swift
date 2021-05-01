import UIKit

class PerformersTableViewController: UIViewController {
    
    let performersController = PerformerController<PerformerTableView>()
    private let navigationStackHandler = PerformersNavigationStackHandler()
    private(set) lazy var tableViewHandler = PerformerTableViewHandler(performersController)
    
    @IBOutlet weak var tableView: PerformerTableView! {
        didSet {
            tableView.dataSource = tableViewHandler
            tableView.delegate = tableViewHandler
            var insets = tableView.contentInset
            insets.top += 5
            insets.bottom += 5
            tableView.contentInset = insets
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Performers"
        
        navigationController?.delegate = navigationStackHandler
        
        performersController.delegate = tableView
        
        tableViewHandler.didSelect = { [unowned self] performer in
            self.performSegue(withIdentifier: "Show", sender: performer)
        }
        
        do {
            try performersController.reload()
        } catch {
            fatalError(message1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableViewHandler.deselectSelected() {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? PerformerViewController)?.performer = sender as? Performer
    }
}
