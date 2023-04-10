//
//  Extensions.swift
//  NetflixClone2
//
//  Created by Самат Танкеев on 07.04.2023.
//

import Foundation


extension String {
    func captitilizeFirstLetter () -> String {
        self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
