//
//  PrayerTimesJsonResponse.swift
//  QuietQibla
//
//  Created by abuzeid on 28.03.24.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let prayerTimesJSONResponse = try? JSONDecoder().decode(PrayerTimesJSONResponse.self, from: jsonData)

// MARK: - PrayerTimesJSONResponse

struct PrayerTimesJSONResponse: Codable {
    let code: Int
    let status: String
    let data: [Datum]
}

// MARK: - Datum

struct Datum: Codable {
    let timings: Timings
    let date: DateClass
    let meta: Meta
}

// MARK: - DateClass

struct DateClass: Codable {
    let readable, timestamp: String
    let gregorian: Gregorian
    let hijri: Hijri
}

// MARK: - Gregorian

struct Gregorian: Codable {
    let date: String
    let format: Format
    let day: String
    let weekday: GregorianWeekday
    let month: GregorianMonth
    let year: String
    let designation: Designation
}

// MARK: - Designation

struct Designation: Codable {
    let abbreviated: Abbreviated
    let expanded: Expanded
}

enum Abbreviated: String, Codable {
    case ad = "AD"
    case ah = "AH"
}

enum Expanded: String, Codable {
    case annoDomini = "Anno Domini"
    case annoHegirae = "Anno Hegirae"
}

enum Format: String, Codable {
    case ddMmYyyy = "DD-MM-YYYY"
}

// MARK: - GregorianMonth

struct GregorianMonth: Codable {
    let number: Int
    let en: String // "April"
}

// MARK: - GregorianWeekday

struct GregorianWeekday: Codable {
    let en: String
}

// MARK: - Hijri

struct Hijri: Codable {
    let date: String
    let format: Format
    let day: String
    let weekday: HijriWeekday
    let month: HijriMonth
    let year: String
    let designation: Designation
    let holidays: [String]
}

// MARK: - HijriMonth

struct HijriMonth: Codable {
    let number: Int
    let en: String // "Rajab", "Shaʿbān"
    let ar: String
}

// MARK: - HijriWeekday

struct HijriWeekday: Codable {
    let en, ar: String
}

// MARK: - Meta

struct Meta: Codable {
    let latitude, longitude: Double
    let timezone: String
    let method: Method
    let latitudeAdjustmentMethod: LatitudeAdjustmentMethod
    let midnightMode, school: MidnightMode
    let offset: [String: Int]
}

enum LatitudeAdjustmentMethod: String, Codable {
    case angleBased = "ANGLE_BASED"
}

// MARK: - Method

struct Method: Codable {
    let id: Int
    let name: String
    let params: Params
    let location: Location
}

// MARK: - Location

struct Location: Codable {
    let latitude, longitude: Double
}

// enum Name: String, Codable {
//    case islamicSocietyOfNorthAmericaISNA = "Islamic Society of North America (ISNA)"
// }

// MARK: - Params

struct Params: Codable {
    let fajr, isha: Int

    enum CodingKeys: String, CodingKey {
        case fajr
        case isha
    }
}

enum MidnightMode: String, Codable {
    case standard = "STANDARD"
}

// enum Timezone: String, Codable {
//    case europeLondon = "Europe/London"
// }

// MARK: - Timings

struct Timings: Codable {
    let fajr, sunrise, dhuhr, asr: String
    let sunset, maghrib, isha, imsak: String
    let midnight, firstthird, lastthird: String

    enum CodingKeys: String, CodingKey {
        case fajr
        case sunrise
        case dhuhr
        case asr
        case sunset
        case maghrib
        case isha
        case imsak
        case midnight
        case firstthird
        case lastthird
    }
}
