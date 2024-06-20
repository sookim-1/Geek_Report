//
//  SettingViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then

final class SettingViewController: BaseUIViewController {
    
    private lazy var completeLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "추후 업데이트 예정입니다 😅"
    }

    private lazy var loadingView = CustomLoadingView(colors: [.systemRed, .systemGreen, .systemBlue], lineWidth: 5)

    private var viewModel: SettingViewModel!

    init(viewModel: SettingViewModel) {
        super.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        setupProperties()
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.isLoad.value = false
        self.viewModel.viewWillAppear()
    }

    override func setupHierarchy() {
        self.view.addSubviews(completeLabel, loadingView)
        self.view.bringSubviewToFront(loadingView)
    }
    
    override func setupLayout() {
        completeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    override func setupProperties() {
    }

    private func bind(to viewModel: SettingViewModel) {
        viewModel.isLoad.observe(on: self) { [weak self] isComplete in
            AppLogger.log(tag: .success, "viewWillAppear 작업 완료")

            DispatchQueue.main.async {
                self?.completeLabel.isHidden = !isComplete
                self?.loadingView.isAnimating = !isComplete
            }
        }
    }

}
