//
//  Events.swift
//  cardSlider_PF01
//
//  Created by Martin Rodrigo Ruiz Mares on 4/29/19.
//  Copyright © 2019 Martin Rodrigo Ruiz Mares. All rights reserved.
//


import UIKit

class Events: Codable {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let atchiveURL = documentsDirectory.appendingPathComponent("Events.plist")
    
    var Description : String
    var Probability : Double
    var Value : Double
    var Decision : Bool
    var Key : Int
    var Feedback : [String]
    
    enum CodingKeys : String, CodingKey {
        case Description
        case Probability
        case Value
        case Decision
        case Key
        case Feedback
    }
    
    init(Description : String, Probability : Double, Value : Double, Decision : Bool, Key : Int, Feedback : [String]){
        self.Description = Description
        self.Probability = Probability
        self.Value = Value
        self.Decision = Decision
        self.Key = Key
        self.Feedback = Feedback
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Description = try container.decode(String.self, forKey: .Description)
        Probability = try container.decode(Double.self, forKey: .Probability)
        Value = try container.decode(Double.self, forKey: .Value)
        Decision = try container.decode(Bool.self, forKey: .Decision)
        Key = try container.decode(Int.self, forKey: .Key)
        Feedback = try container.decode([String].self, forKey: .Feedback)
    }
}
