@echo off
setlocal

pushd forge-runtime
zig build %*
popd

endlocal
