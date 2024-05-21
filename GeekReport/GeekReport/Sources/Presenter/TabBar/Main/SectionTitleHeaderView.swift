//
//  SectionTitleHeaderView.swift
//  GeekReport
//
//  Created by sookim on 4/28/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SectionTitleHeaderView: UICollectionReusableView, UIConfigurable {
    
    lazy var sectionTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.textColor = .white
    }
    
    lazy var moreButton = UIButton().then {
        $0.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.circle"), for: .normal)
        $0.tintColor = .white
    }

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    func setupHierarchy() {
        self.addSubviews(sectionTitleLabel, moreButton)
    }
    
    func setupLayout() {
        sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
    
    func setupProperties() {
    }
    
}
