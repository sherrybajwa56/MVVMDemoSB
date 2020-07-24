//
//  NetworkErrors.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case unknown
}

