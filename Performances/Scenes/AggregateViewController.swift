import UIKit
import Records

class AggregateViewController: UIViewController {
    
    private var performers: [Performer]!
    private var performerA: Performer!
    private var performerB: Performer!
    private var operators: [Aggregate<Performer>.Operator] = [.someMatching, .noneMatching, .allMatching]
    private lazy var currentOperator = operators[0]
    private var performances: [Performance]!
    private let context = Storage.sharedInstance.persistentContainer.viewContext
    
    private enum PickerView: Int {
        case first
        case second
        case third
    }
    
    @IBOutlet private weak var firstTextField: UITextField! {
        didSet {
            firstTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var secondTextField: UITextField! {
        didSet {
            secondTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var thirdTextField: UITextField! {
        didSet {
            thirdTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var tableView: PerformancesTableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Aggregate"
        
        do {
            performers = try Performer.fetchAll(in: context)
        } catch {
            fatalError(message1)
        }
        
        do {
            guard let performer = try Performer.Query(gender: .female).first(in: context) else {
                preconditionFailure(message4)
            }
            performerA = performer
        } catch {
            fatalError(message1)
        }
        
        do {
            guard let performer = try Performer.Query(gender: .male).first(in: context) else {
                preconditionFailure(message4)
            }
            performerB = performer
        } catch {
            fatalError(message1)
        }
        
        firstTextField.text = performerA.fullName
        secondTextField.text = performerB.fullName
        thirdTextField.text = String(describing: currentOperator)
        
        tableView.highlightedPerformers = { [unowned self] in
            return [self.performerA, self.performerB]
        }
        
        firstTextField.inputView = makeFirstPicker()
        secondTextField.inputView = makeSecondPicker()
        thirdTextField.inputView = makeThirdPicker()
        
        performances = refetch()
    }
    
    private func makeFirstPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.tag = PickerView.first.rawValue
        pickerView.dataSource = self
        pickerView.delegate = self
        if let index = performers.firstIndex(of: performerA) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        return pickerView
    }
    
    private func makeSecondPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.tag = PickerView.second.rawValue
        pickerView.dataSource = self
        pickerView.delegate = self
        if let index = performers.firstIndex(of: performerB) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        return pickerView
    }
    
    private func makeThirdPicker() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.tag = PickerView.third.rawValue
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
    
    private func refetch() -> [Performance] {
        let query = Performance.Query(performers: Aggregate(currentOperator, records: [performerA, performerB]))
        do {
            return try query.all(in: context)
        } catch {
            fatalError(message1)
        }
        /// currentOperator
        /// - someMatching: Must include at least one.
        /// - allMatching: Must include all.
        /// - noneMatching: Must exclude all.
    }
}

extension AggregateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return performances.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? PerformancesTableView else {
            fatalError("Must have PerformancesTableView here.")
        }
        let performance = performances[indexPath.row]
        return tableView.dequeue(at: indexPath, for: performance)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Performances"
    }
}

extension AggregateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let performance = performances[indexPath.row]
        let group = performance.group_.rawValue
        guard let performer = performance.performers.first else {
            preconditionFailure(message4)
        }
        let name = performer.firstName
        print("Selected " + group.lowercased() + " containing: " + name)
    }
}

extension AggregateViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let picker = PickerView(rawValue: pickerView.tag) else {
            preconditionFailure()
        }
        if case .third = picker {
            return operators.count
        }
        return performers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let picker = PickerView(rawValue: pickerView.tag) else {
            preconditionFailure()
        }
        if case .third = picker {
            return String(describing: operators[row])
        }
        return performers[row].fullName
    }
    
}

extension AggregateViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let picker = PickerView(rawValue: pickerView.tag) else {
            preconditionFailure()
        }
        
        switch picker {
        case .first:
            let performer = performers[row]
            performerA = performer
            firstTextField.text = performer.fullName
        case .second:
            let performer = performers[row]
            performerB = performer
            secondTextField.text = performer.fullName
        case .third:
            let selectedOperator = operators[row]
            currentOperator = selectedOperator
            thirdTextField.text = String(describing: selectedOperator)
        }
        performances = refetch()
        reloadUI()
    }
    
    private func reloadUI() {
        dispatchAfter(seconds: 0.3) {
            self.tableView.reloadData()
            if self.performances.count > 0 {
                dispatchAfter(seconds: 0.3) {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}

extension AggregateViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func doneButtonPressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
}
