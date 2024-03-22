import haxe.Resource;
import utest.Assert;
import utest.Test;

class ValidateCsvFileContents extends Test {
	var csv_parameters_content:String;
	var csv_patch_content:String;

	function setupClass() {
		csv_parameters_content = Resource.getString("CircuitParametersFromPdf");
		csv_patch_content = Resource.getString("CircuitSysExPatchCsv");
	}

	function test_resources_are_presen() {
		Assert.isTrue(csv_parameters_content.length > 0);
		Assert.isTrue(csv_patch_content.length > 0);
	}

	function test_can_load_csv_parameter_data() {
		var csv_data = CSV.split_csv_data(csv_parameters_content);
		Assert.isTrue(csv_data.length > 0);
		Assert.isTrue(csv_data[0].length > 0);
	}

	function test_can_load_csv_patch_data() {
		var csv_data = CSV.split_csv_data(csv_patch_content);
		Assert.isTrue(csv_data.length > 0);
		Assert.isTrue(csv_data[0].length > 0);
	}

	function test_parameter_data_lines_have_enough_columns() {
		var csv_data = CSV.split_csv_data(csv_parameters_content);

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


	function test_patch_data_lines_have_enough_columns() {
		var csv_data = CSV.split_csv_data(csv_patch_content);

		var invalid_line_indexes:Array<Int> = [];

		for (index => row in csv_data) {
			if (row.length < 6) {
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
