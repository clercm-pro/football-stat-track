allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// Workaround for plugins (e.g. isar_flutter_libs) that don't declare an
// Android Gradle Plugin namespace, which newer AGP versions require.
subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            extensions.findByName("android")?.withGroovyBuilder {
                if (getProperty("namespace") == null) {
                    setProperty("namespace", "dev.isar.${project.name}")
                }
            }
        }
    }
}

rootProject.tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
