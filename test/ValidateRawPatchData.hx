import CSV;
import haxe.Resource;
import PatchParsing;
import utest.Assert;
import utest.Test;

class ValidateRawPatchData extends Test {
	var csv_lines:Array<String>;
	var raw_format_data:Array<PatchCsvFormat>;
	var line_index_offset:Int;

	function setupClass() {
		var csv_file_contents = Resource.getString("CircuitSysExPatchCsv");
		var csv_lines = CSV.to_lines(csv_file_contents);
		var header_line_count = 1;
		line_index_offset = header_line_count + 1;
		raw_format_data = [for (line in csv_lines) PatchCsvFormat.from_row(to_columns(line))].slice(header_line_count);
	}

	function test_address_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;
			if (line.address.length <= 0) {
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!address_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_defined_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;

			var defined_value = extract_7_bit_int(line.defined);

			// can only be between 0 and 127
			if (defined_value < 0 || defined_value > 127) {
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!defined_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_minimum_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;

			var minimum_value = extract_7_bit_int(line.minimum);

			// when minimum is a hyphen we can ignore it, the parsed int should be null
			if (line.minimum == "-") {
				if (minimum_value != null) {
					invalid_line_indexes.push(line_index);
				}
			} else if (minimum_value < 0 || minimum_value > 127) {
				// can only be between 0 and 127
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!minimum_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_maximum_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;

			var maximum_value = extract_7_bit_int(line.maximum);

			// when maximum is a hyphen we can ignore it, the parsed int should be null
			if (line.maximum == "-") {
				if (maximum_value != null) {
					invalid_line_indexes.push(line_index);
				}
			} else if (maximum_value < 0 || maximum_value > 127) {
				// can only be between 0 and 127
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!maximum_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_name_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;

			// the name should not be empty
			if (line.name.length <= 0) {
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!name_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}

	function test_bit_shift_is_valid() {
		var invalid_line_indexes:Array<Int> = [];

		for (index => line in raw_format_data) {
			var line_index = index + line_index_offset;

			// bit shift should either be empty or have expected syntax
			if (line.bit_shift.length >= 0) {
				var bit_shift_indexes = extract_bit_shift(line.bit_shift);

				if (StringTools.contains(line.bit_shift, "bits")) {
					// if there are multiple bits to shift then there should be multiple entries
					if (bit_shift_indexes.length <= 1) {
						invalid_line_indexes.push(line_index);

					}
					trace(bit_shift_indexes);
				} else {
					// there should be a single value
					if (bit_shift_indexes.length != 1) {
						invalid_line_indexes.push(line_index);
					}
				}
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!bit_shift_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}
}
