//
//  MarketViewModel.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/12/28.
//

import RxRelay

protocol MarketViewModelInput {
    func getMarketOptions()
    func touchOptionButton(buttonTag: Int)
    func selectOptionCell(_ index: Int)
    func selectCategorySubOption(mainIndex: Int, subIndex: Int)
    func touchBlurView()
    func touchSearchButton(itemName: String, `class`: String, grade: String)
    func viewDidAppear()
}

protocol MarketViewModelOutput {
    var categoryText: BehaviorRelay<String> { get }
    var classText: BehaviorRelay<String> { get }
    var gradeText: BehaviorRelay<String> { get }
    var categoryMainOptionIndex: Int { get }
    var categoryOptionList: BehaviorRelay<[MarketOptions.Category]> { get }
    var categorySubOptionList: BehaviorRelay<[MarketOptions.Category.Sub]> { get }
    var subOptionList: BehaviorRelay<[String]> { get }
    var selectedOptionText: String { get }
    var showOptionsView: PublishRelay<MarketViewModel.OptionType> { get }
    var hideOptionView: PublishRelay<MarketViewModel.OptionType> { get }
    var optionButtonActivation: BehaviorRelay<MarketView.ButtonType> { get }
    var showAlert: PublishRelay<String> { get }
}

protocol MarketViewModelable: MarketViewModelInput, MarketViewModelOutput {}

final class MarketViewModel: MarketViewModelable {
    private let networkManager: NetworkManagerable
    
    private var categories: [MarketOptions.Category] = []
    private var classes: [String] = ["전체 직업"]
    private var itemGrades: [String] = ["전체 등급"]
    private var selectedOptionType: OptionType = .category
    
    private var categorySubOptionIndex: Int?
    
    private var searchOption: SearchMarketItemsAPI.SearchOption?
    private var pageNo = 1
    
    init(networkManager: NetworkManagerable) {
        self.networkManager = networkManager
    }
    //MARK: - input
    func viewDidAppear() {
        getMarketOptions()
    }
    
    func getMarketOptions() {
        Task {
            do {
                let marketOptions = try await networkManager.request(MarketOptionsAPI(), resultType: MarketOptions.self)
                await MainActor.run {
                    categories = marketOptions.categories
                    categoryOptionList.accept(categories)
                    classes.append(contentsOf: marketOptions.classes)
                    itemGrades.append(contentsOf: marketOptions.itemGrades)
                }
            } catch let error {
                await MainActor.run {
                    showAlert.accept(error.limitErrorMessage ?? "거래소 옵션을 불러올 수 없습니다")
                }
            }
        }
    }
    
    func touchOptionButton(buttonTag: Int) {
        guard let optionType = OptionType(rawValue: buttonTag) else {
            return
        }
        
        self.selectedOptionType = optionType
        
        switch optionType {
        case .category:
            acceptCategorySubOption(categoryMainOptionIndex)
        case .class:
            subOptionList.accept(classes)
        case .grade:
            subOptionList.accept(itemGrades)
        }
        
        showOptionsView.accept(self.selectedOptionType)
    }
    
    func selectOptionCell(_ index: Int) {
        switch selectedOptionType {
        case .category:
            acceptCategorySubOption(index)
            return
        case .class:
            classText.accept(subOptionList.value[safe: index] ?? "")
        case .grade:
            gradeText.accept(subOptionList.value[safe: index] ?? "")
        }
        
        hideOptionView.accept(self.selectedOptionType)
    }
    
    func selectCategorySubOption(mainIndex: Int, subIndex: Int) {
        categoryMainOptionIndex = mainIndex
        categorySubOptionIndex = subIndex
        categoryText.accept(categoryCodeSet(index: subIndex).codeName)
        setButtonActivation(mainIndex)
        
        hideOptionView.accept(self.selectedOptionType)
    }
    
    func touchBlurView() {
        hideOptionView.accept(self.selectedOptionType)
    }
    
    func touchSearchButton(itemName: String, `class`: String, grade: String) {
        guard let categorySubOptionIndex = categorySubOptionIndex else {
            showAlert.accept("카테고리를 선택해주세요")
            return
        }
        
        if itemName.count < 2 {
            showAlert.accept("두 글자 이상 입력해주세요")
        }
        
        let categoryCode = categoryCodeSet(index: categorySubOptionIndex).code
        
        searchOption = SearchMarketItemsAPI.SearchOption(sort: .recentPrice,
                                                         categoryCode: categoryCode,
                                                         characterClass: `class` == "전체 직업" ? "" : `class`,
                                                         itemTier: 0,
                                                         itemGrade: grade == "전체 등급" ? "" : grade,
                                                         itemName: itemName,
                                                         pageNo: pageNo,
                                                         sortCondition: .asc)
        searchItem()
    }
    
    private func acceptCategorySubOption(_ index: Int) {
        let all = MarketOptions.Category.Sub(code: categories[safe: index]?.code,
                                             codeName: "전체")
        categorySubOptionList.accept([all] + (categories[safe: index]?.subs ?? []))
    }
    
    private func setButtonActivation(_ index: Int) {
        switch index {
        case 0, 9, 11, 12:
            optionButtonActivation.accept(.allInAcitve)
            classText.accept("전체 직업")
            gradeText.accept("전체 등급")
        case 1:
            optionButtonActivation.accept(.allActive)
        default:
            optionButtonActivation.accept(.gradeButtonActive)
            classText.accept("전체 직업")
        }
    }
    
    private func categoryCodeSet(index: Int) -> (code: Int, codeName: String) {
        let mainCategory = categories[safe: categoryMainOptionIndex]
        if index == 0 {
            return (code: mainCategory?.code ?? 0, codeName: (mainCategory?.codeName ?? "") + " - 전체")
        } else {
            let subCategory = mainCategory?.subs[safe: index - 1]
            return (code: subCategory?.code ?? 0,
                    codeName: (mainCategory?.codeName ?? "") + " - " + (subCategory?.codeName ?? ""))
        }
    }
    
    private func searchItem() {
        guard let searchOption = searchOption else {
            showAlert.accept("거래소 옵션을 다시 설정해 주세요")
            return
        }
        Task {
            do {
                let searchAPI = SearchMarketItemsAPI(searchOption: searchOption)
                let response = try await networkManager.request(searchAPI, resultType: MarketItems.self)
                await MainActor.run {
                    print(response)
                }
            } catch let error {
                await MainActor.run {
                    showAlert.accept(error.limitErrorMessage ?? "검색 중 오류가 발생했습니다(\(error.statusCode ?? 000))")
                }
            }
        }
    }
    
    //MARK: - output
    let categoryText = BehaviorRelay<String>(value: "카테고리를 선택해 주세요")
    let classText = BehaviorRelay<String>(value: "전체 직업")
    let gradeText = BehaviorRelay<String>(value: "전체 등급")
    let categoryOptionList = BehaviorRelay<[MarketOptions.Category]>(value: [])
    let categorySubOptionList = BehaviorRelay<[MarketOptions.Category.Sub]>(value: [])
    let subOptionList = BehaviorRelay<[String]>(value: [])
    let showOptionsView = PublishRelay<OptionType>()
    let hideOptionView = PublishRelay<OptionType>()
    var categoryMainOptionIndex = 0
    let optionButtonActivation = BehaviorRelay<MarketView.ButtonType>(value: (.allActive))
    let showAlert = PublishRelay<String>()
    
    var selectedOptionText: String {
        switch selectedOptionType {
        case .category:
            guard let subOptionText = categoryText.value.components(separatedBy: " - ")[safe: 1] else {
                return ""
            }
            return subOptionText
        case .class:
            return classText.value
        case .grade:
            return gradeText.value
        }
    }
}

extension MarketViewModel {
    enum OptionType: Int {
        case category = 0
        case `class`
        case grade
    }
}
