//
//  DataTransformation.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import Foundation
import UIKit

protocol DataToImageTranformationService: class {
    func getImage(from data: Data) -> UIImage?
}

class DataTransformationServiceImplementation: DataToImageTranformationService {
    
    func getImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
