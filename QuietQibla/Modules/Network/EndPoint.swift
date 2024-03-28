//
//  EndPoint.swift
//  QuietQibla
//
//  Created by abuzeid on 14.01.24.
//

import Foundation

struct EndPoint {
    let path: String
}

enum NetworkError: Error {
    case invalidURL
    case unsupportedMethod
}
