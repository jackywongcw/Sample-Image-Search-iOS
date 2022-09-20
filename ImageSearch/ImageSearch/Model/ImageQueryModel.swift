//
//  ImageQueryModel.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

struct ImageQueryModel: Decodable {
	
	/// URL of image. Use this var to download image
	let url: String
	let height: Int?
	let width: Int?
	/// URL of thumbnail image. Use this var to download thumbnail image
	let thumbnail: String
	let thumbnailHeight: Int?
	let thumbnailWidth: Int?
	let name: String?
	let title: String?
	let provider: ProviderModel?
	let imageWebSearchUrl: String?
	let webpageUrl: String?
	
	// Non api response, to use locally
	var mainImageData: Data?
	
	var thumbnailImageData: Data?
}
