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
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
