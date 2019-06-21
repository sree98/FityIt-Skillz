//
//  ShapeFactory.swift
//  FityIt
//
//  Created by Txai Wieser on 13/03/18.
//  Copyright © 2018 Txai Wieser. All rights reserved.
//

import SpriteKit

enum ShapeType {
    case circle
    case square
    case triangle
    case pentagon
    
    static let allCases: [ShapeType] = [.circle, .square, .triangle, .pentagon]
    
    static var lastRandomShapeIndex: Int = 0
    static func randomShape() -> Shape {
        var i = 0
        let max = allCases.count-1
        repeat {
            i = Int(Skillz.getRandomNumber(withMin: 0, andMax: UInt(max)))
        } while i == lastRandomShapeIndex
        
        lastRandomShapeIndex = i
        return Shape(type: allCases[i])
    }
}

