// Root project-level build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Đổi buildDirectory ra ngoài root project
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Subproject build directory riêng
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Đảm bảo app module được evaluate trước
subprojects {
    project.evaluationDependsOn(":app")
}

// Task clean cho toàn bộ project
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
