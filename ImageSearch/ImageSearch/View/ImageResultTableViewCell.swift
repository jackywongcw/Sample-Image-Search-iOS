//
//  ImageResultTableViewCell.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import UIKit

class ImageResultTableViewCell: UITableViewCell {
	
	@IBOutlet var mainImageView: UIImageView!
	@IBOutlet var thumbnailImageView: UIImageView!
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var providerTitleLabel: UILabel!
	@IBOutlet var providerValueLabel: UILabel!
	@IBOutlet var webpageTitleLabel: UILabel!
	@IBOutlet var webpageValueLabel: UILabel!

	private var networkService = NetworkService()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }

	func setupUI() {
		titleLabel.numberOfLines = 0
		providerValueLabel.numberOfLines = 0
		webpageValueLabel.numberOfLines = 0
	}
	
	func setupData(model: ImageQueryModel) {
		titleLabel.text = model.title
		
		providerTitleLabel.text = "Provider:"
		providerValueLabel.text = model.provider?.name
		
		webpageTitleLabel.text = "Webpage URL:"
		webpageValueLabel.text = model.webpageUrl
		
		if let imageData = model.mainImageData {
			mainImageView.image = UIImage(data: imageData)
		} else {
			networkService.downloadImage(urlString: model.url) { [weak self] imageData in
				guard let imageData = imageData else { return }
				DispatchQueue.main.async {
					self?.mainImageView.image = UIImage(data: imageData)
				}
			}
		}
		
		if let thumbnailData = model.thumbnailImageData {
			thumbnailImageView.image = UIImage(data: thumbnailData)
		} else {
			networkService.downloadImage(urlString: model.thumbnail) { [weak self] imageData in
				guard let imageData = imageData else { return }
				DispatchQueue.main.async {
					self?.thumbnailImageView.image = UIImage(data: imageData)
				}
			}
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
	override func prepareForReuse() {
		mainImageView.image = nil
		thumbnailImageView.image = nil
	}
}
