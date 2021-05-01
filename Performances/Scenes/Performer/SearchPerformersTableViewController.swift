import UIKit

final class SearchPerformersTableViewController: PerformersTableViewController {
    
    fileprivate let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Performers"
        controller.searchBar.tintColor = black
        controller.searchBar.scopeButtonTitles = ["Any", Performer.Gender.male.rawValue.capitalized, Performer.Gender.female.rawValue.capitalized]
        return controller
    }()
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.searchController = searchController
        item.hidesSearchBarWhenScrolling = false
        return item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
}

extension SearchPerformersTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let text = ""
        searchBar.text = text
        let scope: Int = 0
        searchBar.selectedScopeButtonIndex = scope
        filterContentForSearchText(text, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchBar.text else {
            preconditionFailure()
        }
        filterContentForSearchText(text, scope: selectedScope)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else {
            preconditionFailure()
        }
        let selectedScope = searchBar.selectedScopeButtonIndex
        filterContentForSearchText(text, scope: selectedScope)
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: Int) {
        guard let titles = searchController.searchBar.scopeButtonTitles else {
            preconditionFailure()
        }
        let title = titles[scope]
        if let gender = Performer.Gender(rawValue: title.lowercased()) {
            performersController.updatePredicate(fullName: searchText, gender: gender)
        } else {
            performersController.updatePredicate(fullName: searchText)
        }
    }
}
