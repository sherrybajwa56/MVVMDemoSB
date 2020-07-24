//
//  Coordinator.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import UIKit

protocol FactsCoordinator: class {
    func pushToPhotoDetail(with photoId: String)
}

class FactsCoordinatorImplementation: Coordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let factsViewController = FactsViewController()
        let factsViewModel = FactsViewModelImplementation(
            factsService: FactsServiceImplementation(),
            factLoadingService: DataLoadingServiceImplementation(),
            dataTofacTranformService: DataTransformationServiceImplementation(),
            coordinator: self
        )
        factsViewController.viewModel = factsViewModel
        
        navigationController
            .pushViewController(factsViewController, animated: false)
        
        print("")
    }
}
extension FactsCoordinatorImplementation : FactsCoordinator {
    
    func pushToPhotoDetail(with photoId: String) {
        
    }
}


