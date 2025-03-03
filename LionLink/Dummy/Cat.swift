//
//  Cat.swift
//  Aesthetics
//
//  Created by Liam Bean on 10/23/24.
//

import Foundation

struct Cat: Hashable, Identifiable{
    let id = UUID()
    let name: String
    let imageName: String
    
}
struct MockData {
    static let sampleCat = Cat(name: "Cat King",imageName:"CatKing")
    
    static let cats = [
        Cat(name: "Rat King",imageName:"RatKing"),
        Cat(name: "Cat King",imageName:"CatKing"),
        Cat(name: "Dog King", imageName:"DogKing"),
        Cat(name: "Burger King", imageName:"BurgerKing"),
        Cat(name: "Lion King", imageName: "LionKing"),
        Cat(name:"Martin Luther King", imageName: "MartinKing"),
        Cat(name: "Bojji", imageName: "TinyKing"),
        Cat(name: "King Cold", imageName: "KingCold"),
        Cat(name: "Gol D. Roger", imageName: "PirateKing")
        ]
        }
