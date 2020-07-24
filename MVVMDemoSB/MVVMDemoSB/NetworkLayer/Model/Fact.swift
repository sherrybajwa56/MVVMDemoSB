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




