//
//  FactsViewModel.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// View model interface that is visible to the PhotosViewController
protocol FactsViewModel: class {
    // Input
    var viewDidLoad: PublishRelay<Void>
    { get }
    var willDisplayCellAtIndex: PublishRelay<Int>
    { get }
   
    // Output
  

    var facts: BehaviorRelay<[Fact]>
    { get }
    var navTitle: BehaviorRelay<String>
    { get }
    var imageRetrievedSuccess: PublishRelay<(UIImage, Int)>
    { get }
    var imageRetrievedError: PublishRelay<Int>
    { get }
}

final class FactsViewModelImplementation: FactsViewModel {
  
    // MARK: - Private Properties
    private let factsService: FactsService
    private let factLoadingService: DataLoadingService
    private let dataTofacTranformService: DataToImageTranformationService
    private let coordinator: FactsCoordinator
    
    private let disposeBag = DisposeBag()
    private let pageNumber = BehaviorRelay<Int>(value: 1)
    lazy var pageNumberObs = pageNumber.asObservable()
    
    // MARK: - Input
    let viewDidLoad
        = PublishRelay<Void>()
    let didChoosePhotoWithId
        = PublishRelay<String>()
    let willDisplayCellAtIndex
        = PublishRelay<Int>()
    let didEndDisplayingCellAtIndex
        = PublishRelay<Int>()
    let didScrollToTheBottom
        = PublishRelay<Void>()
    
    // MARK: - Output
    let isLoadingFirstPage
        = BehaviorRelay<Bool>(value: false)
    let isLoadingAdditionalPhotos
        = BehaviorRelay<Bool>(value: false)
    let facts
        = BehaviorRelay<[Fact]>(value: [])
    
   private let factsDetail = PublishRelay<FactDetail>()
    
    let navTitle = BehaviorRelay<String>(value: "")
    let imageRetrievedSuccess
        = PublishRelay<(UIImage, Int)>()
    let imageRetrievedError
        = PublishRelay<Int>()
    
    // MARK: - Initialization
    init(factsService: FactsService,
         factLoadingService: DataLoadingService,
         dataTofacTranformService: DataToImageTranformationService,
         coordinator: FactsCoordinator) {
        
        self.factsService = factsService
        self.factLoadingService = factLoadingService
        self.dataTofacTranformService = dataTofacTranformService
        self.coordinator = coordinator
        
        bindOnViewDidLoad()
        bindAfterDataRetrieval()
        bindOnWillDisplayCell()
    }
    
    // MARK: - Bindings


    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.getFacts()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnWillDisplayCell() {
        willDisplayCellAtIndex
            .customDebug(identifier: "willDisplayCellAtIndex")
            .filter({ [unowned self] index in
                self.facts.value.indices.contains(index)

            }).map { [unowned self] (index) -> (Int , Fact) in
                return (index, self.facts.value[index])
        }.compactMap {[weak self] (index, fact) ->(Int , String)? in
            guard let urlstring = fact.imageHref else{
                DispatchQueue.main.async {
                    self?.imageRetrievedError.accept(index)
                }
                return nil
            }
            return (index ,urlstring)
        }.flatMap({ [unowned self] (info) -> Observable<(Int, Data?, Error?)> in
          
            self.factLoadingService
                .loadData(at: info.0 , for:info.1 )
                .observeOn(
                    ConcurrentDispatchQueueScheduler(qos: .background)
            )
                .concatMap { (data, error) in
                    Observable.of((info.0, data, error))
            }
        })
            .subscribe(onNext: { [weak self] (index, data, error) in
                guard let self = self else { return }

                guard let imageData = data,
                    let image = self.dataTofacTranformService
                        .getImage(from: imageData) else {
                            self.imageRetrievedError.accept(index)
                            return
                }

                self.imageRetrievedSuccess
                    .accept((image, index))
            })
            .disposed(by: disposeBag)
    }
    
   
    private func bindAfterDataRetrieval() {
        // Bind to Title
        factsDetail.flatMap { (data) -> Observable<String> in
            return Observable.just(data.title)
        }.compactMap { $0 }
            .bind(to: navTitle)
            .disposed(by: disposeBag)
        
        // Bind to list
        factsDetail.flatMap { (data) -> Observable<[Fact]> in
            
            return Observable.just(data.rows.filter{($0.title != nil) && ($0.description != nil)})
        }.bind(to: facts)
         .disposed(by: disposeBag)
        
    }
    // MARK: - Service Methods
    private func getFacts() {
            
            factsService.getFacts()
                .compactMap({ (factsDetail, error) in
                    guard let detail = factsDetail, error == nil else {
                      
                        return nil
                    }
                    return detail
                })
                .bind(to: factsDetail)
                .disposed(by: disposeBag)
        }
    
}

