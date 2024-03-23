import PatchParsing.PatchCsvFormat;
import utest.Test;
import utest.Assert;
import CSV;
import haxe.Resource;
import PatchEditing;

class ValidateRawPatchData extends Test{

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
			if(line.address.length <= 0){
				invalid_line_indexes.push(line_index);
			}
		}

		Assert.equals(0, invalid_line_indexes.length);

		if (invalid_line_indexes.length > 0) {
			trace('!address_is_valid check these lines:');
			trace(invalid_line_indexes);
		}
	}
}

