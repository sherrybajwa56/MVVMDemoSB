//
//  FactModel.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import Foundation

struct FactDetail: Codable {
    let title: String
    let rows: [Fact]!
}

struct Fact: Codable {
    let title: String?
    let description: String?
    let imageHref: String?
}


struct UnsplashPhoto: Codable {
    let id: String?
    let description: String?
    let altDescription: String?
    let urls: Urls?
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case altDescription = "alt_description"
        case urls
    }
}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

