//
//  QueryResultViewModel.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

protocol QueryResultDelegate {
	func willFetchQuery()
	func didFetchQuery(_ imageResults: [ImageQueryModel], error: Error?)
}
class QueryResultViewModel {
		
	private var networkService = NetworkService()
	var imageResults = [ImageQueryModel]()
	
	var queryResultDelegate: QueryResultDelegate?
	
	func searchQuery(queryString: String, completion: @escaping () -> ()) {
		
		networkService.searchForImages(queryString: queryString) { [weak self] result in
						
			switch result {
				
			case .success(let searchResult):
				print("success!")
				print("result = \(result)")
				self?.imageResults = searchResult.value
				self?.queryResultDelegate?.didFetchQuery(self?.imageResults ?? [], error: nil)
				break
				
			case .failure(let error):
				self?.queryResultDelegate?.didFetchQuery([], error: error)
				print("Error!")
				break
			}
			
		}
	}
	
}
