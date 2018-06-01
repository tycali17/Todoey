//
//  Action.swift
//  Todoey
//
//  Created by Ty Cali on 5/26/18.
//  Copyright © 2018 Ty Cali. All rights reserved.
//

import Foundation

//needs Codable (encodable/decodable) to be able to get added to plist
class Action: Codable {
    var title : String = ""
    var done: Bool = false
}
