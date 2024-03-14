import ParameterParsing;
import haxe.Resource;
import utest.Assert;
import utest.Test;

class ValidateRawParameterData extends Test {
	var csv_lines:Array<String>;
	var raw_parameter_data:Array<PdfDataFormat>;
	var line_index_offset:Int;

	function setupClass() {
		var csv_file_contents = Resource.getString("CircuitParametersFromPdf");
		var csv_lines = CSV.to_lines(csv_file_contents);
		var header_line_count = 1;
		line_index_offset = header_line_count + 1;
		raw_parameter_data = [for (line in csv_lines) PdfDataFormat.from_line(line)].slice(header_line_count);
	}

	function test_message_type_is_cc_or_nrpn() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_parameter_data) {
			var line_index = index + line_index_offset;
			if (line.message_type != "CC" && line.message_type != "NRPN") {
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_cc_control_number_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_parameter_data) {
			var line_index = index + line_index_offset;
			if (line.message_type == "CC") {
				var control_number = extract_cc_control_number(line.control_number);
				if (control_number == null) {
					invalid_line_indexes.push(line_index);
				}

				// midi cc cannot be greater than 127
				if (control_number > 127) {
					invalid_line_indexes.push(line_index);
				}

				// midi cc cannot be less than 127
				if (control_number < 0) {
					invalid_line_indexes.push(line_index);
				}
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_nrpn_control_number_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_parameter_data) {
			var line_index = index + line_index_offset;
			if (line.message_type == "NRPN") {
				var numbers = extract_nrpn_control_numbers(line.control_number);
				if (numbers.length == 2) {
					for (control_number in numbers) {
						if (control_number == null) {
							invalid_line_indexes.push(line_index);
						}

						// midi nrpn cannot be greater than 16383
						if (control_number > 16383) {
							invalid_line_indexes.push(line_index);
						}

						// midi nrpn cannot be less than 127
						if (control_number < 0) {
							invalid_line_indexes.push(line_index);
						}
					}
				} else {
					invalid_line_indexes.push(line_index);
				}
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('check these lines:');
			trace(invalid_line_indexes);
		}
	}
}
