const std = @import("std");
const c = @cImport(@cInclude("miniz.h")); // This works after adding miniz.c to the build

pub const FileEntry = struct {
    source_path: []const u8,
    archive_path: []const u8,
};

pub fn createZip(allocator: std.mem.Allocator, archive_name: []const u8, files: []const FileEntry) !void {
    // Allocate null-terminated strings for C compatibility
    const archive_name_z = try allocator.dupeZ(u8, archive_name);
    defer allocator.free(archive_name_z);

    var zip_archive: c.mz_zip_archive = std.mem.zeroes(c.mz_zip_archive);

    // Initialize the ZIP writer for a file
    if (c.mz_zip_writer_init_file(&zip_archive, archive_name_z.ptr, 0) == c.MZ_FALSE) {
        return error.ZipInitFailed;
    }
    defer _ = c.mz_zip_writer_end(&zip_archive); // Clean up on exit

    for (files) |file| {
        const source_path_z = try allocator.dupeZ(u8, file.source_path);
        defer allocator.free(source_path_z);

        const archive_path_z = try allocator.dupeZ(u8, file.archive_path);
        defer allocator.free(archive_path_z);

        // Add file from disk with the specified archive path (directories via '/')
        if (c.mz_zip_writer_add_file(&zip_archive, archive_path_z.ptr, source_path_z.ptr, null, 0, c.MZ_DEFAULT_LEVEL) == c.MZ_FALSE) {
            return error.ZipAddFileFailed;
        }
    }

    // Finalize the archive
    if (c.mz_zip_writer_finalize_archive(&zip_archive) == c.MZ_FALSE) {
        return error.ZipFinalizeFailed;
    }
}

// Example usage
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const files = [_]FileEntry{
        .{ .source_path = "./testfiles/file1.txt", .archive_path = "file1.txt" },
        .{ .source_path = "./testfiles/file2.txt", .archive_path = "subdir/nested/file2.txt" },
    };

    try createZip(allocator, "output.zip", &files);
    std.debug.print("ZIP created successfully!\n", .{});
}
