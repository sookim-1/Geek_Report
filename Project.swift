import ProjectDescription

// MARK: - 스키마
let schemes: [Scheme] = [
    Scheme.scheme(
        name: "Geek Report Debug",
        shared: true,
        buildAction: .buildAction(targets: ["GeekReport"]),
        runAction: .runAction(configuration: "Debug"),
        archiveAction: .archiveAction(configuration: "Debug"),
        profileAction: .profileAction(configuration: "Debug"),
        analyzeAction: .analyzeAction(configuration: "Debug")
    ),
    Scheme.scheme(
        name: "GeekReport",
        shared: true,
        buildAction: .buildAction(targets: ["GeekReport"]),
        runAction: .runAction(configuration: "Release"),
        archiveAction: .archiveAction(configuration: "Release"),
        profileAction: .profileAction(configuration: "Release"),
        analyzeAction: .analyzeAction(configuration: "Release")
    ),
]

// MARK: - 세팅
let configurations: [Configuration] = [
    .debug(
        name: "Debug",
        xcconfig: .relativeToRoot("Configurations/GeekReportBeta.xcconfig")
    ),
    .release(
        name: "Release",
        xcconfig: .relativeToRoot("Configurations/GeekReportRelease.xcconfig")
    )
]

let settings = Settings.settings(configurations: configurations)



// MARK: - 타겟
let geekReportTarget = Target.target(name: "GeekReport",
                                     destinations: [.iPhone],
                                     product: .app,
                                     bundleId: "com.sookim.GeekReport",
                                     deploymentTargets: .iOS("17.0"),
                                     infoPlist: "GeekReport/Info.plist",
                                     sources: ["GeekReport/Sources/**"],
                                     resources: ["GeekReport/Resources/**"],
                                     dependencies: [
                                        .package(product: "SnapKit"),
                                        .package(product: "Then"),
                                        .package(product: "RxSwift"),
                                        .package(product: "RxGesture"),
                                        .package(product: "Kingfisher")
                                     ],
                                     settings: settings,
                                     coreDataModels: [.coreDataModel(("GeekReport/Sources/Data/PersistentStorage/CoreDataStorage/CoreDataStorage.xcdatamodeld"))])

// MARK: 프로젝트
let project = Project(name: "GeekReport",
                      organizationName: "sookim-1",
                      packages: [
                          .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.7.1")),
                          .remote(url: "https://github.com/devxoul/Then.git", requirement: .upToNextMajor(from: "3.0.0")),
                          .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.6.0")),
                          .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.4")),
                          .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.11.0"))
                      ],
                      settings: settings,
                      targets: [geekReportTarget],
                      schemes: schemes)
