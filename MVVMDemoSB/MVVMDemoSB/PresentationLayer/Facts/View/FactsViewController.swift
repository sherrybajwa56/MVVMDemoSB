//
//  ViewController.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FactsViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindCollectionView()
        bindLoadingState()
        viewModel.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNavigationItem()
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel: FactsViewModel!
    private var cachedImages: [Int: UIImage] = [:]
    
    lazy var factsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
}

// MARK: - Binding
extension FactsViewController {
    private func bindCollectionView() {
        /// Bind facts to the table view items
        viewModel.facts
            .bind(to: factsTableView.rx.items(
                cellIdentifier: FactCell.reuseIdentifier,
                cellType: FactCell.self)) {row, model, cell in
                cell.lableDescription.text = model.description
                cell.title.text = model.title
    }
            .disposed(by: disposeBag)
        
//        /// Prepare for cell to be displayed. Launch photo loading operation if no cached image is found
        factsTableView.rx.willDisplayCell.filter{$0.cell.isKind(of: FactCell.self)}
            .map{($0.cell as!FactCell ,$0.indexPath.row) }
            .do(onNext: { (cell, index) in
                 cell.imageView2.image = nil
            })
            .subscribe(onNext: { [weak self] (cell, index) in
                if let cachedImage = self?.cachedImages[index] {
                    print("Using cached image for: \(index)")
                    cell.imageView2.image = cachedImage
                } else {
                    self?.viewModel
                        .willDisplayCellAtIndex
                        .accept(index)
                }
            })
            .disposed(by: disposeBag)
        
        /// On image retrival, 1) assign the image, and 2) add it to cached images
        viewModel.imageRetrievedSuccess
            .customDebug(identifier: "imageRetrievedSuccess")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (image, index) in
                if let cell = self?.factsTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? FactCell {
                   
                    cell.imageView2.image = image
                    
              
                    self?.cachedImages[index] = image
                }
            })
            .disposed(by: disposeBag)
        
        /// On image retrieval error, stop activity indicator, and assign image to **nil**
        viewModel.imageRetrievedError
            .customDebug(identifier: "imageRetrievedError")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (index) in
                if let cell = self?.factsTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? FactCell {
                    cell.imageView2.image = nil
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindLoadingState() {
        viewModel.navTitle
            .observeOn(MainScheduler.instance)
            .map({ (title) in
                return title
            })
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UI Setup
extension FactsViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        factsTableView.estimatedRowHeight = 100
        factsTableView.rowHeight = UITableView.automaticDimension
        factsTableView.tableFooterView = UIView(frame: .zero)
        
        view.addSubview(factsTableView)
        NSLayoutConstraint.activate([
              factsTableView.topAnchor.constraint(equalTo: view.topAnchor),
              factsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              factsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              factsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
              )
        
    }
    
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "loading.."
    }
    
}

