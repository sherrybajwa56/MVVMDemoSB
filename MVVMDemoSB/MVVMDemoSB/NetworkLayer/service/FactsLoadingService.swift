//
//  FactsLoadingService.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import RxSwift

protocol FactsService: class {
    /// Returns by default 10 photos
    func getFacts() -> Observable<(FactDetail?, Error?)>
}

class FactsServiceImplementation: FactsService {
   
    
    
 private let networkClient = NetworkClient(baseUrlString: BaseURLs.facts)
    
      func getFacts() -> Observable<(FactDetail?, Error?)> {
        self.networkClient.get(FactDetail.self,ApiEndpoints.getFacts)
    }
    
 }
   

