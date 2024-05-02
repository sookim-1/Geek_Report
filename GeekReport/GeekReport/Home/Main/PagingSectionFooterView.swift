//
//  PagingSectionFooterView.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

struct PagingInfo: Equatable, Hashable {
    let currentPage: Int
}

protocol PagerDelegate: AnyObject {
    func didValueChanged(indexPath: IndexPath, scrollPosition: UICollectionView.ScrollPosition)
}

final class PagingSectionFooterView: UICollectionReusableView {

    private lazy var pageControl = UIPageControl().then {
        $0.isUserInteractionEnabled = true
        $0.currentPageIndicatorTintColor = .systemOrange
        $0.pageIndicatorTintColor = .systemGray5
    }

    private var pagingInfoToken: Disposable?
    private var pageControlGesture: Disposable?
    var delegate: PagerDelegate?
    var indexPath: IndexPath!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pagingInfoToken?.dispose()
        pagingInfoToken = nil

        pageControlGesture?.dispose()
        pageControlGesture = nil
    }

    func configure(numberOfPages: Int, indexPath: IndexPath, delegate: PagerDelegate?) {
        self.indexPath = indexPath
        self.delegate = delegate
        pageControl.numberOfPages = numberOfPages
    }

    func subscribeTo(subject: PublishSubject<PagingInfo>, for section: Int) {
        pagingInfoToken = subject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pagingInfo in
                self?.pageControl.currentPage = pagingInfo.currentPage
            }
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.pageControlGesture = pageControl.rx
            .controlEvent(.valueChanged)
            .bind { [weak self] _ in
                guard let self
                else { return }

                delegate?.didValueChanged(indexPath: IndexPath(item: self.pageControl.currentPage, section: indexPath.section), scrollPosition: .centeredHorizontally)
            }
    }

}
