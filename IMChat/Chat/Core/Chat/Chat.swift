//
//  Enums.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

public struct Chat {
    public enum Direction {
        case left
        case right
    }
    public enum Kind: Codable, Equatable {
        public static func == (lhs: Chat.Kind, rhs: Chat.Kind) -> Bool {
            return true
        }
        
        case text(String?)
        case image(String?)
        case location(Double?, Double?)
        case record(String?)
        case localImage(UIImage?)
        // Codable
        private enum CodingKeys: String, CodingKey { case text, image, location, record, invoice, localImage }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let key = container.allKeys.first
            
            switch key {
                case .text:
                    let text = try container.decode(
                        String.self,
                        forKey: .text
                    )
                    self = .text(text)
                case .image:
                    let url = try container.decode(
                        String.self,
                        forKey: .image
                    )
                    self = .image(url)
                case .record:
                    let url = try container.decode(
                        String.self,
                        forKey: .record
                    )
                    self = .record(url)
                case .location:
                    var nestedContainer = try container.nestedUnkeyedContainer(forKey: .location)
                    let lat = try nestedContainer.decode(Double.self)
                    let lng = try nestedContainer.decode(Double.self)
                    self = .location(lat, lng)
                default:
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: container.codingPath,
                            debugDescription: "Unabled to decode enum."
                        )
                    )
            }
        }
        public func encode(to encoder: Encoder) throws {
            
        }
    }
}
