//
//  BookmarkCVCell.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/07/15.
//

import SnapKit
import RxSwift

final class BookmarkCVCell: UICollectionViewCell {
    private var viewModel: BookmarkCVCellViewModelable?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        
        return button
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.one(size: 15, family: .Bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private func setLayout() {
        self.backgroundColor = .cellColor
        self.layer.cornerRadius = 10
        self.contentView.addSubview(bookmarkButton)
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(nameLabel)
        
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalToSuperview().multipliedBy(0.2)
            $0.height.equalTo(bookmarkButton.snp.width)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).inset(10)
            $0.centerX.equalToSuperview()
            
            let height = UIScreen.main.bounds.width * 0.21
            $0.height.equalTo(height)
            $0.width.equalTo(userImageView.snp.height)
            userImageView.layer.cornerRadius = height / 2
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).inset(-5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview()
        }
        
        bind()
    }
    
    private func bind() {
        bookmarkButton.rx.tap.bind(onNext: {
            self.viewModel?.touchStarButton(self.nameLabel.text ?? "")
        })
        .disposed(by: disposeBag)
    }
    
    func setCell(_ info: BookmarkUser, viewModel: BookmarkCVCellViewModelable?) {
        self.viewModel = viewModel
        nameLabel.text = info.name
        userImageView.image = info.image.cropImage(class: info.class)
    }
}
