// Models/OncologyDatabase.swift
import Foundation

struct OncologyDatabase: Decodable, Sendable  {
    let topics: [OncologyTopic]
}

struct OncologyTopic: Codable {
    let id: String
    let aliases: [String]
    let summary: String
    let howItWorks: String
    let commonSideEffects: [String]
    let contactCareTeamIf: [String]
    let source: String
}
