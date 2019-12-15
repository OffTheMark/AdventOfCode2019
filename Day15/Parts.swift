//
//  Parts.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2019-12-15.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation
import Common
import IntCode
import Geometry
import DataStructures

final class Part1: Part {
    let program: [Int]
    private(set) var maze: [Point2D: Status] = [:]
    
    init(program: [Int]) throws {
        self.program = program
        self.maze = try breadthFirstSearch()
    }
    
    func solve() throws -> Int {
        draw(maze)
        
        guard let pathToOxygenSystem = dijkstra(maze) else {
            return 0
        }
        
        return pathToOxygenSystem.count - 1
    }
    
    private func draw(_ maze: [Point2D: Status]) {
        let allXCoordinates = maze.keys.map({ Int($0.x) })
        let minX = allXCoordinates.min()!
        let maxX = allXCoordinates.max()!
        
        let allYCoordinates = maze.keys.map({ Int($0.x) })
        let minY = allYCoordinates.min()!
        let maxY = allYCoordinates.max()!
        
        var drawnMap = ""
        for y in minY ... maxY {
            for x in minX ... maxX {
                let position = Point2D(x: Float(x), y: Float(y))
                if position == .zero {
                    drawnMap.append("📍")
                    continue
                }
                
                let status = maze[position, default: .empty]
                drawnMap.append(status.character)
            }
            drawnMap.append("\n")
        }
        
        print(drawnMap)
    }
    
    
    private func breadthFirstSearch() throws -> [Point2D: Status] {
        var queue = Queue<Node>()
        let initial = Node(position: .zero, status: .empty, computer: Computer(program: program, inputs: []))
        queue.enqueue(initial)
        
        var maze: [Point2D: Status] = [.zero: .empty]
        
        while let dequeued = queue.dequeue() {
            let neighbors = try dequeued.neighbors()
            
            for neighbor in neighbors {
                if !maze.keys.contains(neighbor.position) {
                    queue.enqueue(neighbor)
                    maze[neighbor.position] = neighbor.status
                }
            }
        }
        
        return maze
    }
    
    private func dijkstra(_ maze: [Point2D: Status]) -> [Point2D]? {
        var frontier: [[Point2D]] = [[.zero]] {
            didSet {
                frontier.sort(by: { $0.count < $1.count })
            }
        }
        var visited = Set<Point2D>()
        
        while !frontier.isEmpty {
            let shortestPath = frontier.removeFirst()
            let last = shortestPath.last!
            
            if maze[last, default: .empty] == .oxygenSystem {
                return shortestPath
            }
            
            visited.insert(last)
            
            let neighbors: [Point2D] = MovementCommand.allCases.compactMap({ command in
                let position = last + command.move
                if maze[position] == .wall {
                    return nil
                }
                
                return position
            })
            
            for neighbor in neighbors {
                if visited.contains(neighbor) {
                    continue
                }
                
                let path = shortestPath + [neighbor]
                frontier.append(path)
            }
        }
        
        return nil
    }
}

struct Node {
    let position: Point2D
    let status: Status
    let computer: Computer
    
    func neighbors() throws -> [Node] {
        if status == .wall {
            return []
        }
        
        return try MovementCommand.allCases
            .compactMap({command in
                let currentState = self.computer.state
                let computer = Computer(state: currentState, inputs: [command.rawValue])
                
                let statusRawValue = try computer.nextOutput()!
                let status = Status(rawValue: statusRawValue)!
                
                let position = self.position + command.move
                return Node(position: position, status: status, computer: computer)
            })
        
    }
}
