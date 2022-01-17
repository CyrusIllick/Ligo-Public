//
//  CardSection.swift
//  Ligo
//
//  Created by Cyrus Illick on 04/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//


class CardSection :Equatable{
    var name:String
    var detailTypes = [String]()
    var detailValues = [String:String]()
    
    init(name:String){
        self.name = name
    }
    
    static func ==(lhs: CardSection, rhs: CardSection) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    func addDetail(type:String, value:String){
        if !self.detailTypes.contains(type){
                    self.detailTypes.append(type)
                }
                
                self.detailValues[type] = value
                
    }
    
}
