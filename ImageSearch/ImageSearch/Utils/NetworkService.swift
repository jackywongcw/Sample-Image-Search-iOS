//
//  NetworkService.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

class NetworkService {
	
	enum ResponseErrors: Error {
		case invalidResponse(String)
		case parseError(String)
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
		
		var domain = Constants.API.domain
		
		domain.append("?q=\(queryString)")
		domain.append("&\(pageNumber)")
		domain.append("&\(pageSize)")
		domain.append("&autoCorrect=true")
		
		guard let searchURL = URL(string: domain) else { return }
		
		let headers = [
			Constants.API.apiKey: Constants.API.apiValue,
			Constants.API.hostKey: Constants.API.hostValue
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
				completion(.failure(ResponseErrors.invalidResponse(Constants.unexpectedResponseErrorString)))
				return
			}
			
			print("Response status code: \(response.statusCode)")
			
			guard let data = data else {
				completion(.failure(ResponseErrors.invalidResponse(Constants.unexpectedResponseErrorString)))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let jsonData = try decoder.decode(SearchResponseModel.self, from: data)
				
				DispatchQueue.main.async {
					completion(.success(jsonData))
				}
			} catch let error {
				print("Parse error: \(error.localizedDescription)")
				completion(.failure(ResponseErrors.parseError(Constants.parsingErrorString)))
			}
		}
		
		dataTask.resume()
	}
	
	func downloadImage(urlString: String, completion: @escaping (Data?) -> Void) {
		
		print("Downloading image ... ")
		guard let url = URL(string: urlString) else {
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data else { return }
			
			completion(data)
		}
		task.resume()
	}
}
