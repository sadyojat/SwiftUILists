//
//  AbstractModel.swift
//  DiffableTVSwiftUI
//
//  Created by Alok Irde on 2/16/23.
//

import Foundation

protocol AbstractModel: Identifiable, Equatable {
    var id: Int { get }    
}
