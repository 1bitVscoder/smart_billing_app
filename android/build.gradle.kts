allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)

    // 🚀 THE MAGIC FIX: Programmatically inject namespaces into legacy plugins (like our printer)
    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val getNamespace = androidExt.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(androidExt)
                if (namespace == null) {
                    val setNamespace = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(androidExt, project.group.toString())
                }
            } catch (e: Exception) {
                // Safely ignore if the plugin structure differs
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}