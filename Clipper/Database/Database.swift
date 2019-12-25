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
import MapKit

class Database : NSObject {
    
    // MARK: - Properties
    private var db : OpaquePointer?
    private var statement: OpaquePointer?
    
    
    // MARK: - Database Queries
    public func addLocation(location: String, reference: String, coordinate: CLLocationCoordinate2D) {
        
        self.openDB()
        
        let sql = self.getInsertLocationStatment(location: location, reference: reference, coordinate: coordinate)
        
        print("🤙 sql: \(sql)")
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error inserting row to the table 🆘")
            return
        }else{
            print("👉 insert OK")
        }
        
        self.closeDB()
        
    }

    public func deleteLocation(location: String, reference: String, coordinate: CLLocationCoordinate2D) {
        
        self.openDB()
        
        let sql = self.getDeleteLocationStatment(location: location, reference: reference, coordinate: coordinate)
        
        print("🤙 sql: \(sql)")
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error deleting row from the table 🆘")
            return
        }else{
            print("👉 delete OK")
        }
        
        self.closeDB()
        
    }
    public func deleteLocationById(id: Int) {
        
        self.openDB()
        
        let sql = self.getDeleteLocationByIdStatment(id: id)
        
        print("🤙 sql: \(sql)")
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error deleting row by id from the table 🆘")
            return
        }else{
            print("👉 delete by id OK")
        }
        
        self.closeDB()
        
    }
    
    public func updateLocation(location: String, reference: String, id: Int) {
        
        self.openDB()
        
        let sql = self.getUpdateLocationStatment(location: location, reference: reference, id: id)
        
        print("🤙 sql: \(sql)")
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("🆘 error updateing row from the table 🆘")
            return
        }else{
            print("👉 update OK")
        }
        
        self.closeDB()
        
    }
    
    public func getLocations() -> [LocationRow] {

        // open Database
        openDB()

        // query execution
        let sql = Database.getSql("getLocations")
        
        print("*** SQL QUERY: \(sql)")

        // set up result array
        var resultArray = [LocationRow]()

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("🆘 error preparing select getLocations: \(errmsg) 🆘")
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            // database fields
            var locationId = String()
            var location = String()
            var reference = String()
            var latitude = String()
            var longitude = String()
            

            if let cString = sqlite3_column_text(statement, 0) {
                locationId = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 1) {
                location = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 2) {
                reference = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 3) {
                latitude = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 4) {
                longitude = String(cString: cString)
            }

            var id = Int()
            var lat = Double()
            var lon = Double()
            
            if let temp = Int(locationId) {
                id = temp
            }
            if let temp = Double(latitude) {
                lat = temp
            }
            if let temp = Double(longitude) {
                lon = temp
            }
            
            resultArray.append(LocationRow(locationId: id, location: location, reference: reference, latitude: lat, longitude: lon))
            
        }


        // close Database
        closeDB()

        return resultArray
    }
    
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
    
    // MARK: - Sql Statment
    private func getInsertLocationStatment(location: String, reference: String, coordinate: CLLocationCoordinate2D) -> String {
        
        let sqlStatment = Database.getSql("insertLocation")
        
        var sql = sqlStatment.replacingOccurrences(of: "[LOCATION]", with: location)
        sql = sql.replacingOccurrences(of: "[REFERENCE]", with: reference)
        sql = sql.replacingOccurrences(of: "[LATITUDE]", with: String(coordinate.latitude))
        sql = sql.replacingOccurrences(of: "[LONGITUDE]", with: String(coordinate.longitude))
        
        return sql
    }
    private func getDeleteLocationStatment(location: String, reference: String, coordinate: CLLocationCoordinate2D) -> String {
        
        let sqlStatment = Database.getSql("deleteLocation")
        
        var sql = sqlStatment.replacingOccurrences(of: "[LOCATION]", with: location)
        sql = sql.replacingOccurrences(of: "[REFERENCE]", with: reference)

        
        return sql
    }
    
    private func getDeleteLocationByIdStatment(id: Int) -> String {
        
        let sqlStatment = Database.getSql("deleteLocationById")
        
        let sql = sqlStatment.replacingOccurrences(of: "[ID]", with: String(id))

        
        return sql
    }
    
    
    private func getUpdateLocationStatment(location: String, reference: String, id: Int) -> String {
        
        let sqlStatment = Database.getSql("updateLocation")
        
        
        var sql = sqlStatment.replacingOccurrences(of: "[LOCATION]", with: location)
        sql = sql.replacingOccurrences(of: "[REFERENCE]", with: reference)
        sql = sql.replacingOccurrences(of: "[ID]", with: String(id))

        
        return sql
    }
}

