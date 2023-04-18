//
//  AppManager.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit
import FMDB

class AppManager {
    static let instance = AppManager()
    
    /**
     Returns the file URL for the app's SQLite database file.
     
     This method retrieves the URL for the app's SQLite database file located in the app's documents directory. The method first gets the URL for the documents directory using the `FileManager` class, and then appends the name of the SQLite database file to the end of the URL. The resulting file URL can be used to open a connection to the app's SQLite database.
     
     - Returns: The file URL for the app's SQLite database file.
     */
    func getDirectoryPath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectory)
        let databaseURL = documentsDirectory.appendingPathComponent("quiz_app.db")
        return databaseURL
    }
    
    /**
     Sets up the initial data for the app's SQLite database.
     
     This method creates the necessary database table(s) and inserts initial data into the app's SQLite database using the `FMDatabase` class. The method retrieves the file URL for the database file using the `getDirectoryPath()` method, and then opens a connection to the database. If the connection is successful, the method calls the `createTable(database:)` method to create the necessary table(s), and then calls the `insertInitialData(database:)` method to insert initial data into the table(s). If an error occurs during data insertion, the error is printed to the console. Finally, the method closes the database connection.
     */
    func setupInitialData() {
        let database = FMDatabase(url: getDirectoryPath())
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        AppManager.instance.createTable(database: database)
        
        do {
            try insertInitialData(database: database)
        } catch {
            print("Error inserting initial data: \(error)")
        }

        database.close()
    }
    
    /**
     Creates the necessary database table(s) for the app's SQLite database.

     - Parameter database: A `FMDatabase` instance representing the app's SQLite database.
     */
    func createTable(database: FMDatabase) {
        let createQuestionsTable = "CREATE TABLE IF NOT EXISTS Questions (question_id INTEGER PRIMARY KEY,question_text TEXT)"
        database.executeStatements(createQuestionsTable)
        
        let createOptionsTable = "CREATE TABLE IF NOT EXISTS Options (option_id INTEGER PRIMARY KEY,question_id INTEGER,option_text TEXT,is_correct INTEGER,FOREIGN KEY (question_id) REFERENCES Questions (question_id));"
        database.executeStatements(createOptionsTable)
    }
    
    /**
     Inserts initial data into the app's SQLite database.
     
     This method inserts initial data into the `Questions` and `Options` tables in the app's SQLite database using the `insertQuestionData(database:)` and `insertOptionData(database:)` methods.
     
     - Parameter database: A `FMDatabase` instance representing the app's SQLite database.
     - Throws: An error if an error occurs during data insertion.
     */
    func insertInitialData(database: FMDatabase) throws {
        try insertQuestionData(database: database)
        try insertOptionData(database: database)
    }
    
    /**
     Inserts initial question data into the app's SQLite database.
     
     - Parameter database: A `FMDatabase` instance representing the app's SQLite database.
     - Throws: An error if an error occurs during data insertion.
     */
    func insertQuestionData(database: FMDatabase) throws {
        let insertQuery = "INSERT INTO Questions (question_id, question_text) VALUES (?, ?)"
        let values = [
            (1, "Who is the Prime Minister of India?"),
            (2, "What is the capital of India?"),
            (3, "What is sum of 15+25?"),
            (4, "Which one is maximum? 25, 11, 17, 18, 40, 42"),
            (5, "What is the official language of Gujarat?"),
            (6, "What is multiplication of 12 * 12 ?"),
            (7, "Which state of India has the largest population?"),
            (8, "Who is the Home Minister of India?"),
            (9, "What is the capital of Gujarat?"),
            (10, "Which number will be next in series? 1, 4, 9, 16, 25"),
            (11, "Which one is minimum? 5, 0, -20, 11"),
            (12, "What is sum of 10, 12 and 15?"),
            (13, "What is the ​official language of the Government of India?"),
            (14, "Which country is located in Asia?"),
            (15, "Which language(s) is/are used for Android app development?"),
        ]
        for value in values {
            guard database.executeUpdate(insertQuery, withArgumentsIn: [value.0, value.1]) else {
                continue
            }
        }
    }
    
    /**
     Inserts initial option data into the app's SQLite database.
     
     - Parameter database: A `FMDatabase` instance representing the app's SQLite database.
     - Throws: An error if an error occurs during data insertion.
     */
    func insertOptionData(database: FMDatabase) throws {
        let insertQuery = "INSERT INTO Options (option_id, question_id, option_text, is_correct) VALUES (?, ?, ?, ?)"
        let values = [
            (1, 1, "Narendra Modi", 1),
            (2, 1, "Rahul Gandhi", 0),
            (3, 1, "Manmohan Singh", 0),
            (4, 1, "Amit Shah", 0),
            
            (5, 2, "Mumbai", 0),
            (6, 2, "Chennai", 0),
            (7, 2, "Delhi", 1),
            (8, 2, "Ahmedabad", 0),
            
            (9, 3, "5", 0),
            (10, 3, "25", 0),
            (11, 3, "40", 1),
            (12, 3, "None", 0),
            
            (13, 4, "11", 0),
            (14, 4, "42", 1),
            (15, 4, "17", 0),
            (16, 4, "None", 0),
            
            (17, 5, "Hindi", 0),
            (18, 5, "Gujarati", 1),
            (19, 5, "Marathi", 0),
            (20, 5, "None", 0),
            
            (21, 6, "124", 0),
            (22, 6, "12", 0),
            (23, 6, "24", 0),
            (24, 6, "None", 1),
            
            (25, 7, "UP", 1),
            (26, 7, "Bihar", 0),
            (27, 7, "Gujarat", 0),
            (28, 7, "Maharashtra", 0),
            
            (29, 8, "Amit Shah", 1),
            (30, 8, "Rajnath Singh", 0),
            (31, 8, "Narendra Modi", 0),
            (32, 8, "None", 0),
            
            (33, 9, "Vadodara", 0),
            (34, 9, "Ahmedabad", 0),
            (35, 9, "Gandhinagar", 1),
            (36, 9, "Rajkot", 0),
            
            (37, 10, "21", 0),
            (38, 10, "36", 1),
            (39, 10, "49", 0),
            (40, 10, "32", 0),
            
            (41, 11, "0", 0),
            (42, 11, "11", 0),
            (43, 11, "-20​", 1),
            (44, 11, "None", 0),
            
            (45, 12, "37", 1),
            (46, 12, "25", 0),
            (47, 12, "10​", 0),
            (48, 12, "12", 0),
            
            (49, 13, "Hindi", 1),
            (50, 13, "English", 0),
            (51, 13, "Gujarati​", 0),
            (52, 13, "None", 0),
            
            (53, 14, "India", 1),
            (54, 14, "USA", 0),
            (55, 14, "UK​", 0),
            (56, 14, "None", 0),
            
            (57, 15, "Java", 0),
            (58, 15, "Java & Kotlin", 1),
            (59, 15, "Kotlin", 0),
            (60, 15, "Swift", 0),
        ]
        for value in values {
            guard database.executeUpdate(insertQuery, withArgumentsIn: [value.0, value.1, value.2, value.3]) else {
                continue
            }
        }
    }
}
