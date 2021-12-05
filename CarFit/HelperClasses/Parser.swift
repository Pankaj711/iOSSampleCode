//
//  Parser.swift
//  CarFit
//
//  Created by Kamaljeet Punia on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - ERROR MODEL
struct ResponseErrorBlock: Error {
    var message: String
}

// MARK: - TYPE ALIAS
typealias AppResult<T> = Result<T, ResponseErrorBlock>

// MARK: - PARSER CLASS
class Parser {
    // MARK: - VARIABLES
    static let shared = Parser()
    
    // MARK: - CLASS LIFE CYCLE
    private init() {
    }
    
    // MARK: - READ AND PARSE DATA FUNCTION
    func readDataFromFile<T: Decodable>(name: String, forModel model: T.Type) -> AppResult<T> {
        if let path = Bundle.main.path(forResource: name, ofType: "json")
        {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let cleanerListData = try JSONDecoder().decode(model.self, from: data)
                return AppResult.success(cleanerListData)
            } catch {
                // handle error
                return AppResult.failure(ResponseErrorBlock(message: "Could not read data."))
            }
        }
        return AppResult.failure(ResponseErrorBlock(message: "Could not read data."))
    }
}
