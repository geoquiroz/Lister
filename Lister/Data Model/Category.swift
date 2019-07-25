//
//  Category.swift
//  Lister
//
//  Created by Geovanny quiroz on 7/24/19.
//  Copyright © 2019 Geovanny quiroz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
