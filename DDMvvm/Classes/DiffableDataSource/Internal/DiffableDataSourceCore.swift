import Foundation
import QuartzCore
import DifferenceKit

extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}

protocol Reloadable where Self: UIView {
    func reload()
}

extension UITableView: Reloadable {
    func reload() { reloadData() }
}

extension UICollectionView: Reloadable {
    func reload() { reloadData() }
}

final class DiffableDataSourceCore<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    typealias Section = SnapshotStructure<SectionIdentifierType, ItemIdentifierType>.Section

    private let dispatcher = MainThreadSerialDispatcher()
    private var currentSnapshot = DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
    private var sections: [Section] = []

    func apply<View: Reloadable>(
        _ snapshot: DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        view: View?,
        animatingDifferences: Bool,
        performUpdates: @escaping (View, StagedChangeset<[Section]>, @escaping ([Section]) -> Void) -> Void,
        completion: (() -> Void)?
    ) {
        dispatcher.dispatch { [weak self] in
            guard let self = self else {
                return
            }

            self.currentSnapshot = snapshot

            let newSections = snapshot.structure.sections

            guard let view = view else {
                return self.sections = newSections
            }

            let changeset = StagedChangeset(source: self.sections, target: newSections)
            
            func performDiffingUpdates() {
                performUpdates(view, changeset) { sections in
                    self.sections = sections
                }
            }
            
            if animatingDifferences {
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                performDiffingUpdates()
                CATransaction.commit()
            } else {
                if let data = changeset.last?.data {
                    self.sections = data
                }
                view.reload()
                completion?()
            }
        }
    }

    func snapshot() -> DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        var snapshot = DiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        snapshot.structure.sections = currentSnapshot.structure.sections
        return snapshot
    }

    func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType? {
        guard 0..<sections.endIndex ~= indexPath.section else {
            return nil
        }
        
        guard let items = sections[safe: indexPath.section]?.elements, 0..<items.endIndex ~= indexPath.item else {
            return nil
        }

        return items[safe: indexPath.item]?.differenceIdentifier
    }

    func unsafeItemIdentifier(for indexPath: IndexPath, file: StaticString = #file, line: UInt = #line) -> ItemIdentifierType {
        guard let itemIdentifier = itemIdentifier(for: indexPath) else {
            universalError("Item not found at the specified index path(\(indexPath)).")
        }

        return itemIdentifier
    }

    func indexPath(for itemIdentifier: ItemIdentifierType) -> IndexPath? {
        let indexPathMap: [ItemIdentifierType: IndexPath] = sections.enumerated()
            .reduce(into: [:]) { result, section in
                for (itemIndex, item) in section.element.elements.enumerated() {
                    result[item.differenceIdentifier] = IndexPath(
                        item: itemIndex,
                        section: section.offset
                    )
                }
        }
        return indexPathMap[itemIdentifier]
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        return sections[safe: section]?.elements.count ?? 0
    }
}
