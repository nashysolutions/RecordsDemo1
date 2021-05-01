import UIKit

final class EventsViewController: UIViewController {
    
    private let eventsController = EventController<EventsTableView>()
    
    private lazy var tableViewHandler = EventTableViewHandler(eventsController)
    
    @IBOutlet weak var tableView: EventsTableView! {
        didSet {
            tableView.dataSource = tableViewHandler
            tableView.delegate = tableViewHandler
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Events"
        
        tableViewHandler.selectEvent = { [unowned self] event in
            self.performSegue(withIdentifier: "summary", sender: event)
        }
        
        eventsController.contentChanged = { count in
            print("""
                • Events Listener noticed an Add, Remove, Move or Update
                • Maybe a change to the event.performances attribute? Did you delete a performance for this event in PerformancesViewController?
                • Events total count is \(count)
                • If delete then .populateDatabase() in AppDelegate will re-introduce from JSON on next launch.
                """)
        }
        
        eventsController.delegate = tableView
        
        do {
            try eventsController.reload()
        } catch {
            fatalError(message1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? EventViewController)?.event = sender as? Event
    }
}
