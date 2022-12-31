//
//  MarketViewController.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/12/28.
//

import RxSwift

final class MarketViewController: UIViewController {
    private let viewModel: MarketViewModelable
    private let container: Container
    
    init(viewModel: MarketViewModelable, container: Container ) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let marketView = MarketView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        self.view = marketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        viewModel.getMarketOptions()
    }
    
    private func bindView() {
        buttonTextBind()
        marketView.categoryButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.touchOptionButton(buttonTag: owner.marketView.categoryButton.tag)
            }
            .disposed(by: disposeBag)
        
        marketView.classButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.touchOptionButton(buttonTag: owner.marketView.classButton.tag)
            }
            .disposed(by: disposeBag)
        
        marketView.gradeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.touchOptionButton(buttonTag: owner.marketView.gradeButton.tag)
            }
            .disposed(by: disposeBag)
        
        marketView.tierButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.touchOptionButton(buttonTag: owner.marketView.tierButton.tag)
            }
            .disposed(by: disposeBag)
        
        viewModel.showOptionsView
            .withUnretained(self)
            .bind { owner, optionType in
                switch optionType {
                case .category:
                    owner.marketView.showOptionView(view: owner.marketView.categoryOptionView)
                case .class, .grade, .tier:
                    owner.marketView.showOptionView(view: owner.marketView.subOptionsTableView)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.hideOptionView
            .withUnretained(self)
            .bind { owner, optionType in
                owner.hideOptionView(optionType)
            }
            .disposed(by: disposeBag)
        
        
        marketView.blurButtonView.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.touchBlurView()
            }
            .disposed(by: disposeBag)
        
        viewModel.categoryOptionList
            .bind(to: marketView.categoryOptionView.mainOptionTableView.rx.items(cellIdentifier: "\(OptionCell.self)", cellType: OptionCell.self)) { index, category, cell in
                cell.setCellContents(optionTitle: category.codeName ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.categorySubOptionList
            .bind(to: marketView.categoryOptionView.subOptionTableView.rx.items(cellIdentifier: "\(OptionCell.self)", cellType: OptionCell.self)) { index, category, cell in
                cell.setCellContents(optionTitle: category.codeName ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.subOptionList
            .bind(to: marketView.subOptionsTableView.rx.items(cellIdentifier: "\(OptionCell.self)", cellType: OptionCell.self)){ [weak self] index, title, cell in
                if title == self?.viewModel.selectedOptionText ?? "" {
                    cell.setSelectedCell()
                }
                cell.setCellContents(optionTitle: title)
            }
            .disposed(by: disposeBag)
        
        marketView.categoryOptionView.mainOptionTableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.viewModel.selectOptionCell(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        marketView.categoryOptionView.subOptionTableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.viewModel.selectCategorySubOption(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        marketView.subOptionsTableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.viewModel.selectOptionCell(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        marketView.itemSearchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { owner, _ in
                owner.touchSearchButton()
            }
            .disposed(by: disposeBag)
        
        marketView.searchButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.touchSearchButton()
            }
            .disposed(by: disposeBag)
    }

    private func buttonTextBind() {
        viewModel.categoryText
            .withUnretained(self)
            .bind { owner, text in
                owner.marketView.categoryButton.setTitle(text, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.classText
            .withUnretained(self)
            .bind { owner, text in
                owner.marketView.classButton.setTitle(text, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.gradeText
            .withUnretained(self)
            .bind { owner, text in
                owner.marketView.gradeButton.setTitle(text, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.tierText
            .withUnretained(self)
            .bind { owner, text in
                owner.marketView.tierButton.setTitle(text, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    private func hideOptionView(_ optionType: MarketViewModel.OptionType) {
        switch optionType {
        case .category:
            marketView.hideOptionView(view: marketView.categoryOptionView)
        case .class, .grade, .tier:
            marketView.hideOptionView(view: marketView.subOptionsTableView)
        }
    }
    
    private func touchSearchButton() {
        viewModel.touchSearchButton(itemName: marketView.itemSearchBar.text ?? "",
                                    category: marketView.categoryButton.titleLabel?.text ?? "",
                                    class: marketView.classButton.titleLabel?.text ?? "",
                                    grade: marketView.gradeButton.titleLabel?.text ?? "",
                                    tier: marketView.tierButton.titleLabel?.text ?? "")
    }
}
