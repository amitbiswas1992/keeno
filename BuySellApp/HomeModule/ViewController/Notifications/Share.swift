//
//  ProductDetailsVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import Foundation

struct Share {
    let company: String
    let category: String
    let price: Double
    let score: Double
    let percent: Double
    let isGrowing: Bool
	var isClosed: Bool = false
	
	init(company: String, category: String, price: Double, score: Double, percent: Double, isGrowing: Bool, isClosed: Bool = false) {
		self.company = company
		self.category = category
		self.price = price
		self.score = score
		self.percent = percent
		self.isGrowing = isGrowing
		self.isClosed = isClosed
	}
}
