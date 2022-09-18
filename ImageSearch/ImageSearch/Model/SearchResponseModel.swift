//
//  SearchResponseModel.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

struct SearchResponseModel: Decodable {
	let _type: String?
	let totalCount: Int
	
	let value: [ImageQueryModel]
}
