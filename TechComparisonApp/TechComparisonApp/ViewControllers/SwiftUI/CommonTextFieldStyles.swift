import SwiftUI

// MARK: - Text Field Styles

/// Стиль для KMP версий SwiftUI (более простой)
struct KMPTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .font(.body)
    }
}

/// Стиль для нативных версий SwiftUI (с границей)
struct NativeTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                    )
            )
    }
} 