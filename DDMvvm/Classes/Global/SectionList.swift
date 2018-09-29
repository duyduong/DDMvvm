//
//  SectionList.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift
import RxCocoa

public enum ChangeType {
    case deletion, insertion
}

public struct ChangeData {
    public let section: Int
    public let indice: [Int]
}

public struct ChangeEvent {
    public let type: ChangeType
    public let data: ChangeData
}

public class SectionList<T> {
    
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
    
    public init(_ key: Any, initialSectionElements: [T] = []) {
        self.key = key
        innerSources.append(contentsOf: initialSectionElements)
    }
    
    public func forEach(_ body: ((Int, T) -> ())) {
        for (i, element) in innerSources.enumerated() {
            body(i, element)
        }
    }
    
    public func removeAll() {
        innerSources.removeAll()
    }
    
    public func insert(_ element: T, at index: Int) {
        if index >= 0 && index < innerSources.count {
            innerSources.insert(element, at: index)
        }
    }
    
    public func insert(_ elements: [T], at index: Int) {
        if index >= 0 && index < innerSources.count {
            innerSources.insert(contentsOf: elements, at: index)
        }
    }
    
    public func append(_ element: T) {
        innerSources.append(element)
    }
    
    public func append(_ elements: [T]) {
        innerSources.append(contentsOf: elements)
    }
    
    @discardableResult
    public func remove(at index: Int) -> T? {
        if index >= 0 && index < innerSources.count {
            let element = innerSources.remove(at: index)
            
            return element
        }
        
        return nil
    }
}

public class ReactiveCollection<T> {
    
    private var innerSources: [SectionList<T>] = []
    
    private let publisher = PublishRelay<ChangeEvent>()
    private let rxInnerSources = BehaviorRelay<[SectionList<T>]>(value: [])
    
    public let collectionChanged: Observable<ChangeEvent>
    
    public subscript(index: Int, section: Int) -> T {
        get { return innerSources[section][index] }
        set(newValue) { insert(newValue, at: index, of: section) }
    }
    
    public subscript(index: Int) -> SectionList<T> {
        get { return innerSources[index] }
        set(newValue) { insertSection(newValue, at: index) }
    }
    
    public var sectionCount: Int {
        return innerSources.count
    }
    
    public var first: SectionList<T>? {
        return innerSources.first
    }
    
    public var last: SectionList<T>? {
        return innerSources.last
    }
    
    public init(initialSectionElements: [T] = []) {
        let sectionList = SectionList<T>(initialSectionElements)
        innerSources.append(sectionList)
        collectionChanged = publisher.asObservable()
    }
    
    public func forEach(_ body: ((Int, SectionList<T>) -> ())) {
        for (i, section) in innerSources.enumerated() {
            body(i, section)
        }
    }
    
    public func countElements(on section: Int = 0) -> Int {
        return innerSources[section].count
    }
    
    // MARK: - section manipulations
    
    public func setSections(_ sources: [[T]]) {
        removeAll()
        
        for sectionList in sources {
            self.appendSection(sectionList)
        }
    }
    
    public func insertSection(_ elements: [T], at index: Int) {
        let sectionList = SectionList<T>(elements)
        innerSources.insert(sectionList, at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: index, indice: [])))
    }
    
    public func insertSection(_ sectionList: SectionList<T>, at index: Int) {
        innerSources.insert(sectionList, at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: index, indice: [])))
    }
    
    public func appendSections(_ sections: [[T]]) {
        for section in sections {
            self.appendSection(section)
        }
    }
    
    public func appendSection(_ elements: [T]) {
        let sectionIndex = innerSources.count == 0 ? 0 : innerSources.count
        
        let sectionList = SectionList<T>(elements)
        innerSources.append(sectionList)
        rxInnerSources.accept(innerSources)
        publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: sectionIndex, indice: [])))
    }
    
    @discardableResult
    public func removeSection(at index: Int) -> SectionList<T> {
        let element = innerSources.remove(at: index)
        rxInnerSources.accept(innerSources)
        publisher.accept(ChangeEvent(type: .deletion, data: ChangeData(section: index, indice: [])))
        
        return element
    }
    
    public func removeAll() {
        innerSources.removeAll()
        rxInnerSources.accept(innerSources)
        publisher.accept(ChangeEvent(type: .deletion, data: ChangeData(section: -1, indice: [])))
    }
    
    // MARK: - section elements manipulations
    
    public func insert(_ element: T, at index: Int, of section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            if index >= 0 {
                if innerSources[section].count == 0 {
                    innerSources[section].append(element)
                    rxInnerSources.accept(innerSources)
                    
                    publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: 0, indice: [index])))
                } else if index < innerSources[section].count {
                    innerSources[section].insert(element, at: index)
                    rxInnerSources.accept(innerSources)
                    
                    publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: [index])))
                }
            }
        }
    }
    
    public func insert(_ elements: [T], at index: Int, of section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            if index >= 0 {
                if innerSources[section].count == 0 {
                    innerSources[section].append(elements)
                    rxInnerSources.accept(innerSources)
                    
                    let indice = Array(0...elements.count - 1)
                    publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: 0, indice: indice)))
                } else if index < innerSources[section].count {
                    innerSources[section].insert(elements, at: index)
                    rxInnerSources.accept(innerSources)
                    
                    let indice = Array(0...elements.count - 1)
                    publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: indice)))
                }
            }
        }
    }
    
    public func append(_ element: T, to section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            let index = innerSources[section].count == 0 ? 0 : innerSources[section].count
            innerSources[section].append(element)
            rxInnerSources.accept(innerSources)
            publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: [index])))
        }
    }
    
    public func append(_ elements: [T], to section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            let startIndex = innerSources[section].count == 0 ? 0 : innerSources[section].count
            let endIndex = (startIndex + (elements.count - 1))
            let indice = Array(startIndex...endIndex)
            
            innerSources[section].append(elements)
            rxInnerSources.accept(innerSources)
            publisher.accept(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: indice)))
        }
    }
    
    @discardableResult
    public func remove(at index: Int, of section: Int = 0) -> T? {
        if section >= 0 && section < innerSources.count {
            if index >= 0 && index < innerSources[section].count {
                let element = innerSources[section].remove(at: index)
                rxInnerSources.accept(innerSources)
                publisher.accept(ChangeEvent(type: .deletion, data: ChangeData(section: section, indice: [index])))
                
                return element
            }
        }
        
        return nil
    }
    
    public func asObservable() -> Observable<[SectionList<T>]> {
        return rxInnerSources.asObservable()
    }
    
}
