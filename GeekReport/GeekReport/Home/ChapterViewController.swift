//
//  ChapterViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then

final class ChapterViewController: BaseUIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.delegate = self
    }

    let sectionData: [ListItem] = ListItem.defaultData
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ListItem>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, ListItem>

    var datasource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDatasource()
        applySnapshot()
    }

    override func setupHierarchy() {
        view.addSubview(collectionView)
    }

    override func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setupProperties() {

    }

    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.headerMode = .firstItemInSection
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDatasource() {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, headerItem) in
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title
            if indexPath.row != 0 {
                content.textProperties.font = .preferredFont(forTextStyle: .callout)
                content.textProperties.color = .label
            }
            else {
                content.textProperties.font = .preferredFont(forTextStyle: .headline)
                cell.accessories = [.outlineDisclosure(options: UICellAccessory.OutlineDisclosureOptions(style: .header))]
            }
            cell.contentConfiguration = content

        }

        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, listItem) in
            var content = cell.defaultContentConfiguration()
            content.text = listItem.title
            content.textProperties.font = .preferredFont(forTextStyle: .callout)
            content.textProperties.color = .label
            cell.contentConfiguration = content
        }

        datasource = UICollectionViewDiffableDataSource<Int, ListItem>(collectionView: self.collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
        }
    }

    private func applySnapshot(animated: Bool = true) {
        var snapshot = SnapShot()
        let sections = [Int](0...sectionData.count)
        snapshot.appendSections(sections)

        datasource.apply(snapshot)

        sectionData.enumerated().forEach { index, item in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            sectionSnapshot.append([item])

            datasource.apply(sectionSnapshot, to: index, animatingDifferences: false)
        }
    }

}

// MARK: - UICollectionViewDelegate
extension ChapterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath)
        else { return }

        print(item.title)
    }

}
