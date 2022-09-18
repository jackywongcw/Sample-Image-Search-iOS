//
//  Constants.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import Foundation

struct Constants {
	
	struct API {
		static let domain = "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI"
		static let apiKey = "X-RapidAPI-Key"
		static let apiValue = ""
		static let hostKey = "X-RapidAPI-Host"
		static let hostValue = "contextualwebsearch-websearch-v1.p.rapidapi.com"
	}
	
	static let unexpectedResponseErrorString = "Unexpected response from server, please try again later."
	static let parsingErrorString = unexpectedResponseErrorString
	
	
	
}
