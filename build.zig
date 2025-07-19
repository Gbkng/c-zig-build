const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cc_flags = &.{
        "-std=c23",
        "-Wall",
        "-Wextra",
        "-Werror",
        // below is for generation of compilation database
        // ref: https://github.com/ziglang/zig/issues/9323#issuecomment-1646590552
        "-gen-cdb-fragment-path",
        ".cache/cdb",
    };

    // The `.cache` directory is needed for generation of `cdb` files. Those
    // files are required for generation of the compilation database
    // (`compile_commands.json`).
    try std.fs.cwd().makePath(".cache");
    const gen_comp_db_step = b.step("gen-comp-db", "Generate compilation database");
    const gen_comp_db_run = b.addSystemCommand(&.{"./generate_compcmd_json.sh"});
    gen_comp_db_step.dependOn(&gen_comp_db_run.step);

    // TODO if bash is not found, do not generate compilation database instead
    // of panicking
    _ = try b.findProgram(&.{"bash"}, &.{ "/usr/bin", "/bin" });
    b.getInstallStep().dependOn(gen_comp_db_step);

    const foolib = b.addLibrary(.{
        .linkage = .static,
        .name = "foo",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
        }),
    });
    foolib.addCSourceFiles(.{
        .files = &.{
            "src/foo.c",
        },
        .flags = cc_flags,
    });
    b.installArtifact(foolib);

    const exe = b.addExecutable(.{
        .name = "main",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFiles(.{
        .files = &.{
            "src/bin/main.c",
        },
        .flags = cc_flags,
    });
    exe.linkLibC();
    exe.linkSystemLibrary("mpi");
    exe.linkSystemLibrary("ncurses");
    exe.linkLibrary(foolib);
    exe.addIncludePath(b.path("src"));

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);

    // add a pure Zig executable using C library defined above 
    const bar_exe = b.addExecutable(
        .{
            .name = "bar",
            .root_source_file = b.path("src/bar.zig"),
            .target = target,
            .optimize = optimize,
        },
    );
    bar_exe.addIncludePath(b.path("src"));
}
