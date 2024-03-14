
import utest.ui.Report;
import utest.Runner;

function main() {
	var runner = new Runner();
	runner.addCase(new ValidateCsvFileContents());
	Report.create(runner);
	runner.run();
}
