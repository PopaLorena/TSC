::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

@REM call run_test_gui.bat 88888 6
call run_test.bat 88888 8
call run_test.bat 99999 6
call run_test.bat 55687 10
call run_test.bat 444344 43
call run_test.bat 746130 38
call run_test.bat 128576 7
call run_test.bat 935755 63
call run_test.bat 667257 64
call run_test.bat 27485 100


