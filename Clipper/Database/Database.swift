//
//  Database.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 02/06/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class Database : NSObject {
    
    // MARK: - Properties
    private var db : OpaquePointer?
    private var statement: OpaquePointer?
    
    
    // MARK: - Database Queries
    public func addLocation(location: String, reference: String, coordinate: CGPoint) {
        
        self.openDB()
        
        let sql = "here comes the insert statment"
        
        print("👉 addLocation SQL: \(sql)")
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error inserting row to the table 🆘")
            return
        }else{
            print("👉 insert OK")
        }
        
        self.closeDB()
        
    }
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
    
    
    // MARK: - Database Settings
    public func prepareDatabase() {
        
        let sourcePath = self.bundlePath()
        print("☘️ source path: \(sourcePath)")
        
        let targetPath = self.databasePath()
        
        print("☘️ target path: \(targetPath)")
        
        // Check if a writable copy of the database exists
        if FileManager.default.fileExists(atPath: targetPath) {
            print("🍻 writable database exists")
            return
        }
        
        print("🍻 writable database will be copied to documents folder")
        
        let sourceUrl = URL.init(fileURLWithPath: sourcePath)
        let targetUrl = URL.init(fileURLWithPath: targetPath)
        
        do {
            try FileManager.default.copyItem(at: sourceUrl, to: targetUrl)
        } catch  {
            print("🆘 error copying database to wrtable folder")
            return
        }
        print("🍻 writable database has been copied to target folder: \(targetUrl)")
        
        print("........")
        
        
    }
    
    
    
    
    private func bundlePath() -> String {
        // db file path (resource path)
        let bundle = Bundle.main
        let path = bundle.path(forResource: "location", ofType: "db")
        
        print("👉 DB PATH: \(path!)")
        return path!
    }
    
    private func databasePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "location.db"
    }
    
    
    private func openDB() {
        if sqlite3_open(databasePath(), &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("🆘 error openning database 🆘  Error: \(errmsg)")
            return
        }
    }
    
    private func closeDB() {
        if sqlite3_close(db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("🆘 error closing database 🆘   Error: \(errmsg)")
            return
        }
        
        db = nil
    }
    
    // MARK: - Class Helper
    class func getSql(_ identifier: String) -> String {
        
        var result = String()
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            
            // file root is a dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                result = dic[identifier] as! String
            }
        }
        return result
    }
}

