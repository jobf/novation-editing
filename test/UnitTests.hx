
import utest.ui.Report;
import utest.Runner;

function main() {
	var runner = new Runner();
	runner.addCase(new ValidateCsvFileContents());
	runner.addCase(new ValidateRawParameterData());
	runner.addCase(new ParameterEditingTests());
	Report.create(runner);
	runner.run();
}
