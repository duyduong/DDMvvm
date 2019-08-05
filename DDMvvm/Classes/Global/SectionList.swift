//
//  SectionList.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public enum ChangeSet {
    case deleteSection(section: Int, animated: Bool)
    case insertSection(section: Int, animated: Bool)
    case deleteElements(indexPaths: [IndexPath], animated: Bool)
    case insertElements(indexPaths: [IndexPath], animated: Bool)
    case moveElements(fromIndexPaths: [IndexPath], toIndexPaths: [IndexPath], animated: Bool)
    
    var animated: Bool {
        switch self {
        case .deleteSection(_, let animated): return animated
        case .insertSection(_, let animated): return animated
        case .deleteElements(_, let animated): return animated
        case .insertElements(_, let animated): return animated
        case .moveElements(_, _, let animated): return animated
        }
    }
}

/// Section list data sources
public class SectionList<T> where T: Equatable {
    
    public let key: Any
    
    private var innerSources = [T]()
    
    public subscript(index: Int) -> T {
        get { return innerSources[index] }
        set(newValue) { insert(newValue, at: index) }
    }
    
    public var count: Int {
        return innerSources.count
    }
    
    public var first: T? {
        return innerSources.first
    }
    
    public var last: T? {
        return innerSources.last
    }
    
    public var allElements: [T] {
        return innerSources
    }
    
    public init(_ key: Any, initialElements: [T] = []) {
        self.key = key
        innerSources.append(contentsOf: initialElements)
    }
    
    public func forEach(_ body: ((Int, T) -> ())) {
        for (i, element) in innerSources.enumerated() {
            body(i, element)
        }
    }
    
    fileprivate func insert(_ element: T, at index: Int) {
        innerSources.insert(element, at: index)
    }
    
    fileprivate func insert(_ elements: [T], at index: Int) {
        innerSources.insert(contentsOf: elements, at: index)
    }
    
    fileprivate func append(_ element: T) {
        innerSources.append(element)
    }
    
    fileprivate func append(_ elements: [T]) {
        innerSources.append(contentsOf: elements)
    }
    
    @discardableResult
    fileprivate func remove(at index: Int) -> T? {
        return innerSources.remove(at: index)
    }
    
    fileprivate func remove(at indice: [Int]) {
        let newSources = innerSources.enumerated().compactMap { indice.contains($0.offset) ? nil : $0.element }
        innerSources = newSources
    }
    
    fileprivate func removeAll() {
        innerSources.removeAll()
    }
    
    fileprivate func sort(by predicate: (T, T) throws -> Bool) rethrows {
        try innerSources.sort(by: predicate)
    }
    
    @discardableResult
    fileprivate func firstIndex(of element: T) -> Int? {
        return innerSources.firstIndex(of: element)
    }
    
    @discardableResult
    fileprivate func lastIndex(of element: T) -> Int? {
        return innerSources.lastIndex(of: element)
    }
    
    @discardableResult
    fileprivate func firstIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.firstIndex(where: predicate)
    }
    
    @discardableResult
    fileprivate func lastIndex(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try innerSources.lastIndex(where: predicate)
    }
    
    fileprivate func map<U>(_ transform: (T) throws -> U) rethrows -> [U] {
        return try innerSources.map(transform)
    }
    
    fileprivate func compactMap<U>(_ transform: (T) throws -> U?) rethrows -> [U] {
        return try innerSources.compactMap(transform)
    }
}

public class ReactiveCollection<T> where T: Equatable {
    
    public var animated: Bool = true
    
    private var innerSources: [SectionList<T>] = []
    
    private let publisher = PublishSubject<ChangeSet>()
    private let rxInnerSources = BehaviorRelay<[SectionList<T>]>(value: [])
    
    public let collectionChanged: Observable<ChangeSet>
    
    public subscript(index: Int, section: Int) -> T {
        get { return innerSources[section][index] }
        set(newValue) { insert(newValue, at: index, of: section) }
    }
    
    public subscript(index: Int) -> SectionList<T> {
        get { return innerSources[index] }
        set(newValue) { insertSection(newValue, at: index) }
    }
    
    public var count: Int {
        return innerSources.count
    }
    
    public var first: SectionList<T>? {
        return innerSources.first
    }
    
    public var last: SectionList<T>? {
        return innerSources.last
    }
    
    public init() {
        collectionChanged = publisher.asObservable()
    }
    
    public func forEach(_ body: ((Int, SectionList<T>) -> ())) {
        for (i, section) in innerSources.enumerated() {
            body(i, section)
        }
    }
    
    public func countElements(at section: Int = 0) -> Int {
        guard section >= 0 && section < innerSources.count else { return 0 }
        return innerSources[section].count
    }
    
    // MARK: - section manipulations
    
    public func reset(_ sources: [[T]], animated: Bool? = nil) {
        removeAll(animated: animated)
        
        for sectionList in sources {
            appendSection("", elements: sectionList, animated: animated)
        }
    }
    
    public func reset(_ sources: [SectionList<T>], animated: Bool? = nil) {
        removeAll(animated: animated)
        
        for sectionList in sources {
            appendSection(sectionList, animated: animated)
        }
    }
    
    public func insertSection(_ key: Any, elements: [T], at index: Int, animated: Bool? = nil) {
        insertSection(SectionList<T>(key, initialElements: elements), at: index, animated: animated)
    }
    
    public func insertSection(_ sectionList: SectionList<T>, at index: Int, animated: Bool? = nil) {
        if innerSources.count == 0 {
            innerSources.append(sectionList)
        } else {
            innerSources.insert(sectionList, at: index)
        }
        
        rxInnerSources.accept(innerSources)
        publisher.onNext(.insertSection(section: index, animated: animated ?? self.animated))
    }
    
    public func appendSections(_ sectionLists: [SectionList<T>], animated: Bool? = nil) {
        for sectionList in sectionLists {
            appendSection(sectionList, animated: animated)
        }
    }
    
    public func appendSection(_ key: Any, elements: [T], animated: Bool? = nil) {
        appendSection(SectionList<T>(key, initialElements: elements), animated: animated)
    }
    
    public func appendSection(_ sectionList: SectionList<T>, animated: Bool? = nil) {
        let section = innerSources.count == 0 ? 0 : innerSources.count
        
        innerSources.append(sectionList)
        rxInnerSources.accept(innerSources)
        publisher.onNext(.insertSection(section: section, animated: animated ?? self.animated))
    }
    
    @discardableResult
    public func removeSection(at index: Int, animated: Bool? = nil) -> SectionList<T> {
        let element = innerSources.remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.onNext(.deleteSection(section: index, animated: animated ?? self.animated))
        
        return element
    }
    
    public func removeAll(animated: Bool? = nil) {
        innerSources.removeAll()
        rxInnerSources.accept(innerSources)
        publisher.onNext(.deleteSection(section: -1, animated: animated ?? self.animated))
    }
    
    // MARK: - section elements manipulations
    
    public func insert(_ element: T, at indexPath: IndexPath, animated: Bool? = nil) {
        let section = indexPath.section
        let index = indexPath.row
        
        insert(element, at: index, of: section, animated: animated)
    }
    
    public func insert(_ element: T, at index: Int, of section: Int = 0, animated: Bool? = nil) {
        if innerSources[section].count == 0 {
            innerSources[section].append(element)
        } else if index < innerSources[section].count {
            innerSources[section].insert(element, at: index)
        }
        
        rxInnerSources.accept(innerSources)
        publisher.onNext(.insertElements(indexPaths: [IndexPath(row: index, section: section)], animated: animated ?? self.animated))
    }
    
    public func insert(_ elements: [T], at indexPath: IndexPath, animated: Bool? = nil) {
        let section = indexPath.section
        let index = indexPath.row
        
        insert(elements, at: index, of: section, animated: animated)
    }
    
    public func insert(_ elements: [T], at index: Int, of section: Int = 0, animated: Bool? = nil) {
        innerSources[section].insert(elements, at: index)
        rxInnerSources.accept(innerSources)
        
        publisher.onNext(.insertElements(indexPaths: [IndexPath(row: index, section: section)], animated: animated ?? self.animated))
    }
    
    public func append(_ element: T, to section: Int = 0, animated: Bool? = nil) {
        if innerSources.count == 0 {
            appendSection(SectionList<T>("", initialElements: [element]))
            return
        }
        
        let index = innerSources[section].count
        innerSources[section].append(element)
        rxInnerSources.accept(innerSources)
        publisher.onNext(.insertElements(indexPaths: [IndexPath(row: index, section: section)], animated: animated ?? self.animated))
    }
    
    public func append(_ elements: [T], to section: Int = 0, animated: Bool? = nil) {
        if innerSources.count == 0 {
            appendSection("", elements: elements)
            return
        }
        
        let indexPaths: [IndexPath]
        if elements.count == 0 {
            indexPaths = []
        } else {
            let startIndex = innerSources[section].count == 0 ? 0 : innerSources[section].count
            let endIndex = (startIndex + (elements.count - 1))
            indexPaths = Array(startIndex...endIndex).map { IndexPath(row: $0, section: section) }
        }
        
        innerSources[section].append(elements)
        rxInnerSources.accept(innerSources)
        publisher.onNext(.insertElements(indexPaths: indexPaths, animated: animated ?? self.animated))
    }
    
    @discardableResult
    public func remove(at indexPath: IndexPath, animated: Bool? = nil) -> T? {
        let section = indexPath.section
        let index = indexPath.row
        
        return remove(at: index, of: section, animated: animated)
    }
    
    @discardableResult
    public func remove(at index: Int, of section: Int = 0, animated: Bool? = nil) -> T? {
        let element = innerSources[section].remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.onNext(.deleteElements(indexPaths: [IndexPath(row: index, section: section)], animated: animated ?? self.animated))
        
        return element
    }
    
    public func remove(at indice: [Int], of section: Int = 0, animated: Bool? = nil) {
        remove(at: indice.map { IndexPath(row: $0, section: section) })
    }
    
    public func remove(at indexPaths: [IndexPath], animated: Bool? = nil) {
        for indexPath in indexPaths {
            innerSources[indexPath.section].remove(at: indexPath.row)
        }
        
        rxInnerSources.accept(innerSources)
        publisher.onNext(.deleteElements(indexPaths: indexPaths, animated: animated ?? self.animated))
    }
    
    public func sort(by predicate: (T, T) throws -> Bool, at section: Int = 0, animated: Bool? = nil) rethrows {
        let oldElements = innerSources[section].allElements
        
        try innerSources[section].sort(by: predicate)
        
        let newElements = innerSources[section].allElements
        
        var fromIndexPaths: [IndexPath] = []
        var toIndexPaths: [IndexPath] = []
        oldElements.enumerated().forEach { (i, element) in
            if let newIndex = newElements.index(of: element) {
                toIndexPaths.append(IndexPath(row: newIndex, section: section))
                fromIndexPaths.append(IndexPath(row: i, section: section))
            }
        }
        
        if fromIndexPaths.count == toIndexPaths.count {
            rxInnerSources.accept(innerSources)
            publisher.onNext(.moveElements(fromIndexPaths: fromIndexPaths, toIndexPaths: toIndexPaths, animated: animated ?? self.animated))
        }
    }
    
    public func move(from fromIndexPaths: [IndexPath], to toIndexPaths: [IndexPath], animated: Bool? = nil) {
        guard fromIndexPaths.count == toIndexPaths.count else { return }
        
        var validIndice: [Int] = []
        for (i, fromIndexPath) in fromIndexPaths.enumerated() {
            let toIndexPath = toIndexPaths[i]
            if fromIndexPath.section != toIndexPath.section {
                if let element = innerSources[fromIndexPath.section].remove(at: fromIndexPath.row) {
                    innerSources[toIndexPath.section].insert(element, at: toIndexPath.row)
                    validIndice.append(i)
                }
            } else {
                let element = innerSources[fromIndexPath.section][fromIndexPath.row]
                innerSources[toIndexPath.section].insert(element, at: toIndexPath.row)
                
                if fromIndexPath.row < toIndexPath.row {
                    innerSources[fromIndexPath.section].remove(at: fromIndexPath.row)
                    validIndice.append(i)
                } else if fromIndexPath.row > toIndexPath.row {
                    innerSources[fromIndexPath.section].remove(at: fromIndexPath.row + 1)
                    validIndice.append(i)
                }
            }
        }
        
        if validIndice.count > 0 {
            rxInnerSources.accept(innerSources)
            publisher.onNext(.moveElements(fromIndexPaths: validIndice.map { fromIndexPaths[$0] }, toIndexPaths: validIndice.map { toIndexPaths[$0] }, animated: animated ?? self.animated))
        }
    }
    
    public func asObservable() -> Observable<[SectionList<T>]> {
        return rxInnerSources.asObservable()
    }
    
    public func indexForSection(withKey key: AnyObject) -> Int? {
        return innerSources.firstIndex(where: { key.isEqual($0.key) })
    }
    
    @discardableResult
    public func firstIndex(of element: T, at section: Int = 0) -> Int? {
        return innerSources[section].firstIndex(of: element)
    }
    
    @discardableResult
    public func lastIndex(of element: T, at section: Int) -> Int? {
        return innerSources[section].lastIndex(of: element)
    }
    
    @discardableResult
    public func firstIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[section].firstIndex(where: predicate)
    }
    
    @discardableResult
    public func lastIndex(where predicate: (T) throws -> Bool, at section: Int) rethrows -> Int? {
        return try innerSources[0].lastIndex(where: predicate)
    }
}
