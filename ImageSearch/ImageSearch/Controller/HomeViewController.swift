//
//  HomeViewController.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var resultTableView: UITableView!
	
	private var resultViewModel = QueryResultViewModel()
	
	let imageCellId: String = String(describing: ImageResultTableViewCell.self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		resultViewModel.queryResultDelegate = self
	}
	
	func setupUI() {
		
		// TableView and SearchBar delegates are set through storyboard.
		// Can also set here if through code
		
		resultTableView.register(UINib(nibName: "ImageResultTableViewCell", bundle: nil), forCellReuseIdentifier: imageCellId)
		resultTableView.keyboardDismissMode = .onDrag
		
	}
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return resultViewModel.imageResults.count == 0 ? 0 : resultViewModel.imageResults.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! ImageResultTableViewCell
		
		// Data cell
		let viewModel = resultViewModel.imageResults[indexPath.row]
		
		cell.titleLabel.text = viewModel.title
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		searchBar.endEditing(true)
	}
	
}

extension HomeViewController: QueryResultDelegate {
	func willFetchQuery() {
		print("fetching")
	}
	
	func didFetchQuery(_ imageResults: [ImageQueryModel], error: Error?) {
		
		if let error = error {
			let alert = UIAlertController(title: Constants.Error.title,
										  message: error.localizedDescription,
										  preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: Constants.Button.okay, style: .default, handler: { action in
				self.resultTableView.reloadData()
			}))
			
			self.present(alert, animated: true)
			
		}
		resultTableView.reloadData()
	}
}

extension HomeViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		guard let searchQuery = searchBar.text else { return }
		
		guard !searchQuery.isEmpty else {
			resultViewModel.emptyQueryFlow()
			return
		}
		
		print("SearchQuery =  \(searchQuery)")
		
		resultViewModel.searchQuery(queryString: searchQuery)
		searchBar.endEditing(true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
		resultViewModel.clearResults()
	}
}
