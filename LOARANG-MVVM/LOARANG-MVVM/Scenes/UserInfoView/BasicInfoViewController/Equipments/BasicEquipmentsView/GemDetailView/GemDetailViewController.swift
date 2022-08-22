//
//  GemDetailViewController.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/22.
//

import UIKit

final class GemDetailViewController: UIViewController {
    private let viewModel: GemDetailViewModelable
    
    init(viewModel: GemDetailViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let gemDetailView = GemDetailView()
    
    override func loadView() {
        super.loadView()
        self.view = gemDetailView
    }
}
