//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by İsmail Karakaş on 22.11.2023.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let character = try? JSONDecoder().decode(Character.self, from: jsonData)

import Foundation

// MARK: - Character
class Character: Codable {
    let info: Info
    let results: [Result]

    init(info: Info, results: [Result]) {
        self.info = info
        self.results = results
    }
}

// MARK: - Info
class Info: Codable {
    let count, pages: Int
    let next, prev: String

    init(count: Int, pages: Int, next: String, prev: String) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
}

// MARK: - Result
class Result: Codable {
    let id: Int
    let name: String
    let status: Status
    let species, type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String

    init(id: Int, name: String, status: Status, species: String, type: String, gender: Gender, origin: Location, location: Location, image: String, episode: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

// MARK: - Location
class Location: Codable {
    let name: String
    let url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
