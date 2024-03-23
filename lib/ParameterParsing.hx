import StringUtils;

@:structInit
@:publicFields
class ParameterCsvFormat {
	var section:String;
	var parameter:String;
	var message_type:String;
	var control_number:String;
	var range:String;
	var default_value:String;
	var notes:String;

	static function from_line(csv_line:String):ParameterCsvFormat {
		var columns = CSV.to_columns(csv_line);
		return {
			section: columns[0],
			parameter: columns[1],
			message_type: columns[2],
			control_number: columns[3],
			range: columns[4],
			default_value: columns[5],
			notes: columns[6]
		}
	}

	static function from_row(columns:Array<String>):ParameterCsvFormat {
		return {
			section: columns[0],
			parameter: columns[1],
			message_type: columns[2],
			control_number: columns[3],
			range: columns[4],
			default_value: columns[5],
			notes: columns[6]
		}
	}
}

inline function extract_cc_control_number(data:String):Int {
	return Std.parseInt(data);
}

inline function extract_nrpn_control_numbers(data:String):Array<Int> {
	var numbers = data.split(":");
	return [for (item in numbers) Std.parseInt(item)];
}

inline function extract_range(data:String):Array<Array<Int>> {
	var range_numbers:Array<Array<Int>> = [];
	var parts = strip_empty_space(data).split("(");
	var range_data:Array<Int> = [for (text in parts[0].split(":")) Std.parseInt(text)];
	range_numbers.push(range_data);
	if (parts.length > 1) {
		var range_data_display:Array<Int> = [for (text in parts[1].split(":")) Std.parseInt(strip_closing_parenthesis(text))];
		range_numbers.push(range_data_display);
	}

	return range_numbers;
}

inline function extract_default(data:String):Int {
	var cleansed_data = strip_empty_space(data);
	var parts = cleansed_data.split("(");
	return Std.parseInt(parts[0]);
}
