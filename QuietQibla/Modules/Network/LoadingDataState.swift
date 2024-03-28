//
//  LoadingDataState.swift
//  QuietQibla
//
//  Created by abuzeid on 13.01.24.
//

import Foundation

/// Represents the loading state of photo details.
enum LoadingDataState<T> {
    /// Indicates that photo details are currently being loaded.
    case isLoading
    /// Indicates that an error occurred while fetching photo details.
    case failure(String)
    /// Indicates data were successfully loaded.
    case success(T)
}
