mv Fibonacci_testbench.v Fibonacci_testbench
iverilog *.v
./a.out > /dev/null
diff ../testdata/output.txt ../testdata/output_ref.txt
mv Fibonacci_testbench Fibonacci_testbench.v

mv testbench.v testbench
iverilog *.v
./a.out > /dev/null
diff ../testdata/Fibonacci_output.txt ../testdata/Fibonacci_output_ref.txt
mv testbench testbench.v
