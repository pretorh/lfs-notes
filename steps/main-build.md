# Building the LFS system

These notes are from Chapter 8 of the 10.0 version

## setup

These steps need to be done in chroot - reenter after cleanup/backup or a restore from a backup. See notes in chroot setup (`steps/6-install.md`)

Todo: recheck enter scripts, since `mknod` commands fail (already exists)

See notes about package management

## packages

- man-pages
    - no configure, build (just `make install`)
    - time: negligible
- tcl
    - custom archive name, also extract the documentation archive
    - custom build commands (sed to replace build dir)
        - see `scripts/6/main/tcl-post-build.sh`
    - post install steps for headers, symlink
        - `make install-private-headers`
        - `ln -sv tclsh8.6 /tools/bin/tclsh`
    - tests
        - some known errors in `clock.test`
        - also had errors in `tdbcmysql.test`, `tdbcodbc.test`, `tdbcpostgres.test` (libraries not found)
        - todo: filter output log for lines like `all.tcl:        Total   24996   Passed  21651   Skipped 3345    Failed  0`
    - time: 0.8x (0.5x for parallel) + 1.4x for tests
