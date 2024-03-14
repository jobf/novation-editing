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
			trace('!message_type_is_cc_or_nrpn check these lines:');
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
			trace('!cc_control_number_is_valid check these lines:');
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
			trace('!nrpn_control_number_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_range_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_parameter_data) {
			var line_index = index + line_index_offset;
			var ranges = extract_range(line.range);

			// there needs to be at least 1 range but no more than 2
			if (ranges.length < 1 || ranges.length > 2) {
				invalid_line_indexes.push(line_index);
			}

			var midi_range = ranges[0];

			// need 2 values for range (start and end)
			if (midi_range.length < 2) {
				invalid_line_indexes.push(line_index);
			}

			for (i in midi_range) {
				// MIDI value cannot be null, less than 0 or more than 127
				if (i == null || i < 0 || i > 127) {
					invalid_line_indexes.push(line_index);
				}
			}

			if (ranges.length > 1) {
				var display_range = ranges[1];
			
				// need 2 values for range (start and end)
				if (display_range.length < 2) {
					invalid_line_indexes.push(line_index);
				}

				for (i in display_range) {
					// display value cannot be null, less than -127 or more than 127
					if (i == null || i < -127 || i > 127) {
						invalid_line_indexes.push(line_index);
					}
				}
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!range_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_default_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_parameter_data) {
			var line_index = index + line_index_offset;

			var default_value = extract_default(line.default_value);
			if (default_value == null) {
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!default_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}
}
