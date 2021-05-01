import UIKit
import Records

/// Searching without fetchedResultsController
final class SearchPerformersViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    private let context = Storage.sharedInstance.persistentContainer.viewContext
    
    @IBOutlet private weak var tableView: PerformerTableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var footerLabel: UILabel! {
        didSet {
            do {
                let storedRecord: Performer? = try Performer.fetchFirst(in: context)
                guard let performer = storedRecord else {
                    preconditionFailure(message4)
                }
                footerLabel.text = "Example: \"\(performer.firstName)\""
            } catch {
                fatalError(message1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Performers"
    }
    
    private var performers: [Performer] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var textField: UITextField!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        textField.resignFirstResponder()
        performers = search()
    }
    
    private func search() -> [Performer] {
        let text = textField.text ?? ""
        let param = StringParameter(candidate: text, match: .beginningWith)
        let query = Performer.Query(firstName: param)
        do {
            return try query.all(in: context)
        } catch {
            fatalError(message1)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? PerformerTableView else {
            fatalError("Must have PerformerTableView here.")
        }
        let performer = performers[indexPath.row]
        return tableView.dequeue(at: indexPath, for: performer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performers = search()
        return true
    }
}
