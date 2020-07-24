//
//  FactsLoadingService.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import RxSwift

protocol FactsService: class {

  
}

class FactsServiceImplementation: FactsService {
    
 private let networkClient = NetworkClient(baseUrlString: BaseURLs.facts)
    
    
 }
   

