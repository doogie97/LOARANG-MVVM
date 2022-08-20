//
//  EquipmentDetailViewController.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/20.
//

import UIKit

final class EquipmentDetailViewController: UIViewController {
    private let viewModel: EquipmentDetailViewModelable
    
    init(viewModel:  EquipmentDetailViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let equipmentDetailView = EquipmentDetailView()
    
    override func loadView() {
        super.loadView()
        self.view = equipmentDetailView
    }
}