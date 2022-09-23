//
//  ImageResultTableViewCell.swift
//  ImageSearch
//
//  Created by Jacky Wong on 18/9/22.
//

import UIKit

class ImageResultTableViewCell: UITableViewCell {
	
	@IBOutlet var thumbnailImageView: UIImageView!
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var providerTitleLabel: UILabel!
	@IBOutlet var providerValueLabel: UILabel!

	private var networkService = NetworkService()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }

	func setupUI() {
		titleLabel.numberOfLines = 0
		providerValueLabel.numberOfLines = 0
		
		thumbnailImageView.contentMode = .scaleAspectFill
		thumbnailImageView.rounded()
	}
	
	func setupData(model: ImageQueryModel) {
		titleLabel.text = model.title
		
		providerTitleLabel.text = "Provider:"
		providerValueLabel.text = model.provider?.name
		
		if let thumbnailData = model.thumbnailImageData {
			thumbnailImageView.image = UIImage(data: thumbnailData)
		} else {
			// Using system image as placeholder image
			thumbnailImageView.image = UIImage(systemName: "arrow.2.circlepath")
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
		super.prepareForReuse()
		thumbnailImageView.image = nil
	}
}
