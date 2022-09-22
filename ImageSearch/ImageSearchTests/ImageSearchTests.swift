//
//  ImageSearchTests.swift
//  ImageSearchTests
//
//  Created by Jacky Wong on 18/9/22.
//

import XCTest
@testable import ImageSearch

class ImageSearchTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	/// Test using hardcoded model
	func testHardcodedResponseWithSingleImageResult() throws {
		
		let model = ImageQueryModel(url: "https://www.pinkvilla.com/files/styles/fbimagesection/public/taylor_swift_birthday.jpeg?itok=VRq6drie",
									height: 100, width: 100,
									thumbnail: "https://rapidapi.usearch.com/api/thumbnail/get?value=8039867206085482440",
									thumbnailHeight: 50,
									thumbnailWidth: 50,
									name: "",
									title: "Taylor Swift Birthday: 6 PHOTOS of the singer's hottest looks from her performances",
									provider: ProviderModel(name: "pinkvilla",
															favIcon: ""),
									imageWebSearchUrl: "https://usearch.com/search/taylor%20swift/images",
									webpageUrl: "https://www.pinkvilla.com/photos/taylor-swift/taylor-swift-birthday-6-photos-singers-hottest-looks-her-performances-966132")
		
		let vm = QueryResultViewModel(searchResponseModel: SearchResponseModel(_type: "images",
																			   totalCount: 1,
																			   value: [model]))
		
		XCTAssertEqual(model.title, vm.imageResults.first?.title)
		XCTAssert(vm.imageResults.count == 1)
	}
	
	/// Test using local json file
	func testLocalJSONResponseWithTwoValues() throws {
		let testFilename = "SampleJsonResponseWithTwoValues"
		guard let url = Bundle.main.url(forResource: testFilename, withExtension: "json") else {
			XCTFail("Unable to find json file: \(testFilename)")
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()
			let jsonData = try decoder.decode(SearchResponseModel.self, from: data)
			
			XCTAssert(jsonData.value.count == 2, "Value count not same as json's, please check")
			XCTAssert(jsonData.totalCount == 2, "VM totalCount not same as json's, please check")
		} catch let error {
			print("error:\(error)")
			XCTFail("testLocalJSONResponseWithTwoValues failed with error: \(error)")
		}
	}
	
	/// Test with viewModel API call, query param = 'taylor'
	func testAPIResponseWithKeywordTaylor() {
		
		let queryKeyword: String = "taylor"
		let expectedCountSize: Int = 10
		let vm = QueryResultViewModel(searchResponseModel: SearchResponseModel(_type: "",
																			   totalCount: expectedCountSize,
																			   value: [ImageQueryModel]()))
		
		let expectation = expectation(description: "API call with query = 'taylor'")
		let networkService = NetworkService()
		
		networkService.searchForImages(queryString: queryKeyword, pageNumber: 1, pageSize: 10) { result in
			switch result {
			case .success(let response):
				
				vm.imageResults = response.value
				
				// Expect 10 (expectedCountSize) as the input pageSize is 10
				XCTAssert(response.value.count == expectedCountSize, "api response is not expected. Expected value: \(expectedCountSize)")
				XCTAssert(vm.imageResults.count == expectedCountSize, "viewModel result is not expected. Expected value: \(expectedCountSize)")
				
				expectation.fulfill()
				
			case .failure(let error):
				print("testAPIResponseWithKeywordTaylor error = \(error.localizedDescription)")
				// Expect no error, but if there's error, force test to fail
				XCTFail(error.localizedDescription)
				expectation.fulfill()
			}
		}
		
		waitForExpectations(timeout: 30) { error in
			guard let error = error else { return }
			// Time out error
			print("Error: \(error.localizedDescription)")
		}
		
	}
	
	/// Test with viewModel API call with long invalid string and huge pageNumber, expect empty value response
	func testAPIResponseWithJibberishKeywordAndPageNumber() {
		
		// Delay the test case as the API BASIC plan has rate limit per second, otherwise this test will fail
		sleep(20)
		
		let queryKeyword: String = "kblksfhdklshfdlkgshf"
		let queryPageNumber: Int = 1236
		let expectedCountSize: Int = 0
		let vm = QueryResultViewModel(searchResponseModel: SearchResponseModel(_type: "",
																			   totalCount: expectedCountSize,
																			   value: [ImageQueryModel]()))
		
		let expectation = expectation(description: "API call with query = \(queryKeyword)")
		let networkService = NetworkService()
		
		networkService.searchForImages(queryString: queryKeyword, pageNumber: queryPageNumber, pageSize: 10) { result in
			switch result {
			case .success(let response):
				
				vm.imageResults = response.value
				
				XCTAssertTrue(response.totalCount == 0,
							  "Expected value should be 0, unless the random string and pageNumber actually has data..")
				// Expect 0 (expectedCountSize) as the input pageSize is 1236
				XCTAssert(response.value.count == expectedCountSize, "api response is not expected. Expected value: \(expectedCountSize)")
				XCTAssert(vm.imageResults.count == expectedCountSize, "viewModel imageResults count is not expected. Expected value: \(expectedCountSize)")
				
				expectation.fulfill()
				
			case .failure(let error):
				print("testAPIResponseWithKeywordTaylor error = \(error.localizedDescription)")
				// Expect no error, but if there's error, force test to fail
				XCTFail(error.localizedDescription)
				expectation.fulfill()
			}
		}
		
		waitForExpectations(timeout: 30) { error in
			guard let error = error else { return }
			// Time out error
			print("Error: \(error.localizedDescription)")
		}
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
