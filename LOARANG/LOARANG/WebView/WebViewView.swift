//
//  WebViewView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/09/22.
//

import SnapKit
import WebKit

final class WebViewView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var navigationView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.one(size: 15, family: .Bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .buttonColor
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)

        return button
    }()
    
    private(set) lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    private(set) var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.stopAnimating()
        indicator.color = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        
        return indicator
    }()

    private func setLayout() {
        self.backgroundColor = .mainBackground
        self.addSubview(navigationView)
        self.addSubview(webView)
        self.addSubview(activityIndicator)
        
        navigationView.addSubview(backButton)
        navigationView.addSubview(titleLabel)
        
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        backButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(webView)
        }
    }
    
    func setViewContents(url: URLRequest, title: String) {
        webView.load(url)
        titleLabel.text = title
    }
}
