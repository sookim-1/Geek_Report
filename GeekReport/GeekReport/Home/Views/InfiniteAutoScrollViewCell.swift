//
//  InfiniteAutoScrollViewCell.swift
//  GeekReport
//
//  Created by sookim on 4/9/24.
//

import UIKit
import SnapKit
import Then

protocol InfiniteAutoScrollViewCellDelegate: AnyObject {
    func invalidateTimer()
}

final class InfiniteAutoScrollViewCell: UICollectionViewCell, UIConfigurable {
    
    static let reuseID = String(describing: InfiniteAutoScrollView.self)

    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }

    weak var delegate: InfiniteAutoScrollViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        self.contentView.addSubview(imageView)
    }

    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupProperties() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        delegate?.invalidateTimer()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension InfiniteAutoScrollViewCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
