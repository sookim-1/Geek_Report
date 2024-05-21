//
//  CustomTabBar.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomTabBar: UIStackView, UIConfigurable {

    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }

    private lazy var customItemViews: [CustomItemView] = [homeItem, searchItem, mylistItem, settingItem]

    private let homeItem = CustomItemView(with: .home, index: 0)
    private let searchItem = CustomItemView(with: .search, index: 1)
    private let mylistItem = CustomItemView(with: .mylist, index: 2)
    private let settingItem = CustomItemView(with: .setting, index: 3)

    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)

        setupHierarchy()
        setupProperties()
        bind()

        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        self.addArrangedSubviews(customItemViews)
    }

    func setupLayout() {

    }

    func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        backgroundColor = .systemIndigo
        layer.cornerRadius = 30
    }

    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = ($0.index == index) }
        itemTappedSubject.onNext(index)
    }

    private func bind() {
        homeItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.homeItem.animateClick {
                    self.selectItem(index: self.homeItem.index)
                }
            }
            .disposed(by: disposeBag)

        searchItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.searchItem.animateClick {
                    self.selectItem(index: self.searchItem.index)
                }
            }
            .disposed(by: disposeBag)

        mylistItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self 
                else { return }
                
                self.mylistItem.animateClick {
                    self.selectItem(index: self.mylistItem.index)
                }
            }
            .disposed(by: disposeBag)

        settingItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self
                else { return }
                
                self.settingItem.animateClick {
                    self.selectItem(index: self.settingItem.index)
                }
            }
            .disposed(by: disposeBag)
    }
}
