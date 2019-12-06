//
//  Solver.swift
//  Day6
//
//  Created by Marc-Antoine Malépart on 2019-12-06.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import DataStructures

final class Part1Solver {
    let tree: TreeNode<String>
    
    init(relationships: [(parent: String, child: String)]) {
        let trees = TreeNode.makeTrees(relationships: relationships)
        self.tree = trees[0]
    }
    
    func solve() -> Int {
        var count = 0
        
        tree.recursiveForEach({ node in
            count += node.depth()
        })
        
        return count
    }
}


final class Part2Solver {
    let tree: TreeNode<String>
    
    init(relationships: [(parent: String, child: String)]) {
        let trees = TreeNode.makeTrees(relationships: relationships)
        self.tree = trees[0]
    }
    
    func solve() throws -> Int {
        guard let me = tree.firstNode(with: "YOU") else {
            throw Day6Error.couldNotFindNode(value: "YOU")
        }
        
        guard let santa = tree.firstNode(with: "SAN") else {
            throw Day6Error.couldNotFindNode(value: "SAN")
        }
        
        let commonAncestorOrNil = me.ancestors.first(where: { santa.ancestors.contains($0) })
        
        guard let commonAncestor = commonAncestorOrNil else {
            throw Day6Error.noCommonAncestor
        }
        
        let depthForMe = me.depth(toReach: commonAncestor)!
        let depthForSanta = santa.depth(toReach: commonAncestor)!
        
        return depthForMe + depthForSanta
    }
}

enum Day6Error: Error {
    case couldNotFindNode(value: String)
    case noCommonAncestor
}
