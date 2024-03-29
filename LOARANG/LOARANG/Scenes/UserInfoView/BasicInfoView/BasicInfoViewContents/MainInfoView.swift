//
//  MainInfoView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/31.
//

import SnapKit

final class MainInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainFontSize = 13
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var classLabel = makeLabel(size: mainFontSize, alignment: .center)
    
    private lazy var serverNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.one(size: 16, family: .Bold)
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemPVPStackView,
                                                       expeditionBattleLvStackView,
                                                       titleLabel,
                                                       guildLabel,
                                                       wisdomLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var itemPVPStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemLvLabel, pvpLabel])
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var itemLvLabel = makeLabel(size: mainFontSize, alignment: .left)
    private lazy var pvpLabel = makeLabel(size: mainFontSize, alignment: .left)
    
    private lazy var expeditionBattleLvStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [expeditionLvLabel, battleLvLabel])
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var expeditionLvLabel = makeLabel(size: mainFontSize, alignment: .left)
    private lazy var battleLvLabel = makeLabel(size: mainFontSize, alignment: .left)
    
    private lazy var titleLabel = makeLabel(size: mainFontSize, alignment: .left)
    private lazy var guildLabel = makeLabel(size: mainFontSize, alignment: .left)
    private lazy var wisdomLabel = makeLabel(size: mainFontSize, alignment: .left)
    
    private func makeLabel(size: Int, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = UIFont.one(size: size, family: .Bold)
        label.textAlignment = alignment
        label.textColor = .label
        
        return label
    }
    
    private func setLayout() {
        self.backgroundColor = .cellColor
        self.layer.cornerRadius = 10
        
        self.addSubview(userImageView)
        self.addSubview(classLabel)
        self.addSubview(serverNameLabel)
        self.addSubview(userInfoStackView)
        
        userImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            
            let height = UIScreen.main.bounds.width * 0.25
            $0.height.equalTo(height)
            $0.width.equalTo(userImageView.snp.height)
            userImageView.layer.cornerRadius = height / 2
        }
        
        classLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).inset(-5)
            $0.bottom.equalToSuperview().inset(5)
            $0.centerX.equalTo(userImageView)
        }
        
        serverNameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView).inset(8)
            $0.leading.equalTo(userImageView.snp.trailing).inset(-8)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(serverNameLabel.snp.bottom).inset(-8)
            $0.leading.equalTo(userImageView.snp.trailing).inset(-8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setViewContents(_ mainInfo: MainInfo) {
        setLayout()
        
        classLabel.text = mainInfo.`class`
        serverNameLabel.text = "\(mainInfo.server) \(mainInfo.name)"
        itemLvLabel.text = "아이템 : \(mainInfo.itemLV)"
        pvpLabel.text = "PVP : \(mainInfo.pvp)"
        expeditionLvLabel.text = "원정대 : \(mainInfo.expeditionLV)"
        battleLvLabel.text = "전투 레벨 : \(mainInfo.battleLV)"
        titleLabel.text = "칭호 : \(mainInfo.title)"
        guildLabel.text = "길드 : \(mainInfo.guild)"
        wisdomLabel.text = "영지 : \(mainInfo.wisdom)"
        userImageView.image = mainInfo.userImage.cropImage(class: mainInfo.`class`)
    }
}
