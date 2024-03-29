//
//  UserInfoView.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/07/27.
//

import SnapKit
import GoogleMobileAds

final class UserInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.layer.opacity = 0
        view.backgroundColor = .mainBackground
        
        return view
    }()
    
    private lazy var navigationView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.one(size: 18, family: .Bold)
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
    
    private(set) lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.imageView?.tintColor = .white
        
        return button
    }()
    
    private(set) lazy var bookMarkButton: UIButton = {
        let button = UIButton()
        button.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    private(set) lazy var pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackground
        
        return view
    }()
    
    private(set) lazy var bannerView: GADBannerView = {
        let bannerView = adMobView
        bannerView.alpha = 0
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        return bannerView
    }()
    
    private(set) lazy var segmentControl: CustomSegmentControl = {
        let segmentControl = CustomSegmentControl(segmentTitles: ["기본 정보", "스킬", "보유캐릭터"])
        segmentControl.selectedFontColor = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        segmentControl.selectedFont = .one(size: 14, family: .Bold)
        segmentControl.deselectedFont = .one(size: 14, family: .Light)
        segmentControl.underLineColor = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        
        return segmentControl
    }()
    
    private(set) var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.stopAnimating()
        indicator.color = #colorLiteral(red: 1, green: 0.6752033234, blue: 0.5361486077, alpha: 1)
        
        return indicator
    }()
    
    private func setLayout() {
        self.backgroundColor = .mainBackground
        self.addSubview(contentsView)
        self.addSubview(bannerView)
        self.addSubview(activityIndicator)
        
        contentsView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bannerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(contentsView.snp.bottom)
            $0.height.equalTo(60)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentsView.addSubview(navigationView)
        
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        navigationView.addSubview(backButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(reloadButton)
        navigationView.addSubview(bookMarkButton)
        
        backButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(bookMarkButton.snp.leading)
            $0.width.equalTo(40)
        }
        
        bookMarkButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        contentsView.addSubview(segmentControl)
        contentsView.addSubview(separatorView)
        contentsView.addSubview(pageView)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).inset(-2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        pageView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewContents(_ userName: String?) {
        self.titleLabel.text = userName
    }
    
    func showContentsView() {
        UIView.transition(with: contentsView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.contentsView.layer.opacity = 1
            self?.bannerView.layer.opacity = 1
        }
    }
}

extension UserInfoView: GADBannerViewDelegate {
    func showBanner(isShow: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let contentsView = self?.contentsView,
                  let bannerView = self?.bannerView,
                  let safeAreaLayoutGuide = self?.safeAreaLayoutGuide else {
                return
            }
            if isShow {
                bannerView.snp.remakeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(safeAreaLayoutGuide)
                    $0.height.equalTo(60)
                }
                contentsView.snp.remakeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(bannerView.snp.top).inset(-8)
                }
            } else {
                bannerView.snp.remakeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalTo(contentsView.snp.bottom)
                    $0.height.equalTo(60)
                }
                
                contentsView.snp.remakeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview()
                }
            }
            
            self?.layoutIfNeeded()
        }
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        showBanner(isShow: true)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        showBanner(isShow: false)
    }
}
