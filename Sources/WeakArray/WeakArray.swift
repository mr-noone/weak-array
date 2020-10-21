//
//  WeakArray.swift
//  weak-array
//
//  Created by Aleksey Zgurskiy on 21.10.2020.
//  Copyright © 2020 Aleksey Zgurskiy. All rights reserved.
//

import Foundation

public struct WeakArray<T: AnyObject> {
  private final class WeakWrapper<T: AnyObject>: CustomStringConvertible {
    weak var value: T?
    
    var description: String {
      switch value {
      case .some(let value): return "\(value)"
      case .none:            return "nil"
      }
    }
    
    init(_ value: T?) {
      self.value = value
    }
  }
  
  // MARK: - Properties
  
  private var elements = [WeakWrapper<T>]()
  
  // MARK: - Inits
  
  public init() {}
}

// MARK: - Public methods

public extension WeakArray {
  mutating func append(_ newElement: Element) {
    elements.append(WeakWrapper(newElement))
  }
}

// MARK: - ExpressibleByArrayLiteral

extension WeakArray: ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = T?
  
  public init(arrayLiteral elements: T?...) {
    self.elements = elements.map { WeakWrapper($0) }
  }
}

// MARK: - Collection

extension WeakArray: Collection {
  public typealias Element = T?
  public typealias Index = Int
  
  public var startIndex: Index { elements.startIndex }
  public var endIndex: Index { elements.endIndex }
  
  public var first: Element { elements.first?.value }
  
  public subscript(index: Index) -> Element {
    get { elements[index].value }
    set { elements[index] = WeakWrapper(newValue) }
  }
  
  public func index(after i: Index) -> Index {
    return elements.index(after: i)
  }
}

// MARK: - CustomStringConvertible

extension WeakArray: CustomStringConvertible {
  public var description: String {
    elements.description
  }
}
