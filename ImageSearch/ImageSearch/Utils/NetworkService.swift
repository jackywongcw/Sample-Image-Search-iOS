//
//  NetworkService.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

class NetworkService {
	
	enum ResponseErrors: Error {
		case invalidResponse
		case parseError
		// Add other custom error here
	}
	
	enum HttpMethod: String {
		case get
		case post
		// Add other http method here (patch,put etc)
		
		var method: String {
			rawValue.uppercased()
		}
	}
	
	func searchForImages(queryString: String, pageNumber: Int = 10, pageSize: Int = 10, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) {
		
		var domain = "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI"
		
		domain.append("?q=\(queryString)")
		domain.append("&\(pageNumber)")
		domain.append("&\(pageSize)")
		domain.append("&autoCorrect=true")
		
		guard let searchURL = URL(string: domain) else { return }
		
		let headers = [
			"X-RapidAPI-Key": "",
			"X-RapidAPI-Host": "contextualwebsearch-websearch-v1.p.rapidapi.com"
		]
		
		var request = URLRequest(url: searchURL)
		request.httpMethod = HttpMethod.get.method
		request.allHTTPHeaderFields = headers
		
		let session = URLSession.shared
		let dataTask = session.dataTask(with: request) { data, response, error in
			
			if let error = error {
				completion(.failure(error))
				print("SearchForImagesError: \(error)")
				return
			}
			
			guard let response = response as? HTTPURLResponse else {
				completion(.failure(ResponseErrors.invalidResponse))
				return
			}
			
			print("Response status code: \(response.statusCode)")
			
			guard let data = data else {
				completion(.failure(ResponseErrors.invalidResponse))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let jsonData = try decoder.decode(SearchResponseModel.self, from: data)
				
				DispatchQueue.main.async {
					completion(.success(jsonData))
				}
			} catch let error {
				completion(.failure(error))
			}
		}
		
		dataTask.resume()
	}
}
