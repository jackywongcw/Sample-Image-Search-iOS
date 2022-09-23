//
//  DetailViewController.swift
//  ImageSearch
//
//  Created by Jacky Wong on 24/9/22.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet var mainImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var webpageURLTextView: UITextView!

	var viewModel: ImageDetailsViewModel!
	private var networkService = NetworkService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
	
	private func setupUI() {
		if let imageData = viewModel.imageModel.mainImageData {
			mainImageView.image = UIImage(data: imageData)
		} else {
			networkService.downloadImage(urlString: viewModel.imageModel.url) { [weak self] imageData in
				guard let imageData = imageData else { return }
				DispatchQueue.main.async {
					self?.mainImageView.image = UIImage(data: imageData)
				}
			}
		}
		
		mainImageView.contentMode = .scaleAspectFill
		
		titleLabel.numberOfLines = 0
		titleLabel.text = viewModel.imageModel.title
		
		webpageURLTextView.backgroundColor = .clear
		
		let urlString = viewModel.imageModel.webpageUrl ?? ""
		let attributedString = NSMutableAttributedString(string: urlString)
		attributedString.addAttribute(.link, value: urlString,
									  range: NSRange(location: 0, length: urlString.count))
		
		webpageURLTextView.attributedText = attributedString
		webpageURLTextView.textContainerInset = .zero
		webpageURLTextView.linkTextAttributes = [
			.foregroundColor: UIColor.blue,
			.underlineStyle: NSUnderlineStyle.single.isEmpty
		]
		
	}
	
}
