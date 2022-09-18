//
//  ImageViewModel.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

class ImageViewModel {
	
	private var networkService = NetworkService()
	
	func searchQuery(queryString: String, completion: @escaping () -> ()) {
		
		networkService.searchForImages(queryString: queryString) { result in
			switch result {
			case .failure(let error):
				print("Error!")
				break
				
			case .success(let searchResult):
				print("success!")
				print("result = \(result)")
				break
			}
		}
	}
}
