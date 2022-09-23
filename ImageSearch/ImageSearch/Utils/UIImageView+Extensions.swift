//
//  UIImageView+Extensions.swift
//  ImageSearch
//
//  Created by Jacky Wong on 24/9/22.
//

import Foundation
import UIKit

extension c {
   
// Round Image
	func rounded() {
		self.layer.masksToBounds = true
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.clear.cgColor
		self.layer.cornerRadius = self.frame.size.width/2
	}
}
