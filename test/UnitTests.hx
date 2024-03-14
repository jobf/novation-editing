
import utest.ui.Report;
import utest.Runner;

function main() {
	var runner = new Runner();
	runner.addCase(new ValidateCsvFileContents());
	runner.addCase(new ValidateRawParameterData());
	Report.create(runner);
	runner.run();
}
