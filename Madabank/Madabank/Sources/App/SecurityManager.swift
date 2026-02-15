import Foundation
import IOSSecuritySuite
import UIKit

final class SecurityManager {
    static let shared = SecurityManager()
    
    private init() {}
    
    func performSecurityChecks() {
        // checks if runtime is hooked (reverse engineering tools)
        let amIRuntimeHooked = IOSSecuritySuite.amIRuntimeHooked(
            dyldAllowList: [],
            detectionClass: SecurityManager.self,
            selector: #selector(dummySelector),
            isClassMethod: false
        )
        
        // checks if device is jailbroken
        let amIJailbroken = IOSSecuritySuite.amIJailbroken()
        
        // checks if debugger is attached
        let amIDebugged = IOSSecuritySuite.amIDebugged()
        
        // checks if device is an emulator
        let amIEmulator = IOSSecuritySuite.amIRunInEmulator()
        
        if amIJailbroken || amIDebugged || amIRuntimeHooked || amIEmulator {
            handleSecurityViolation(
                jailbroken: amIJailbroken,
                debugged: amIDebugged,
                hooked: amIRuntimeHooked,
                emulator: amIEmulator
            )
        }
    }
    
    @objc private func dummySelector() {}
    
    private func handleSecurityViolation(jailbroken: Bool, debugged: Bool, hooked: Bool, emulator: Bool) {
        debugPrint("Security Violation Detected:")
        debugPrint("Jailbroken: \(jailbroken)")
        debugPrint("Debugged: \(debugged)")
        debugPrint("Runtime Hooked: \(hooked)")
        debugPrint("Emulator: \(emulator)")
        
        // In a real app, you might want to show an alert and terminate, or limit functionality.
        // For now, we just log it to avoiding blocking legitimate development/testing if not intended.
        // However, standard practice is to terminate or show a blocking UI.
        
        #if !DEBUG
        // In production, you might want to crash or exit
        // fatalError("Security violation detected")
        #endif
    }
}
