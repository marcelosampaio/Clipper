//
//  Database.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 02/06/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation
import SQLite3

class Database : NSObject {
    
    // MARK: - Properties
    private var db : OpaquePointer?
    private var statement: OpaquePointer?
    
    
    // MARK: - Database Queries
//    public func getCountries() -> Array<Any> {
//
//        // open Database
//        openDB()
//
//        // query execution
//
//        let sql = getSQL(action: "getCountries", param: String())
//        print("*** SQL QUERY: \(sql)")
//        // set up result array
//        var resultArray = [String]()
//
//        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("🆘 error preparing select getCountries: \(errmsg) 🆘")
//        }
//
//        while sqlite3_step(statement) == SQLITE_ROW {
//            // database fields
//            var country = String()
//            if let cString = sqlite3_column_text(statement, 0) {
//                country = String(cString: cString)
//            }
//            resultArray.append(country)
//        }
//        closeDB()
//        return resultArray
//    }
//
//
//    public func getLocations() -> Array<Any> {
//
//        // open Database
//        openDB()
//
//        // query execution
//        let sql = getSQL(action: "getLocations", param: String())
//        print("*** SQL QUERY: \(sql)")
//
//        // set up result array
//        var resultArray = [LocationRow]()
//
//        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("🆘 error preparing select getLocations: \(errmsg) 🆘")
//        }
//
//        while sqlite3_step(statement) == SQLITE_ROW {
//            // database fields
//            var cityIdX = String()
//            var country = String()
//            var city = String()
//            var latitude = String()
//            var longitude = String()
//            var altitude = String()
//
//            if let cString = sqlite3_column_text(statement, 0) {
//                cityIdX = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 1) {
//                country = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 2) {
//                city = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 3) {
//                latitude = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 4) {
//                longitude = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 5) {
//                altitude = String(cString: cString)
//            }
//
//            resultArray.append(LocationRow.init(cityId: Int(cityIdX)!, country: country, city: city, latitude: latitude, longitude: longitude, altitude: altitude))
//        }
//
//
//        // close Database
//        closeDB()
//
//        return resultArray
//    }
//    
//    
//    
//    public func getCities(country: String) -> Array<LocationRow> {
//        
//        // open Database
//        openDB()
//        
//        // query execution
//        let sql = getSQL(action: "getCitiesOfCountry", param: country)
//        print("*** SQL QUERY: \(sql)")
//        
//        
//        // set up result array
//        var resultArray = [LocationRow]()
//        
//        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("🆘 error preparing select getLocations: \(errmsg) 🆘")
//        }
//        
//        while sqlite3_step(statement) == SQLITE_ROW {
//            // database fields
//            var cityIdX = String()
//            var country = String()
//            var city = String()
//            var latitude = String()
//            var longitude = String()
//            var altitude = String()
//            
//            if let cString = sqlite3_column_text(statement, 0) {
//                cityIdX = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 1) {
//                country = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 2) {
//                city = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 3) {
//                latitude = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 4) {
//                longitude = String(cString: cString)
//            }
//            if let cString = sqlite3_column_text(statement, 5) {
//                altitude = String(cString: cString)
//            }
//            
//            resultArray.append(LocationRow.init(cityId: Int(cityIdX)!, country: country, city: city, latitude: latitude, longitude: longitude, altitude: altitude))
//            
//        }
//        
//        // close Database
//        closeDB()
//        
//        return resultArray
//        
//        
//    }
    
    
    
    // MARK: - Input/Output Helpers
    private func dbPath() -> String {
        // db file path (resource path)
        let bundle = Bundle.main
        let path = bundle.path(forResource: "location", ofType: "db")
        
        print("👉 DB PATH: \(path!)")
        return path!
    }
    
    private func openDB() {
        
        if sqlite3_open(dbPath(), &db) != SQLITE_OK {
            print("🆘 error openning database 🆘")
            return
        }
        
    }
    
    private func closeDB() {
        if sqlite3_close(db) != SQLITE_OK {
            print("🆘 error closing database 🆘")
            return
        }
        
        db = nil
    }
    
    
    
    // MARK: - Class Helper
    private func getSQL(action: String, param: String) -> String {
        
        var result = String()
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            
            // file root is a dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                print ("****** dic = \(dic)")
                
                result = dic[action] as! String
                
                if !(param == "") {
                    print("*** ACTION: \(action) PARAM: \(param)")
                    result = result.replacingOccurrences(of: "$", with: param)
                }
            }
        }
        print("***2*** ACTION: \(action) PARAM: \(param)")
        return result
    }
    
}

