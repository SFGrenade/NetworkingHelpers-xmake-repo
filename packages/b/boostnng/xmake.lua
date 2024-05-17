package("boostnng")
    set_homepage("https://github.com/SFGrenade/BoostNng-Cpp/")
    set_description("A helper to use zeromq and protobuf together")
    set_license("MPL-2.0")

    set_urls("https://github.com/SFGrenade/BoostNng-Cpp/archive/refs/tags/v$(version).tar.gz",
             "https://github.com/SFGrenade/BoostNng-Cpp.git")

    add_deps("boost")
    add_deps("nng")

    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean", readonly = true})

    on_load("windows", "macosx", "linux", function (package)
        if package:gitref() or package:version():gt("0.8") then
            package:add("deps", "hedley")
        end
        if package:config("shared") then
            package:add("defines", "BOOSTNNG_IS_SHARED")
        end
    end)

    on_install("windows", "macosx", "linux", function (package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
        }
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                BoostNng::ReqRep network( "tcp://127.0.0.1:13337", false );
                network.run();
            }
        ]]}, {configs = {languages = "c++17"}, includes = "boostNng/reqRep.hpp"}))
    end)
