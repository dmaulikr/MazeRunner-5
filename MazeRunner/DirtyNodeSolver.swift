//
//  DirtyOne.swift
//  MazeRunner
//
//  Created by Brian on 25/02/2017.
//  Copyright © 2017 Iko. All rights reserved.
//

import Foundation

class DirtyNodeSolver: INodeSolver {
    
    // ---------------------------------------
    // Solve Nodes
    // ---------------------------------------
    
    static func solveNodes(_ tiles: [TileState]) -> [Node] {
        
        var output = [Node]()
        
        // Rules
        // 1. if on a wall do nothing
        // 2. if on a path but was just on a wall
        var i = 0
        for _ in 0...Config.height - 1 {
            
            for _ in 0...Config.width - 1 {
             
                // If wall do nothing...
                if tiles[i]  == .wall { }
                else {
                    // Is Path test rules!
                    if let testedTile = runRuleSet(i, tiles) {
                        output.append(testedTile)
                    }
                }
                
                i += 1
            }
        }
        
        //TODO: Assign
        
        return output
    }
    
    // Node Rules
    static func runRuleSet(_ index: Int, _ tiles: [TileState]) -> Node? {
        
        let relatives = getAllRelatives(index, tiles)
        let left = relatives["left"]!
        let up = relatives["up"]!
        let right = relatives["right"]!
        let down = relatives["down"]!
        
        var isNode = false
        
        // if start or end node ignore
        if index < Config.width || index >= tiles.count - Config.width {
             isNode = true
        } else {
            // If is walkable right or down
            if isWalkable(right) ||  isWalkable(down) {
                isNode = true
            }
            if isWalkable(left) && isWalkable(up) {
                isNode = true
            }
            if (!isWalkable(up) && !isWalkable(down)) && (isWalkable(right) && isWalkable(left)) {
                isNode = false
            }
            if (isWalkable(up) && isWalkable(down)) && (!isWalkable(right) && !isWalkable(left)) {
                isNode = false
            }
        }
        
        return isNode ? Node(index, [:]) : nil
    }
    
    
    // ---------------------------------------
    // Helper Methods
    // ---------------------------------------
    
    static func isWalkable(_ t: TileState)  -> Bool {
        return t != .wall && t != .outOfBounds
    }
    
    static func isDeadEnd(_ index: Int, _ tiles: [TileState]) -> Bool {
        return getAllRelatives(index, tiles).filter { $0.value == .wall }.count >= 3
    }
    
    static func getAllRelatives(_ index: Int, _ tiles: [TileState]) -> [String : TileState] {
        var output: [String : TileState] = [:]
        
        output["left"] = getTilesAtRelativePosition(index, tiles, .left)
        output["up"] = getTilesAtRelativePosition(index, tiles, .up)
        output["right"] = getTilesAtRelativePosition(index, tiles, .right)
        output["down"] = getTilesAtRelativePosition(index, tiles, .down)
        
        return output
    }
    
    static func getTilesAtRelativePosition(_ index: Int, _ tiles: [TileState], _ position: TilePosition) -> TileState {
        switch position {
        case .left:
            return index-1 >= 0  ? tiles[index-1] : .outOfBounds
        case .up:
            return index-Config.width >= 0  ? tiles[index-Config.width] : .outOfBounds
        case .right:
            return index+1 <= tiles.count ? tiles[index+1] : .outOfBounds
        case .down:
            return index+Config.width <= tiles.count  ? tiles[index+Config.width] : .outOfBounds
        case .center:
            return tiles[index]
        }
    }
}
