# test outputs binary data, so redirect it. the doc also says -j1, so:
make -j1 test > vim-tests.log
grep "ALL DONE" vim-tests.log
