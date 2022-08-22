//
//  Container.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/07/15.
//

import UIKit

final class Container {
    private let storage: AppStorageable
    private let crawlManager: CrawlManagerable
    
    init(storage: AppStorageable, crawlManager: CrawlManagerable) {
        self.storage = storage
        self.crawlManager = crawlManager
    }
//MARK: - about Main View
    func makeMainViewController() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel(), container: self)
    }
    
    private func makeMainViewModel() -> MainViewModel {
        return MainViewModel(storage: storage, crawlManager: crawlManager)
    }

    func makeBookmarkTVCellViewModel(delegate: TouchBookmarkCellDelegate) -> BookmarkTVCellViewModel {
        return BookmarkTVCellViewModel(storage: storage, delegate: delegate)
    }
    
    func makeBookmarkCVCellViewModel() -> BookmarkCVCellViewModelable {
        return BookmarkCVCellViewModel(storage: storage)
    }
    
//MARK: - about searchView
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel(), container: self)
    }
    
    private func makeSearchViewModel() -> SearchViewModelable {
        return SearchViewModel(crawlManager: crawlManager)
    }
    
//MARK: - about UserInfoView
    func makeUserInfoViewController(_ userInfo: UserInfo) -> UserInfoViewController {
        return UserInfoViewController(viewModel: makeUserInfoViewModel(userInfo),
                                      viewList: [makeBasicInfoVC(userInfo: userInfo),
                                                 makeSecondVC(),
                                                 makeThirdVC(),
                                                 makeFourthVC()])
    }
    
    private func makeUserInfoViewModel(_ userInfo: UserInfo) -> UserInfoViewModelable {
        return UserInfoViewModel(storage: storage, userInfo: userInfo)
    }
    //MARK: - about BasicInfoView
    private func makeBasicInfoVC(userInfo: UserInfo) -> BasicInfoViewController {
        return BasicInfoViewController(container: self,
                                       viewModel: makeBasicInfoViewModel(userInfo: userInfo))
    }
    
    private func makeBasicInfoViewModel(userInfo: UserInfo) -> BasicInfoViewModelable {
        return BasicInfoViewModel(userInfo: userInfo)
    }
    
    private func makeSecondVC() -> SecondInfoViewController {
        return SecondInfoViewController()
    }
    
    private func makeThirdVC() -> ThirdInfoViewController {
        return ThirdInfoViewController()
    }
    
    private func makeFourthVC() -> FourthInfoViewController {
        return FourthInfoViewController()
    }
    //MARK: - about Equipments
    func makeEquipmentsTVCellViewModel(userInfo: UserInfo) -> EquipmentsTVCellViewModelable {
        return EquipmentsTVCellViewModel(
            userInfo: userInfo,
            pageViewList: [makeBasicEquipmentViewController(equipments: userInfo.equips.equipments),
                           makeAvatarViewController(equipments: userInfo.equips.equipments),
                           makeCharacterImageViewController(userImage: userInfo.mainInfo.userImage)]
        )
    }
    
    private func makeBasicEquipmentViewController(equipments: Equipments) -> BasicEquipmentViewController {
        return BasicEquipmentViewController(viewModel: makeBasicEquipmentViewModel(equipments: equipments), container: self)
    }
    
    private func makeBasicEquipmentViewModel(equipments: Equipments) -> BasicEquipmentViewModelable {
        return BasicEquipmentViewModel(equipments: equipments)
    }
    
    func makeEquipmentDetailViewController(equipmentInfo: EquipmentPart) -> EquipmentDetailViewController {
        let detailVC = EquipmentDetailViewController(viewModel: makeEquipmentDetailViewModel(equipmentInfo: equipmentInfo))
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .crossDissolve
        return detailVC
    }
    
    private func makeEquipmentDetailViewModel(equipmentInfo: EquipmentPart) -> EquipmentDetailViewModelable {
        return EquipmentDetailViewModel(equipmentInfo: equipmentInfo)
    }
    
    private func makeAvatarViewController(equipments: Equipments) -> AvatarViewController {
        return AvatarViewController(viewModel: makeAvatarViewModel(equipments: equipments), container: self)
    }
    
    private func makeAvatarViewModel(equipments: Equipments) -> AvatarViewModelable {
        return AvatarViewModel(equipments: equipments)
    }
    
    private func makeCharacterImageViewController(userImage: UIImage) -> CharacterImageViewController {
        return CharacterImageViewController(viewModel: makeCharacterImageViewModel(userImage: userImage))
    }
    
    private func makeCharacterImageViewModel(userImage: UIImage) -> CharacterImageViewModelable {
        return CharacterImageViewModel(userImage: userImage)
    }
    
    //MARK: - about settingVIew
    func makeSettingViewModel() -> SettingViewModelable {
        return SettingViewModel(storage: storage, crawlManger: crawlManager)
    }
}
