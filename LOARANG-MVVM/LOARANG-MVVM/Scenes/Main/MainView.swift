//
//  MainView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/07/14.
//

import SnapKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainBackground
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Navigation StackView
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, searchButton])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "LOARANG"
        label.font = UIFont.BlackHanSans(size: 35)
        label.textColor = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        return label
    }()
    
    private(set) lazy var searchButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25, weight: .regular, scale: .default), forImageIn: .normal)

        return button
    }()
    
    //MARK: - Main ContentsView
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .tableViewColor
        
        return scrollView
    }()
    
    private lazy var mainContentsView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private(set) lazy var mainUserView = MainUserView()
    private(set) lazy var bookmarkView = BookmarkView()
    
    //MARK: - atc
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        indicator.stopAnimating()
        
        return indicator
    }()
    
    private func setLayout() {
        self.addSubview(titleStackView)
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(mainContentsView)
        mainContentsView.addSubview(mainUserView)
        mainContentsView.addSubview(bookmarkView)
        
        self.addSubview(activityIndicator)
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        title.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        mainContentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        mainUserView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        bookmarkView.snp.makeConstraints {
            $0.top.equalTo(mainUserView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 0.58)
            $0.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
