//
//  NewsResult.swift
//  NewsReader
//
//  Created by Mahjeed Marrow on 5/6/19.
//  Copyright © 2019 Mahjeed Marrow. All rights reserved.
//

import UIKit
import Foundation

// Mark: news result properties
struct NewsResult: Codable {
    let totalResults: Int
    let articles: [News]
}

struct News: Codable {
    let author: String?
    let title: String
    let url: String
    let publishedAt: String?
}
