import UIKit
import ComposeApp

class TestKMMAccess {
    static func test() {
        print("🧪 Testing KMM Access Patterns...")
        
        // Test 1: Companion access
        do {
            print("📱 Testing companion access...")
            let companion = ComposeApp.KMPManager.companion
            print("✅ Companion accessed: \(companion)")
            
            let manager = companion.shared
            print("✅ Manager from companion: \(manager)")
            
            let info = manager.getKMMInfo()
            print("✅ KMM Info: \(info.prefix(30))...")
            
        } catch {
            print("❌ Companion access failed: \(error)")
        }
        
        // Test 2: Task creation
        do {
            print("📝 Testing Task creation...")
            let taskCompanion = ComposeApp.Task.companion
            let sampleTasks = taskCompanion.createSampleTasks()
            print("✅ Sample tasks: \(sampleTasks.count)")
            
        } catch {
            print("❌ Task creation failed: \(error)")
        }
        
        // Test 3: User validation
        do {
            print("👤 Testing User validation...")
            let userCompanion = ComposeApp.User.companion
            let isValid = userCompanion.isValidUsername(username: "admin")
            print("✅ User validation: \(isValid)")
            
        } catch {
            print("❌ User validation failed: \(error)")
        }
        
        print("🎉 KMM Access Test Complete!")
    }
} 