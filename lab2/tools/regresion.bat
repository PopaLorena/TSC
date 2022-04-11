::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

call run_test.bat 2222;
call run_test.bat 4444;
call run_test.bat 5555;
call run_test.bat 6666;
call run_test.bat 7777;
call run_test.bat 8888;
call run_test.bat 9999;
call run_test.bat 3456;
call run_test.bat 4567;
call run_test.bat 5677;

