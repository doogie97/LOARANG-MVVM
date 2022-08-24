//
//  SkillInfoView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/08/24.
//

import SnapKit

final class SkillInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var skillPointLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .one(size: 15, family: .Bold)
        
        return label
    }()
    
    private func setLayout() {
        self.backgroundColor = .mainBackground
        
        self.addSubview(skillPointLabel)
        
        skillPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    
    func setViewContents(skillPointString: String) {
        self.skillPointLabel.text = skillPointString
    }
}
