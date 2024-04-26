//
//  AnimeDetailViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then

final class AnimeDetailViewController: BaseUIViewController {

    let customSegmentedControlProperty = CustomSegmentedControlProperty(currentIndex: 0, segmentsTitleLists: ["에피소드", "상세내용", "옵션"])
    lazy var chapterSegmentedControl = CustomSegmentedControl(property: self.customSegmentedControlProperty)

    var item: ItemModel!

    init(item: ItemModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.view.addSubviews(chapterSegmentedControl)
        self.chapterSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        print("refresh \(item)")
    }

}
