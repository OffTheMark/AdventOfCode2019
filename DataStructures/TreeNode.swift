//
//  TreeNode.swift
//  DataStructures
//
//  Created by Marc-Antoine Malépart on 2019-12-06.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

public class TreeNode<Element>: NSObject {
    public var value: Element
    public private(set) weak var parent: TreeNode?
    public private(set) var children = [TreeNode]()
    
    public var hasParent: Bool {
        return parent != nil
    }
    
    public var count: Int {
        return children.count
    }
    
    public init(value: Element) {
        self.value = value
    }
    
    public func addChild(_ child: TreeNode<Element>) {
        children.append(child)
        child.parent = self
    }
    
    public func recursiveCount() -> Int {
        var recursiveCount = count
        
        for child in children {
            recursiveCount += child.recursiveCount()
        }
        
        return recursiveCount
    }
    
    public var depth: Int {
        return ancestors.count
    }
    
    public var ancestors: [TreeNode] {
        var ancestor = parent
        var ancestors = [TreeNode]()
        
        while let currentAncestor = ancestor {
            ancestors.append(currentAncestor)
            ancestor = currentAncestor.parent
        }
        
        return ancestors
    }
    
    public func depth(toReach node: TreeNode) -> Int? {
        var ancestor = parent
        var depth = 0
        
        while ancestor != nil {
            depth += 1
            ancestor = ancestor?.parent
            
            if ancestor == node {
                return depth
            }
        }
        
        return nil
    }
    
    public func recursiveForEach(_ body: @escaping (TreeNode) -> Void) {
        body(self)
        
        for child in children {
            child.recursiveForEach(body)
        }
    }
}

// MARK: Element: Equatable

public extension TreeNode where Element: Equatable {
    func firstNode(with value: Element) -> TreeNode? {
        if value == self.value {
            return self
        }
        
        for child in children {
            if let found = child.firstNode(with: value) {
                return found
            }
        }
        
        return nil
    }
}

// MARK: Element: Hashable

public extension TreeNode where Element: Hashable {
    static func makeTrees<S: Sequence>(relationships: S) -> [TreeNode] where S.Element == (parent: Element, child: Element)  {
        let distinctElements: Set<Element> = relationships.reduce(into: [], { result, relationship in
            result.formUnion([relationship.child, relationship.parent])
        })
        let nodeByElement: [Element: TreeNode] = distinctElements.reduce(into: [:], { result, element in
            result[element] = TreeNode(value: element)
        })
        
        for relationship in relationships {
            guard let child = nodeByElement[relationship.child] else {
                continue
            }
            
            guard let parent = nodeByElement[relationship.parent] else {
                continue
            }
            
            child.parent = parent
            parent.addChild(child)
        }
        
        return nodeByElement.values.filter({ !$0.hasParent })
    }
}
