import haxe.Resource;
import utest.Assert;
import utest.Test;

class ValidateCsvFileContents extends Test {
	var csv_file_contents:String;

	function setupClass() {
		csv_file_contents = Resource.getString("CircuitParametersFromPdf");
	}

	function test_resource_is_present() {
		Assert.isTrue(csv_file_contents.length > 0);
	}

	function test_can_load_csv_data() {
		var csv_data = CSV.split_csv_data(csv_file_contents);
		Assert.isTrue(csv_data.length > 0);
		Assert.isTrue(csv_data[0].length > 0);
	}

	function test_every_line_has_enough_columns() {
		var csv_data = CSV.split_csv_data(csv_file_contents);

		var invalid_line_indexes:Array<Int> = [];

		for (index => row in csv_data) {
			if (row.length < 7) {
				invalid_line_indexes.push(index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if(invalid_line_indexes.length > 0){
			trace('check these lines:');
			trace(invalid_line_indexes);
		}
	}
}
