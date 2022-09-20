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
		
	enum QueryResultError: Error, LocalizedError {
		case emptyQuery
		
		public var errorDescription: String? {
			switch self {
			case .emptyQuery:
				return Constants.Error.emptyQuery
			}
		}
	}
	private var networkService = NetworkService()
	var imageResults = [ImageQueryModel]()
	
	var queryResultDelegate: QueryResultDelegate?
	
	var mainImageTasks = [URLSessionTask]()
	var thumbnailImageTasks = [URLSessionTask]()
	
	func searchQuery(queryString: String) {
		
		queryResultDelegate?.willFetchQuery()
		
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
	
	func downloadImageForIndexPath(_ indexPath: IndexPath) {
		
		downloadModelMainImage(indexPath)
		downloadModelThumbnailImage(indexPath)
		
	}
	
	private func downloadModelMainImage(_ indexPath: IndexPath) {
		if imageResults[indexPath.row].mainImageData == nil,
		   let mainImageURL = URL(string: imageResults[indexPath.row].url) {
			guard mainImageTasks.firstIndex(where: { $0.originalRequest?.url == mainImageURL }) == nil else {
				// Already downloading image
				return
			}
			
			let task = URLSession.shared.dataTask(with: mainImageURL) { data, response, error in
				guard let data = data else { return }
				self.imageResults[indexPath.row].mainImageData = data
			}
			task.resume()
			mainImageTasks.append(task)
		}
	}
	
	private func downloadModelThumbnailImage(_ indexPath: IndexPath) {
		if imageResults[indexPath.row].thumbnailImageData == nil,
		   let thumbnailImageURL = URL(string: imageResults[indexPath.row].url) {
			guard thumbnailImageTasks.firstIndex(where: { $0.originalRequest?.url == thumbnailImageURL }) == nil else {
				// Already downloading image
				return
			}
			let task = URLSession.shared.dataTask(with: thumbnailImageURL) { data, response, error in
				guard let data = data else { return }
				self.imageResults[indexPath.row].thumbnailImageData = data
			}
			task.resume()
			thumbnailImageTasks.append(task)
		}
	}
	
	func cancelDownloadingImages(_ indexPath: IndexPath) {
		cancelMainImageDownloading(indexPath)
		cancelThumbnailImageDownloading(indexPath)
	}
	
	private func cancelMainImageDownloading(_ indexPath: IndexPath) {
		let url = URL(string: imageResults[indexPath.row].url)
		guard let taskIndex = mainImageTasks.firstIndex(where: { $0.originalRequest?.url == url }) else {
			return
		}
		let task = mainImageTasks[taskIndex]
		task.cancel()
		mainImageTasks.remove(at: taskIndex)
	}
	
	private func cancelThumbnailImageDownloading(_ indexPath: IndexPath) {
		let url = URL(string: imageResults[indexPath.row].thumbnail)
		guard let taskIndex = mainImageTasks.firstIndex(where: { $0.originalRequest?.url == url }) else {
			return
		}
		let task = thumbnailImageTasks[taskIndex]
		task.cancel()
		thumbnailImageTasks.remove(at: taskIndex)
	}
	
	func clearResults() {
		imageResults.removeAll()
		self.queryResultDelegate?.didFetchQuery(self.imageResults , error: nil)
	}
	
	func emptyQueryFlow() {
		imageResults.removeAll()
		self.queryResultDelegate?.didFetchQuery([], error: QueryResultError.emptyQuery)
	}
	
}
