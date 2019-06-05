//
//  RestUrl.swift
//  BuySellApp
//
//  Created by Sanzid on 3/30/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import Foundation

class SharesHelper {
    static func generateShares() -> [Share] {
		return [
			Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.123, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true, isClosed: true),
            Share(company: "Keeno", category: "keeno notification", price: 766.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 568.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 468.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.123, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true, isClosed: true),
            Share(company: "Keeno", category: "keeno notification", price: 766.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 568.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 468.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.123, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 766.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 568.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 468.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.123, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 766.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 568.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 468.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: true),
            Share(company: "Keeno", category: "keeno notification", price: 768.5, score: 1.43, percent: 0.34, isGrowing: false)
        ]
    }
}
