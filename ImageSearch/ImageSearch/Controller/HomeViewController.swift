//
//  HomeViewController.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet var resultTableView: UITableView!
	
	private var isFirstLoad: Bool = false
	private var resultViewModel = QueryResultViewModel()
	
	let imageCellId: String = String(describing: ImageResultTableViewCell.self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		resultViewModel.queryResultDelegate = self
	}
	
	func setupUI() {
		resultTableView.register(UINib(nibName: "ImageResultTableViewCell", bundle: nil), forCellReuseIdentifier: imageCellId)
		
		
	}
	
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFirstLoad || resultViewModel.imageResults.isEmpty {
			return 1
		} else {
			return resultViewModel.imageResults.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! ImageResultTableViewCell
		
		if isFirstLoad {
			// Initial cell
			cell.titleLabel.text = "Type something in the search bar for result!"
		} else if resultViewModel.imageResults.count == 0 {
			// Empty cell
			cell.titleLabel.text = "No result for your search term :("
		} else {
			// Data cell
			cell.titleLabel.text = "Hello!"
		}
		
		
		return cell
	}
}

extension HomeViewController: QueryResultDelegate {
	func willFetchQuery() {
		print("fetching")
	}
	
	func didFetchQuery(_ imageResults: [ImageQueryModel], error: Error?) {
		print("")
		if let error = error {
			
		} else {
			resultTableView.reloadData()
		}
	}
	
	
}
