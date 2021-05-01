import UIKit

class EventViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet private weak var eventLabel: EventTitleLabel!
    @IBOutlet private weak var performersButton: PerformersMenuButton!
    @IBOutlet private weak var performancesButton: PerformancesMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventLabel.update(withStartDate: event.startDate)
        performancesButton.update(withPerformancesCount: event.performances?.count ?? 0)
        performersButton.update(withPerformerCount: event.performerCount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let performancesViewController = segue.destination as? PerformancesViewController {
            performancesViewController.performancesController.event = event
        }
        if let performersViewController = segue.destination as? PerformersCollectionViewController {
            performersViewController.performersController.event = event
        }
    }
}
