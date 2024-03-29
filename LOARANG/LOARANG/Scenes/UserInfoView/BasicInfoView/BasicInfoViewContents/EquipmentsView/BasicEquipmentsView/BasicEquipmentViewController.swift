//
//  BasicEquipmentViewController.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/11.
//

import RxSwift
import RxGesture

final class BasicEquipmentViewController: UIViewController {
    private let viewModel: BasicEquipmentViewModelable
    private let container: Container
    
    init(viewModel: BasicEquipmentViewModelable, container: Container) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let basicEquipmentView = BasicEquipmentView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        self.view = basicEquipmentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        basicEquipmentView.equipmentTableView.dataSource = self
        basicEquipmentView.equipmentTableView.delegate = self
        basicEquipmentView.accessoryTableView.dataSource = self
        basicEquipmentView.accessoryTableView.delegate = self
        
        viewModel.equips
            .bind(onNext: { [weak self] in
                self?.basicEquipmentView.setLayout(isNoGem: $0?.gems.count == 0)
                self?.basicEquipmentView.equipmentTableView.reloadData()
                self?.basicEquipmentView.accessoryTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.showEquipmentDetail
            .bind(onNext: { [weak self] in
                guard let equipmentInfo = $0 else {
                    return
                }
                
                guard let equipmentDetailVC = self?.container.makeEquipmentDetailViewController(equipmentInfo: equipmentInfo) else {
                    return
                }
                
                self?.present(equipmentDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
            viewModel.gems
                .bind(to: basicEquipmentView.gemCollectionView.rx.items(cellIdentifier: "\(GemCell.self)", cellType: GemCell.self)) { index, gem, cell in
                    cell.setCellContents(gem: gem)
                }
                .disposed(by: disposeBag)
        
        basicEquipmentView.gemCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] in
                self?.viewModel.touchGemCell($0.row)
            })
            .disposed(by: disposeBag)
        
        viewModel.showGemDetail
            .bind(onNext: { [weak self] in
                self?.basicEquipmentView.showGemDetail(gem: $0)
            })
            .disposed(by: disposeBag)
        
        basicEquipmentView.gemDetailView.rx.tapGesture()
            .bind(onNext: { [weak self] _ in
                self?.basicEquipmentView.gemDetailView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}

extension BasicEquipmentViewController: UITableViewDataSource {
    enum EquipmentPartType: Int {
        case head, shoulder, top, bottom, glove, weapon, engraves
        
        var partString: String {
            switch self {
            case .head:
                return "머리 방어구"
            case .shoulder:
                return "어깨 방어구"
            case .top:
                return "상의"
            case .bottom:
                return "하의"
            case .glove:
                return "장갑"
            case .weapon:
                return "무기"
            case .engraves:
                return ""
            }
        }
    }
    
    enum AccessoryPartType: Int {
        case necklace, firstEarring, secondEarring, firstRing, secondRing, bracelet, abilityStone
        
        var partString: String {
            switch self {
            case .necklace:
                return "목걸이"
            case .firstEarring, .secondEarring:
                return "귀걸이"
            case .firstRing, .secondRing:
                return "반지"
            case .bracelet:
                return "팔찌"
            case .abilityStone:
                return "어빌리티 스톤"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == basicEquipmentView.equipmentTableView {
            return viewModel.battleEquips.count == 0 ? 0 : viewModel.battleEquips.count + 1
        }
        
        if tableView == basicEquipmentView.accessoryTableView {
            return viewModel.accessories.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == basicEquipmentView.equipmentTableView, indexPath.row == EquipmentPartType.engraves.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(EquipmentEngraveCell.self)", for: indexPath) as? EquipmentEngraveCell else { return UITableViewCell() }
            cell.setCellContents(engraves: viewModel.engraves)
            
            return cell
        }
        
        var info: (equipments: EquipmentPart?, pratString: String?) {
            if tableView == basicEquipmentView.equipmentTableView {
                return (viewModel.battleEquips[indexPath.row],
                        EquipmentPartType(rawValue: indexPath.row)?.partString)
            }
            if tableView == basicEquipmentView.accessoryTableView {
                return (viewModel.accessories[indexPath.row],
                        AccessoryPartType(rawValue: indexPath.row)?.partString)
            }
            
            return (nil, nil)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(EquipmentCell.self)", for: indexPath) as? EquipmentCell else { return UITableViewCell() }
        
        cell.setCellContents(equipmentPart: info.equipments,
                             partString: info.pratString,
                             backColor: Equips.Grade(rawValue: info.equipments?.basicInfo.grade ?? 0)?.backgroundColor)
        
        return cell
    }
}

extension BasicEquipmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == basicEquipmentView.equipmentTableView, indexPath.row != EquipmentPartType.engraves.rawValue {
            viewModel.touchBattleEquipmentCell(indexPath.row)
        }
        
        if tableView == basicEquipmentView.accessoryTableView {
            viewModel.touchAccessaryCell(indexPath.row)
        }
    }
}
