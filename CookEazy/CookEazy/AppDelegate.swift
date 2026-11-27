//
//  AppDelegate.swift
//  CookEazy
//
//  Shared file created on 2026-11-09.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var databaseName : String = "CookEazy.sql"
    var databasePath : String = ""
    var recipes : [RecipeData] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName)
        
        checkAndCreateDatabase()
        readRecipeDataFromDatabase()
        
        return true
    }
    
    // Loads every recipe (and its ingredient lines) from the database into the
    // shared recipes array; call again after any insert, update or delete
    func readRecipeDataFromDatabase() {
        recipes.removeAll()

        var db : OpaquePointer? = nil

        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            print("Opened DB at \(databasePath)")

            // SQLite ignores foreign keys unless this is set on every connection
            sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)

            var queryStatement : OpaquePointer? = nil
            // Column names are listed so the positions below can't shift if the table changes
            let queryStatementString : String = "select recipe_id, name, cook_time_min, servings, steps, is_template, source, created_at from recipes order by name"

            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {

                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let cookTime : Int = Int(sqlite3_column_int(queryStatement, 2))
                    let servings : Int = Int(sqlite3_column_int(queryStatement, 3))
                    let csteps = sqlite3_column_text(queryStatement, 4)
                    // SQLite stores booleans as 0/1
                    let isTemplate : Bool = sqlite3_column_int(queryStatement, 5) == 1
                    let csource = sqlite3_column_text(queryStatement, 6)
                    let ccreated = sqlite3_column_text(queryStatement, 7)

                    let name = String(cString: cname!)
                    let steps = String(cString: csteps!)
                    let source = String(cString: csource!)
                    let createdAt = String(cString: ccreated!)

                    let data : RecipeData = .init()
                    data.initWithData(theId: id, theName: name, theCookTimeMinutes: cookTime,
                                      theServings: servings, theSteps: steps,
                                      theIsTemplate: isTemplate, theSource: source,
                                      theCreatedAt: createdAt,
                                      theIngredients: readIngredients(db: db, recipeId: id))
                    recipes.append(data)

                    print("Query result")
                    print("\(id) | \(name) | \(cookTime) min | \(servings) servings")
                    print("--------------------------------------")
                }
                sqlite3_finalize(queryStatement)

            } else {
                print("Select could not be prepared")
            }

            sqlite3_close(db)

        } else {
            print("Unable to open DB")
        }
    }
    
    // Loads the ingredient lines for one recipe, ordered by position
    func readIngredients(db: OpaquePointer?, recipeId: Int) -> [RecipeIngredientData] {
        var lines : [RecipeIngredientData] = []
        var queryStatement : OpaquePointer? = nil
        let queryStatementString : String = "select i.ingredient_id, i.name, i.unit, i.calories_per_unit, ri.quantity, ri.position from recipe_ingredients ri join ingredients i on i.ingredient_id = ri.ingredient_id where ri.recipe_id = ? order by ri.position"

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // Bind the recipe id to the ? placeholder (placeholders count from 1)
            sqlite3_bind_int(queryStatement, 1, Int32(recipeId))

            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let cname = sqlite3_column_text(queryStatement, 1)
                let cunit = sqlite3_column_text(queryStatement, 2)

                let ingredient : IngredientData = .init()
                ingredient.initWithData(theId: Int(sqlite3_column_int(queryStatement, 0)),
                                        theName: String(cString: cname!),
                                        theUnit: String(cString: cunit!),
                                        theCaloriesPerUnit: sqlite3_column_double(queryStatement, 3))

                let line : RecipeIngredientData = .init()
                line.initWithData(theIngredient: ingredient,
                                  theQuantity: sqlite3_column_double(queryStatement, 4),
                                  thePosition: Int(sqlite3_column_int(queryStatement, 5)))
                lines.append(line)
                
                print("Ingredient result (recipe \(recipeId))")
                print("\(line.position ?? 0). \(ingredient.name ?? "") | \(line.quantity ?? 0) \(ingredient.unit ?? "") | \(ingredient.caloriesPerUnit ?? 0) cal/unit | \(line.calories) cal")
            }
        } else {
            print("Ingredient select could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return lines
    }
    
    func checkAndCreateDatabase() {
        var success = true
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath)
        
        if success { return }
        
        let databasePathFromApp = (Bundle.main.resourcePath?.appending("/" + databaseName))!
        
        try? fileManager.copyItem(atPath: databasePathFromApp, toPath: databasePath)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

