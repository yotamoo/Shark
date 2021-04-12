enum SharkEnumBuilder {
    private static let bundleString = """
        private static let bundle: Bundle = {
            class Custom {}
            return Bundle(for: Custom.self)
        }()
        """

    static func sharkEnumString(forOptions options: Options) throws -> String {
        let resourcePaths = try XcodeProjectHelper(options: options).resourcePaths()
        
        let imagesString = try ImageEnumBuilder.imageEnumString(forFilesAtPaths: resourcePaths.assetsPaths, topLevelName: "I")
        let colorsString = try ColorEnumBuilder.colorEnumString(forFilesAtPaths: resourcePaths.assetsPaths, topLevelName: "C")
        let localizationsString = try LocalizationEnumBuilder.localizationsEnumString(forFilesAtPaths: resourcePaths.localizationPaths, topLevelName: "L")
        let fontsString = try FontEnumBuilder.fontsEnumString(forFilesAtPaths: resourcePaths.fontPaths, topLevelName: "F")

        let declarationIndendationLevel = options.topLevelScope ? 0 : 1
        let resourcesEnumsString = [imagesString, colorsString, fontsString, localizationsString]
            .compactMap { $0 }
            .joined(separator: "\n\n")

        // bundleString + the I, C, F, L enums if present
        let declarations = """
        \(bundleString)

        \(resourcesEnumsString)
        """
            .indented(withLevel: declarationIndendationLevel)

        if options.topLevelScope {
            return declarations
        } else {
            return """
        public enum \(options.topLevelEnumName) {
        \(declarations)
        }
        """
        }
    }
}
