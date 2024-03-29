//
//  EquipmentDetailView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/20.
//

import SnapKit

final class EquipmentDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return button
    }()
    
    private lazy var nameLabel = makeLabel(alignment: .center, font: .one(size: 20, family: .Bold))
    
    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    private lazy var detailScrollView = UIScrollView()
    
    private lazy var equipmentContentsView = UIView()
    
    private lazy var equipmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    private lazy var partNameLabel = makeLabel(alignment: .left, font: .one(size: 15, family: .Bold))
    
    private lazy var itemLvLabel = makeLabel(alignment: .left, font: .one(size: 18, family: .Bold))
    
    private lazy var qualityLabel = makeLabel(alignment: .left, font: .one(size: 15, family: .Bold))
    
    private lazy var qualityProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .lightGray
        progressView.progressViewStyle = .bar
        
        return progressView
    }()
    private lazy var effetcTextView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 0
        
        return textView
    }()
    
    private func makeLabel(alignment: NSTextAlignment, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textAlignment = alignment
        label.font = font
        
        return label
    }
    
    private func setLayout() {
        self.backgroundColor = .mainBackground
        
        self.addSubview(closeButton)
        self.addSubview(nameLabel)
        self.addSubview(underline)
        self.addSubview(detailScrollView)
        
        detailScrollView.addSubview(equipmentContentsView)
        
        equipmentContentsView.addSubview(equipmentImageView)
        equipmentContentsView.addSubview(partNameLabel)
        equipmentContentsView.addSubview(itemLvLabel)
        equipmentContentsView.addSubview(qualityLabel)
        equipmentContentsView.addSubview(qualityProgressView)
        equipmentContentsView.addSubview(effetcTextView)
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
            $0.centerY.equalTo(nameLabel)
            $0.height.width.equalTo(30)
        }
     
        nameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        underline.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(nameLabel.snp.bottom).inset(-15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        detailScrollView.snp.makeConstraints {
            $0.top.equalTo(underline.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        equipmentContentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        equipmentImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalToSuperview().multipliedBy(0.15)
            $0.height.equalTo(equipmentImageView.snp.width)
        }
        
        partNameLabel.snp.makeConstraints {
            $0.leading.equalTo(equipmentImageView.snp.trailing).inset(-15)
            $0.top.equalTo(equipmentImageView.snp.top)
        }
        
        itemLvLabel.snp.makeConstraints {
            $0.leading.equalTo(equipmentImageView.snp.trailing).inset(-15)
            $0.centerY.equalTo(equipmentImageView.snp.centerY)
        }
        
        qualityLabel.snp.makeConstraints {
            $0.leading.equalTo(equipmentImageView.snp.trailing).inset(-15)
            $0.bottom.equalTo(equipmentImageView.snp.bottom)
        }
        
        qualityProgressView.snp.makeConstraints {
            $0.top.equalTo(qualityLabel.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(equipmentImageView).multipliedBy(0.35)
        }
        
        effetcTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.top.equalTo(qualityProgressView.snp.bottom).inset(-16)
        }
    }
    
    func setViewContents(_ equipmentInfo: EquipmentPart) {
        setLayout()
        
        nameLabel.text = equipmentInfo.basicInfo.name?.htmlToString
        nameLabel.textColor = Equips.Grade(rawValue: equipmentInfo.basicInfo.grade ?? 0)?.textColor
        
        let _ = equipmentImageView.setImage(urlString: equipmentInfo.basicInfo.imageURL)
        equipmentImageView.backgroundColor = Equips.Grade(rawValue: equipmentInfo.basicInfo.grade ?? 0)?.backgroundColor
        
        partNameLabel.text = equipmentInfo.basicInfo.part?.htmlToString
        partNameLabel.textColor = Equips.Grade(rawValue: equipmentInfo.basicInfo.grade ?? 0)?.textColor
        
        itemLvLabel.text = equipmentInfo.basicInfo.lv?.htmlToString
        
        let quality = equipmentInfo.basicInfo.quality == -1 ? 0 : equipmentInfo.basicInfo.quality ?? 0
        qualityLabel.text = "품질 \(quality)"
        
        qualityProgressView.progressTintColor = quality.qualityColor
        qualityProgressView.progress = Float(quality)/100
        
        effetcTextView.attributedText = equipmentInfo.battleEffects?.htmlToAttributedString(fontSize: 5)
    }
    
    func hideQuality() {
        qualityLabel.isHidden = true
        qualityProgressView.isHidden = true
    }
}
