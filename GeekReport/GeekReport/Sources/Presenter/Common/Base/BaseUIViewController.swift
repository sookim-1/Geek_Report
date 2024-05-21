//
//  BaseUIViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import RxSwift

class BaseUIViewController: UIViewController, UIConfigurable {

    var disposeBag = DisposeBag()

    private var indicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }

    func setupHierarchy() {}
    func setupLayout() {}
    func setupProperties() {}

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

}

extension BaseUIViewController {

    func showFullSizeIndicator() {
        let indicator = createIndicator()
        self.indicator = indicator

        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }

        indicator.startAnimating()
    }

    func hideFullSizeIndicator() {
        self.indicator?.stopAnimating()
        self.indicator?.removeFromSuperview()
        self.indicator = nil
    }

    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)

        indicator.backgroundColor = .black.withAlphaComponent(0.7)
        indicator.color = .white
        indicator.layer.cornerRadius = 20
        return indicator
    }

}
