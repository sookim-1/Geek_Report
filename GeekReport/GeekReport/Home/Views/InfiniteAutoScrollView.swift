//
//  InfiniteAutoScrollView.swift
//  GeekReport
//
//  Created by sookim on 4/9/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

protocol InfiniteAutoScrollViewDelegate: AnyObject {
    func didTapItem(_ collectionView: UICollectionView, selectedItem item:Int)
}

final class InfiniteAutoScrollView: BaseUIView {

    weak var delegate: InfiniteAutoScrollViewDelegate?
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(InfiniteAutoScrollViewCell.self, forCellWithReuseIdentifier: InfiniteAutoScrollViewCell.reuseID)
        $0.showsHorizontalScrollIndicator = false
    }

    var pageControl: UIPageControl!
    var autoScrollTimer: Timer!
    var currentAutoScrollIndex = 1
   
    var contentArray = [AnimeData]() {
        didSet {
            if contentArray.count > 1 {
                contentArray.insert(contentArray.last!, at: 0)
                contentArray.append(contentArray[1])
            }
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)

            addPageControl()
        }
    }

    var timeInterval = 2.0


    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func setupHierarchy() {
        addSubviews(collectionView)
    }

    override func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setupProperties() {
        addPageControl()
    }

    func addPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: self.frame.origin.x,
                                                  y: self.collectionView.frame.origin.y + self.frame.height,
                                                  width: self.frame.size.width,
                                                  height: 40.0))
        pageControl.numberOfPages = contentArray.count - 2
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
        addSubview(pageControl)
    }


    @objc func changePage(_ sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(item: sender.currentPage + 1, section: 0), at: .left, animated: true)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createHorizontalScrollLayoutSection()
        }
    }
    
    func createHorizontalScrollLayoutSection() -> NSCollectionLayoutSection {
        let itemInset = 5.0
        let sectionMargin = 15.0

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemInset, bottom: 0, trailing: itemInset)
        
        // Group
        let pageWidth = collectionView.bounds.width - sectionMargin * 2
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(pageWidth)), heightDimension: .estimated(self.frame.height))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        layoutSection.visibleItemsInvalidationHandler = { visibleItems, point, environment in
            if var page = Int(exactly: (point.x + sectionMargin) / pageWidth) {
                let maxIndex = self.contentArray.indices.max()!
                self.currentAutoScrollIndex = page

                if page == maxIndex {
                    page = 1
                    self.currentAutoScrollIndex = page
                } else if page == 0 {
                    page = maxIndex - 1
                    self.currentAutoScrollIndex = page
                }

                let realPage = page - 1

                if self.pageControl.currentPage != realPage {
                    self.pageControl.currentPage = realPage
                    self.collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .left, animated: false)
                }
                
                self.configAutoScroll()
            }
        }
        
        return layoutSection
    }
}

// MARK: - Auto Scroll Methods
extension InfiniteAutoScrollView {
    
    func configAutoScroll() {
        resetAutoScrollTimer()
        if contentArray.count > 1 {
            setupAutoScrollTimer()
        }
    }
    
    func resetAutoScrollTimer() {
        if autoScrollTimer != nil {
            autoScrollTimer.invalidate()
            autoScrollTimer = nil
        }
    }
    
    func setupAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction(timer:)), userInfo: nil, repeats: true)
        RunLoop.main.add(autoScrollTimer, forMode: RunLoop.Mode.common)
    }

    @objc func autoScrollAction(timer: Timer) {
        currentAutoScrollIndex += 1
        if currentAutoScrollIndex >= contentArray.count {
            currentAutoScrollIndex = currentAutoScrollIndex % contentArray.count
        }

        collectionView.scrollToItem(at: IndexPath(item: currentAutoScrollIndex, section: 0), at: .left, animated: true)
    }

}

// MARK: - InfiniteAutoScrollViewCellDelegate
extension InfiniteAutoScrollView: InfiniteAutoScrollViewCellDelegate {
    
    func invalidateTimer() {
        if autoScrollTimer != nil {
            autoScrollTimer.invalidate()
            autoScrollTimer = nil
        }
    }
}

// MARK: - UICollectionViewDataSource
extension InfiniteAutoScrollView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfiniteAutoScrollViewCell.reuseID, for: indexPath) as! InfiniteAutoScrollViewCell

        let content = contentArray[indexPath.item]
        
        cell.imageView.kf.setImage(with: URL(string: content.images.jpgURLs.imageURL))
        cell.delegate = self
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension InfiniteAutoScrollView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapItem(collectionView, selectedItem: indexPath.item)
    }

}

