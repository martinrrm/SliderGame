//
//  CableLevelData.swift
//  Cable_Grid
//
//  Created by Alumno on 4/9/19.
//  Copyright © 2019 Throwaway Studios. All rights reserved.
//

import UIKit

class CableLevelData: Codable {
    static let documentsDictionary = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDictionary.appendingPathComponent("Levels")
    static let url = Bundle.main.url(forResource: "Levels", withExtension: "plist")!
    
    var arrayImageNames:[String]
    var arrayAnswers:[Int]
    var arrayPositions:[Int]
    
    enum CodingKeys: String, CodingKey {
        case imageNames
        case answers
        case positions
    }
    
    init(names:[String], answers:[Int], positions:[Int]) {
        self.arrayImageNames = names
        self.arrayAnswers = answers
        self.arrayPositions = positions
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arrayImageNames, forKey: .imageNames)
        try container.encode(arrayAnswers, forKey: .answers)
        try container.encode(arrayPositions, forKey: .positions)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        arrayImageNames = try container.decode([String].self, forKey: .imageNames)
        arrayAnswers = try container.decode([Int].self, forKey: .answers)
        arrayPositions = try container.decode([Int].self, forKey: .positions)
    }
    

}
