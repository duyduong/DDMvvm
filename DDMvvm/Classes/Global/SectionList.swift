//
//  SectionList.swift
//  DMT
//
//  Created by Dao Duy Duong on 6/15/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import UIKit
import RxSwift

enum ChangeType {
    case deletion, insertion
}

struct ChangeData {
    let section: Int
    let indice: [Int]
}

struct ChangeEvent {
    let type: ChangeType
    let data: ChangeData
}

public class SectionList<T> {
    
    private var innerSources = [[T]]()
    
    private let subject = PublishSubject<ChangeEvent>()
    private let varInnerSources = Variable<[[T]]>([])
    
    let changesNotifier: Observable<ChangeEvent>
    
    subscript(index: Int, section: Int) -> T {
        get { return innerSources[section][index] }
        set(newValue) { insert(newValue, at: index, of: section) }
    }
    
    subscript(index: Int) -> [T] {
        get { return innerSources[index] }
        set(newValue) { insertSection(newValue, at: index) }
    }
    
    var sectionCount: Int {
        return innerSources.count
    }
    
    var first: [T]? {
        return innerSources.first
    }
    
    var last: [T]? {
        return innerSources.last
    }
    
    init(initialSectionElements: [T] = []) {
        innerSources.append(initialSectionElements)
        changesNotifier = subject.asObservable()
    }
    
    func forEach(_ body: ((Int, [T]) -> ())) {
        for (i, section) in innerSources.enumerated() {
            body(i, section)
        }
    }
    
    func countElements(on section: Int = 0) -> Int {
        return innerSources[section].count
    }
    
    // MARK: - section manipulations
    
    func setSections(_ sources: [[T]]) {
        removeAll()
        
        for sectionList in sources {
            self.appendSection(sectionList)
        }
    }
    
    func insertSection(_ elements: [T], at index: Int) {
        innerSources.insert(elements, at: index)
        varInnerSources.value = innerSources
        subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: index, indice: [])))
    }
    
    func appendSections(_ sections: [[T]]) {
        for section in sections {
            self.appendSection(section)
        }
    }
    
    func appendSection(_ elements: [T]) {
        let sectionIndex = innerSources.count == 0 ? 0 : innerSources.count
        
        innerSources.append(elements)
        varInnerSources.value = innerSources
        subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: sectionIndex, indice: [])))
    }
    
    @discardableResult
    func removeSection(at index: Int) -> [T] {
        let element = innerSources.remove(at: index)
        varInnerSources.value = innerSources
        subject.onNext(ChangeEvent(type: .deletion, data: ChangeData(section: index, indice: [])))
        
        return element
    }
    
    func removeAll() {
        innerSources.removeAll()
        varInnerSources.value = innerSources
        subject.onNext(ChangeEvent(type: .deletion, data: ChangeData(section: -1, indice: [])))
    }
    
    // MARK: - section elements manipulations
    
    func insert(_ element: T, at index: Int, of section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            if index >= 0 {
                if innerSources[section].count == 0 {
                    innerSources[section].append(element)
                    varInnerSources.value = innerSources
                    
                    subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: 0, indice: [index])))
                } else if index < innerSources[section].count {
                    innerSources[section].insert(element, at: index)
                    varInnerSources.value = innerSources
                    
                    subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: [index])))
                }
            }
        }
    }
    
    func insert(_ elements: [T], at index: Int, of section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            if index >= 0 {
                if innerSources[section].count == 0 {
                    innerSources[section].append(contentsOf: elements)
                    varInnerSources.value = innerSources
                    
                    let indice = Array(0...elements.count - 1)
                    subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: 0, indice: indice)))
                } else if index < innerSources[section].count {
                    innerSources[section].insert(contentsOf: elements, at: index)
                    varInnerSources.value = innerSources
                    
                    let indice = Array(0...elements.count - 1)
                    subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: indice)))
                }
            }
        }
    }
    
    func append(_ element: T, to section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            let index = innerSources[section].count == 0 ? 0 : innerSources[section].count
            innerSources[section].append(element)
            varInnerSources.value = innerSources
            subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: [index])))
        }
    }
    
    func append(_ elements: [T], to section: Int = 0) {
        if section >= 0 && section < innerSources.count {
            let startIndex = innerSources[section].count == 0 ? 0 : innerSources[section].count
            let endIndex = (startIndex + (elements.count - 1))
            let indice = Array(startIndex...endIndex)
            
            innerSources[section].append(contentsOf: elements)
            varInnerSources.value = innerSources
            subject.onNext(ChangeEvent(type: .insertion, data: ChangeData(section: section, indice: indice)))
        }
    }
    
    @discardableResult
    func remove(at index: Int, of section: Int = 0) -> T? {
        if section >= 0 && section < innerSources.count {
            if index >= 0 && index < innerSources[section].count {
                let element = innerSources[section].remove(at: index)
                varInnerSources.value = innerSources
                subject.onNext(ChangeEvent(type: .deletion, data: ChangeData(section: section, indice: [index])))
                
                return element
            }
        }
        
        return nil
    }
    
    func asObservable() -> Observable<[[T]]> {
        return varInnerSources.asObservable()
    }
    
}
