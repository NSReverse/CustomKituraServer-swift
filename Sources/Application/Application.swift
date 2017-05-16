import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudFoundryConfig
import SwiftMetrics
import SwiftMetricsDash


public let router = Router()
public let manager = ConfigurationManager()
public var port: Int = 8080

let location = FileManager.default.currentDirectoryPath
let documentLocation = location + "/public_html/"

public func initialize() throws {
    print("Server running from: " + location)
    
    router.get("/") { (request, response, next) in
        do {
            try response.send(fileName: getFile(fileName: "index.html"))
        }
        catch {
            response.send("Error: index.html doesn't exist.")
        }
    }
    
    router.get("/:name") { (request, response, next) in
        var parameter = request.parameters["name"]!
        
        print("Parsing and sending /\(parameter)")
        
        if (parameter.contains("/")) {
            parameter = parameter.substring(to: parameter.index(before: parameter.endIndex))
        }
        
        do {
            try response.send(fileName: getFile(fileName: "\(request.parameters["name"]!).html"))
        }
        catch {
            print("Error loading page: \(error.localizedDescription)")
            response.send("Unable to locate resource on this server: \(request.parameters["name"]!)")
        }
        
        print("Sending \(request.parameters["name"]!).html")
    }
    
    router.get("/css/:name") { (request, response, next) in
        print("Sending stylesheet resource: \(request.parameters["name"]!)")
        
        do {
            try response.send(fileName: getFile(fileName: "css/\(request.parameters["name"]!)"))
        }
        catch {
            print("Error loading stylesheet: \(error.localizedDescription)")
            response.send("Unable to locate resource on this server: \(request.parameters["name"]!)")
        }
    }
    
    router.get("/js/:name") { (request, response, next) in
        print("Sending JavaScript resource: \(request.parameters["name"]!)")
        
        do {
            try response.send(fileName: getFile(fileName: "js/\(request.parameters["name"]!)"))
        }
        catch {
            print("Error loading JavaScript: \(error.localizedDescription)")
            response.send("Unable to locate resource on this server: \(request.parameters["name"]!)")
        }
    }
    
    router.get("/images/:name") { (request, response, next) in
        print("Retrieving image asset: \(request.parameters["name"]!)")
        
        do {
            try response.send(fileName: getFile(fileName: "images/\(request.parameters["name"]!)"))
        }
        catch {
            print("Failed to load image asset: \(error.localizedDescription)")
            response.send("Unable to locate resource on this server: \(request.parameters["name"]!)")
        }
    }
}

public func run() throws {
    Kitura.addHTTPServer(onPort: port, with: router)
    Kitura.run()
}

public func getFile(fileName: String) -> String {
    var publicDirectory = "/Users/robert/Desktop/public_html/"
    publicDirectory = documentLocation
    
    print("Reference to \(publicDirectory)\(fileName) requested.")
    return publicDirectory + fileName
}
