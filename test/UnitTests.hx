import haxe.Resource;
import utest.Assert;
import utest.Test;
import utest.ui.Report;
import utest.Runner;

function main()
{
	var runner = new Runner();
	runner.addCase(new ValidateCsv());
	Report.create(runner);
	runner.run();
}

class ValidateCsv extends Test
{
	var csv_file_contents:String;

	function setupClass(){
		csv_file_contents = Resource.getString("CircuitParametersFromPdf");
	}

	function test_resource_is_present(){
		Assert.isTrue(csv_file_contents.length > 0);
	}

	function test_can_load_csv_data(){
		var csv_data = CSV.split_csv_data(csv_file_contents);
		Assert.isTrue(csv_data.length > 0);
		Assert.isTrue(csv_data[0].length > 0);
	}
}