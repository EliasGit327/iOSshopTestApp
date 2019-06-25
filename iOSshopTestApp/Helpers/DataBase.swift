//
//  DataBase.swift
//  iOSshopTestApp
//
//  Created by Elias on 24/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import Foundation
import SQLite

public class DataBase {
    
    public static func getDataConnection() -> Connection {
        
        let dbDirrectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = dbDirrectory?.appendingPathComponent("User").appendingPathExtension("sqlite3")
        let dataBase = try? Connection(fileUrl!.path)
        return dataBase!
    }
    
    public static func checkIfTablesExist(dataBase : Connection) -> Bool {
        
        let table = Table("Favorites")
        do {
            _ = try dataBase.scalar(table.exists)
            
            print("Table Exists")
            return true
            //exists
            
        } catch {
            //doesn't
            print("Table Not Exists")
            return false
        }
    }
    
    public static func createFavTable(dataBase : Connection) {
        
        let table = Table("Favorites")
        
        do {
            try dataBase.run(table.create(ifNotExists: true) { t in
                t.column(Expression<Int64>("id"))
            })
            
            print("Table has been created")
        } catch {
            print("Table has not been created")
            print(error)
        }
    }
    
    public static func checkIfFav(dataBase : Connection, id : Int) -> Bool {
        
        var status = false
        let source = try! dataBase.prepare("SELECT id FROM Favorites WHERE id == \(id)")
    
        for row in source {
//                print("name: \(data[0]!)")
            if(row[0].self != nil) {
                status = true
            }
        }
        
        return status
    }
    
    public static func printAllFav(dataBase : Connection) {
        
        let source = try! dataBase.prepare("SELECT id FROM Favorites")
        
        for row in source {
            print("id: \(row[0]!)")
        }
    }
    
    public static func deleteRow(dataBase : Connection, id : Int) {
        
        do {
            try dataBase.scalar("DELETE FROM Favorites WHERE id == \(id)")
        } catch {
            print(error)
        }
        
    }
    
    public static func deleteAllRows(dataBase : Connection) {
        
        let table = Table("Favorites")
        
        do {
            try dataBase.run(table.delete())
        } catch {
            print(error)
        }
    }
    
    public static func addRow(dataBase : Connection, id : Int) {
        do {
            try dataBase.run(Table("Favorites").insert(Expression<Int64>("id") <- Int64(id)))
            
            
        } catch {
            print(error)
        }
    }
}

