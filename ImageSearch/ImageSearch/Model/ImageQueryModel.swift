//
//  ImageQueryModel.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

struct ImageQueryModel: Decodable {
	
	let url: String?
	let height: Int?
	let width: Int?
	let thumbnail: String?
	let thumbnailHeight: Int?
	let thumbnailWidth: Int?
	let name: String?
	let title: String?
	//provider:
	let imageWebSearchUrl: String?
	let webpageUrl: String?
	
}
