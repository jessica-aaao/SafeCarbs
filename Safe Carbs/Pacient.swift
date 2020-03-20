//
//  Pacient.swift
//  CALCULADORA DO DIABÉTICO
//
//  Created by Jéssica Amaral on 10/03/20.
//  Copyright © 2020 Jessica Amaral. All rights reserved.
//

import Foundation

class Pacients{
    var name: String
    var age: Int
    var weight: Float
    var dosis: Int
    var carbs: Float
    
    init(name: String, age: Int, weight: Float, dosis: Int, carbs: Float){
        self.name = name
        self.age = age
        self.weight = weight
        self.dosis = dosis
        self.carbs = carbs
    }
    
    func calculateCarbsResult() -> Float{
        var maxCarbs: Int
        var insulinProportion: Int
        if age == 0{
            maxCarbs = adultMaxCarbs(weight: weight, insulinDose: dosis).0
            insulinProportion = adultMaxCarbs(weight: weight, insulinDose: dosis).1
            
        } else {
            maxCarbs = 20 * dosis
            insulinProportion = 20
        }
        
        if maxCarbs >= Int(carbs) {
            return 0.0
        } else {
            return ((carbs/Float(insulinProportion)) - Float(dosis))
        }
    }
    
    func adultMaxCarbs(weight: Float, insulinDose: Int) -> (Int, Int) {
        //Se 50 <= peso <= 58
        if 0 <= weight, weight <= 58 {
            //15*qtdedeinsulina
            let carbs = 15*insulinDose
            return (carbs, 15)
        }
            
            //Se 59 <= peso <= 63
        else if 59 <= weight, weight <= 63 {
            //14*qtdedeinsulina
            let carbs = 14*insulinDose
            return (carbs, 14)
        }
            
            //Se 64 <= peso <= 68
        else if 64 <= weight, weight <= 68 {
            //13*qtdedeinsulina
            let carbs = 13*insulinDose
            return (carbs, 13)
        }
            
            //Se 69 <= peso <= 77
        else if 69 <= weight, weight <= 77 {
            //12*qtdedeinsulina
            let carbs = 12*insulinDose
            return (carbs, 12)
        }
            
            //Se 78 <= peso <= 86
        else if 78 <= weight, weight <= 86 {
            //10*qtdedeinsulina
            let carbs = 10*insulinDose
            return (carbs, 10)
        }
            
            //Se 87 <= peso <= 100
        else if 87 <= weight, weight <= 100 {
            //8*qtdedeinsulina
            let carbs = 8*insulinDose
            return (carbs, 8)
        }
            
            //Se peso > 100
        else if weight > 100 {
            //7*qtdedeinsulina
            let carbs = 7*insulinDose
            return (carbs, 7)
        }
        else {
            return (0,0)
        }
    }
}
