//
//  UtilityFunctions.swift
//  MovieSandbox
//
//  Created by Jack  on 3/16/23.
//

import Foundation
import SwiftUI


func measureText(_ string: String) -> CGSize {
        let text = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 17)])
    let size = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size
    }
