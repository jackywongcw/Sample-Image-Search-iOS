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
	
	@IBOutlet var resultTitleLabel: UILabel!
	
	private var resultViewModel = QueryResultViewModel()
	var indicator = UIActivityIndicatorView()
	
	let imageCellId: String = String(describing: ImageResultTableViewCell.self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		resultViewModel.queryResultDelegate = self
	}
	
	func setupUI() {
		
		searchBar.placeholder = "Type something to search for images"
		// TableView and SearchBar delegates are set through storyboard.
		// Can also set here if through code
		
		resultTableView.register(UINib(nibName: "ImageResultTableViewCell", bundle: nil), forCellReuseIdentifier: imageCellId)
		resultTableView.keyboardDismissMode = .onDrag
		
		resultTitleLabel.isHidden = true
		
		// Create indicator programatically instead of storyboard
		indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		indicator.style = .medium
		indicator.hidesWhenStopped = true
		indicator.center = self.view.center
		self.view.addSubview(indicator)
	}
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return resultViewModel.imageResults.count == 0 ? 0 : resultViewModel.imageResults.count
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastSectionIndex = resultTableView.numberOfSections - 1
		let lastRowIndex = resultTableView.numberOfRows(inSection: lastSectionIndex) - 1
		if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
			let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
			indicator.style = .medium
			indicator.startAnimating()
			
			self.resultTableView.tableFooterView = indicator
			self.resultTableView.tableFooterView?.isHidden = false
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! ImageResultTableViewCell
		
		// Data cell
		let viewModel = resultViewModel.imageResults[indexPath.row]
		
		cell.setupData(model: viewModel)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		searchBar.endEditing(true)
	}
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		
		print("Prefetching ... \(indexPaths)")
		for indexPath in indexPaths {
			resultViewModel.downloadImageForIndexPath(indexPath)
		}
	}
	
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		
		for indexPath in indexPaths {
			resultViewModel.cancelDownloadingImages(indexPath)
		}
	}
}

extension HomeViewController: QueryResultDelegate {
	func willFetchQuery() {
		print("fetching")
		indicator.startAnimating()
	}
	
	func didFetchQuery(_ imageResults: [ImageQueryModel], error: Error?) {
		DispatchQueue.main.async {
			
			self.indicator.stopAnimating()
			self.resultTitleLabel.isHidden = false
			
			self.resultTableView.tableFooterView?.isHidden = true
			self.resultTableView.tableFooterView = nil
			
			self.resultTitleLabel.text = "\(imageResults.count) results"
			
			if let error = error {
				let alert = UIAlertController(title: Constants.Error.title,
											  message: error.localizedDescription,
											  preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: Constants.Button.okay, style: .default, handler: { action in
					self.resultTableView.reloadData()
				}))
				
				self.present(alert, animated: true)
				
			}
			self.resultTableView.reloadData()
		}
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
extension HomeViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let position = scrollView.contentOffset.y
		let contentHeight = resultTableView.contentSize.height
		if position > contentHeight - scrollView.frame.size.height*2 {
			// Fetch for next page
			resultViewModel.searchQuery(pagination: true)
		}
	}
}
